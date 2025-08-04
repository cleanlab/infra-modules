variable "release_name" {
    description = "Name of the TLM app to deploy"
    type = string
    default = "tlm"
}

variable "namespace" {
    description = "Namespace in which to deploy the TLM app"
    type = string
    default = "tlm"
}

variable "app_version" {
    type = string
    description = "The version of the TLM to deploy"
}

variable "app_image_tag" {
    type = string
    description = "The image tag of the TLM chat backend service to deploy. If null, app_version is used as a fallback."
    default = null
}

variable "registry_server" {
    type = string
    description = "The registry server to pull images from"
    default = "tlmcleanlab.azurecr.io"
}

variable "registry_name" {
    type = string
    description = "The name of the container registry to pull images from for the TLM backend service"
    default = "tlm/chat-backend"
}

variable "image_pull_username" {
    type = string
    description = "The username to pull images from the registry"
}

variable "image_pull_password" {
    type = string
    description = "The password to pull images from the registry"
    sensitive = true
}

variable "default_completion_model" {
    type = string
    description = "The default completion model to use"
}

variable "lowest_latency_model" {
    type = string
    description = "The lowest latency model available"
}

variable "enable_external_access" {
    type = bool
    description = "Whether to enable external access to the chat backend service"
    default = false
}

variable "model_config_file_path" {
  description = "Path to the JSON model providers configuration file"
  type        = string
  default     = ""
}
