output "apci_jupiter_alb_sg" {
    value = aws_security_group.apci_jupiter_alb_sg.id
}

output "apci_jupiter_tg" {
  value = aws_lb_target_group.apci_jupiter_tg.arn
}