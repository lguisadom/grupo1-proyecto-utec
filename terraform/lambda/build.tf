resource "null_resource" "lambda_builds" {
  triggers = {
    get_clientes_hash = filemd5("${var.lambda_source_dir}/get-clientes/get-clientes.mjs")
    get_cliente_by_id_hash = filemd5("${var.lambda_source_dir}/get-cliente-by-id/get-cliente-by-id.mjs")
    package_json_hash = filemd5("../package.json")
  }

  provisioner "local-exec" {
    working_dir = ".."
    command     = "yarn build:all"
  }
} 