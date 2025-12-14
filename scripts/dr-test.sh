#!/bin/bash

# DR Testing Script for HADR Project
# Tests automatic failover from Mumbai to Virginia

echo "=========================================="
echo " HADR Disaster Recovery Test"
echo "=========================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
MUMBAI_ASG="hadr-mumbai-asg"
MUMBAI_REGION="ap-south-1"
HEALTH_CHECK_ID=$(cd terraform/global/dns-failover && terraform output -raw health_check_id)

echo "Step 1: Check current health status"
echo "-----------------------------------"
HEALTH_STATUS=$(aws route53 get-health-check-status \
  --health-check-id $HEALTH_CHECK_ID \
  --query 'HealthCheckObservations[0].StatusReport.Status' \
  --output text)

echo -e "Mumbai ALB Health: ${GREEN}$HEALTH_STATUS${NC}"
echo ""

echo "Step 2: Simulate Mumbai region failure"
echo "--------------------------------------"
echo "Setting Mumbai ASG desired capacity to 0..."

aws autoscaling update-auto-scaling-group \
  --region $MUMBAI_REGION \
  --auto-scaling-group-name $MUMBAI_ASG \
  --desired-capacity 0 \
  --min-size 0

echo -e "${YELLOW}Waiting for instances to terminate...${NC}"
sleep 30

echo ""
echo "Step 3: Monitor health check status"
echo "-----------------------------------"
echo "Checking health every 30 seconds (will take 2-3 minutes)..."

for i in {1..6}; do
  HEALTH_STATUS=$(aws route53 get-health-check-status \
    --health-check-id $HEALTH_CHECK_ID \
    --query 'HealthCheckObservations[0].StatusReport.Status' \
    --output text)
  
  if [ "$HEALTH_STATUS" == "Success" ]; then
    echo -e "Check $i: ${GREEN}Healthy${NC}"
  else
    echo -e "Check $i: ${RED}Unhealthy - FAILOVER TRIGGERED!${NC}"
    break
  fi
  
  sleep 30
done

echo ""
echo "Step 4: Verify DNS failover"
echo "--------------------------"
CURRENT_TARGET=$(aws route53 test-dns-answer \
  --hosted-zone-id $(cd terraform/global/dns-failover && terraform output -raw hosted_zone_id) \
  --record-name app.hadr-demo.com \
  --record-type A \
  --query 'RecordData[0]' \
  --output text)

if [[ $CURRENT_TARGET == *"virginia"* ]]; then
  echo -e "${GREEN}✓ DNS now points to Virginia ALB (SECONDARY)${NC}"
  echo -e "${GREEN}✓ Disaster Recovery SUCCESSFUL!${NC}"
else
  echo -e "${YELLOW}DNS still points to Mumbai (health check may need more time)${NC}"
fi

echo ""
echo "Step 5: Instructions for recovery"
echo "---------------------------------"
echo "To restore Mumbai:"
echo "  aws autoscaling update-auto-scaling-group \\"
echo "    --region $MUMBAI_REGION \\"
echo "    --auto-scaling-group-name $MUMBAI_ASG \\"
echo "    --desired-capacity 2 \\"
echo "    --min-size 1"
echo ""
echo "Wait 5 minutes, then DNS will automatically fail back to Mumbai."
echo "=========================================="