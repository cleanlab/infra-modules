resource "kubernetes_secret" "image_pull_secret" {
  metadata {
    name = local.image_pull_secret_name
    namespace = local.namespace
  }

  type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "${var.registry_server}" = {
          "username" = var.image_pull_username
          "password" = var.image_pull_password
        }
      }
    })
  }
}
