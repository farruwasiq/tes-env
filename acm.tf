resource "aws_acm_certificate" "cert"{
    domain_name=var.domain
    subject_alternative_names = [ "*.farruwasiq.tk" ]
    validation_method = "DNS"
    lifecycle {
      
      create_before_destroy=true
    }

}