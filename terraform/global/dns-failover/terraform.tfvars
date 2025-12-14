domain_name    = "bshubham.site" # Change if you have real domain
subdomain_name = "hadr"

# Mumbai (Primary) ALB information
primary_alb_dns     = "hadr-mumbai-alb-1921255356.ap-south-1.elb.amazonaws.com" # Your actual value
primary_alb_zone_id = "ZP97RAFLXTNZK"                                           # Your actual zone ID

# Virginia (Secondary) ALB information
secondary_alb_dns     = "hadr-virginia-alb-1133300185.us-east-1.elb.amazonaws.com" # Your actual value
secondary_alb_zone_id = "Z35SXDOTRQ7X7K"                                           # Your actual zone ID

# Health check settings
health_check_interval = 10 # Default is 30
failure_threshold     = 2
