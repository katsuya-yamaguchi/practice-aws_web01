variable "alb_dns_name" {}
variable "alb_zone_id" {}

resource "aws_route53_zone" "katsuya_place_work" {
  name          = "katsuya-place.work"
  force_destroy = true
}

resource "aws_route53_record" "a_dev" {
  zone_id = aws_route53_zone.katsuya_place_work.id
  name    = "dev.katsuya-place.work"
  type    = "A"
  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "www_dev" {
  zone_id = aws_route53_zone.katsuya_place_work.id
  name    = "www.dev.katsuya-place.work"
  type    = "A"
  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}
