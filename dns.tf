resource "aws_route53_zone" "my_zone"{
    name=var.domain
}

resource "aws_route53_record" "server-1-record"{
    zone_id=aws_route53_zone.my_zone.id
    name="blog.farruwasiq.tk"
    type="A"
    ttl="300"
    records=["18.212.52.55"]

}
resource "aws_route53_record" "www-record"{//adding this domain to new aws console
    zone_id=aws_route53_zone.my_zone.id
    name="www.farruwasiq.tk"
    type="A"
    ttl="300"
    records = [ "54.147.39.231" ]
}


output "ns-servers" {
    value = aws_route53_zone.my_zone.name_servers
  
}
