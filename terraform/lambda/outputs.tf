output "get_clientes_arn" {
  value = aws_lambda_function.get_clientes.arn
}

output "get_cliente_by_id_arn" {
  value = aws_lambda_function.get_cliente_by_id.arn
} 