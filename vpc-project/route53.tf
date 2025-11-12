# Get the public hosted zone
data "aws_route53_zone" "public_zone" {
  name         = "730335229139.realhandsonlabs.net"  # replace with your domain
  private_zone = false           # ensures only public zones are matched
}

# Create alias record for ALB
resource "aws_route53_record" "alb_alias" {
  depends_on = [ aws_lb.frontend_alb ]
  zone_id = data.aws_route53_zone.public_zone.zone_id
  name    = "730335229139.realhandsonlabs.net"  # subdomain
  type    = "A"

  alias {
    name                   = aws_lb.frontend_alb.dns_name
    zone_id                = aws_lb.frontend_alb.zone_id
    evaluate_target_health = true
  }
}
resource "aws_route53_record" "backend_alb" {
    zone_id = aws_route53_zone.private_zone.zone_id
    name    = "backend.730335229139.realhandsonlabs.net"
    type    = "A"

    alias {
        name                   = aws_lb.backend_alb.dns_name 
        zone_id                = aws_lb.backend_alb.zone_id
        evaluate_target_health = true
    }
    depends_on = [ aws_lb.backend_alb ]
}

resource "aws_route53_zone" "private_zone" {
  name        = var.zone_name           
  comment     = "Private hosted zone for example"

  vpc {
    vpc_id = aws_vpc.tier_appliction.id     
  }
}

# Create private hosted zone


