data "aws_" "alb-fil" {
  
}
resource "aws_route53_record" "frontend_alb" {
    zone_id = "YOUR_HOSTED_ZONE_ID" # Replace with your Route 53 hosted zone ID
    name    = "frontend.example.com" # Replace with your desired subdomain
    type    = "A"

    alias {
        name                   = aws_lb.frontend_alb.dns_name 
        zone_id                = aws_lb.frontend_alb.zone_id
        evaluate_target_health = true
    }
    depends_on = [ aws_lb.frontend_alb ]
}