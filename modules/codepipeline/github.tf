provider "github" {
  individual = true
  token      = var.github_token
}

#
# Github Integration
#

locals {
  repository_full_name = "${var.github_repository_owner}/${var.github_repository_name}"
}

resource "aws_codebuild_webhook" "github_webhook" {
  project_name = aws_codebuild_project.this.name
}

resource "github_repository_webhook" "this" {

  active = true
  events = ["push"]
  # name   = "cp-${local.project_name_slug}-webhooks"
  # repository = data.github_repository.this.name
  repository = local.repository_full_name

  configuration {
    url          = aws_codebuild_webhook.github_webhook.payload_url
    secret       = aws_codebuild_webhook.github_webhook.secret
    content_type = "json"
    insecure_ssl = false
  }
}
