# Get the public hosted zone
data "aws_route53_zone" "public_zone" {
  name         = "711784092484.realhandsonlabs.net"  # replace with your domain
  private_zone = false           # ensures only public zones are matched
}

# Create alias record for ALB
resource "aws_route53_record" "alb_alias" {
  depends_on = [ aws_lb.frontend_alb ]
  zone_id = data.aws_route53_zone.public_zone.zone_id
  name    = "711784092484.realhandsonlabs.net"  # subdomain
  type    = "A"

  alias {
    name                   = aws_lb.frontend_alb.dns_name
    zone_id                = aws_lb.frontend_alb.zone_id
    evaluate_target_health = true
  }
}
resource "aws_route53_record" "backend_alb" {
    zone_id = data.aws_route53_zone.public_zone.zone_id
    name    = "backend.711784092484.realhandsonlabs.net"
    type    = "A"

    alias {
        name                   = aws_lb.backend_alb.dns_name 
        zone_id                = aws_lb.backend_alb.zone_id
        evaluate_target_health = true
    }
    depends_on = [ aws_lb.backend_alb ]
}

resource "aws_route53_zone" "private_zone" {
  name        = "rds.internal"           
  comment     = "Private hosted zone for example"

  vpc {
    vpc_id = aws_vpc.tier_appliction.id     
  }
}

# Create private route53 record for rds instance
resource "aws_route53_record" "rds_record" {
  zone_id = aws_route53_zone.private_zone.zone_id
  name    = "db.rds.internal"  
  type    = "CNAME"
  ttl     = 60
  records = [aws_db_instance.my_db.endpoint]
  depends_on = [ aws_db_instance.my_db ]
}


