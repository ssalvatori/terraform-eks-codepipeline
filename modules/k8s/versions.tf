terraform {
  required_version = "~> 0.12.24"

  required_providers {
    kubernetes = "~> 1.11"
    helm       = "~> 1.2.2"
  }
}
