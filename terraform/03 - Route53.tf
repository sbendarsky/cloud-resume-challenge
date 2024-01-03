#Create Route53 Record
resource "aws_route53_record" "cloudfront_record" {
  zone_id = "Z0812785FWYP51NI40L5"  
  name    = "resume"     
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}
