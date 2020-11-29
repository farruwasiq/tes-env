resource "aws_route53_zone" "my_zone"{
    name="farruwasiq.tk"
}
/*
resource "aws_route53_record" "my-dns-record"{
    zone_id=aws_route53_zone.my_zone.id
    name="blog.farruwasiq.tk"
    type="A"
    ttl="300"



}
*/
output "ns-servers" {
    value = aws_route53_zone.my_zone.name_servers
  
}