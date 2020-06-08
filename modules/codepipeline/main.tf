provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "codepipeline" {
  bucket_prefix = "${local.project_name_slug}-cp"
}


resource "aws_codepipeline" "this" {

  name     = "${local.project_name_slug}-cp"
  role_arn = aws_iam_role.this_pipeline.arn

  tags = merge({ "Name" = "${var.project_name}" }, var.module_tags, var.tags)

  artifact_store {
    location = aws_s3_bucket.codepipeline.id
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["SourceArtifact"]

      configuration = {
        OAuthToken = var.github_token,
        Owner      = var.github_repository_owner,
        Repo       = var.github_repository_name,
        Branch     = var.github_repository_branch
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["BuildOutput"]
      version          = "1"

      configuration = {
        ProjectName = "${local.project_name_slug}-build"
      }
    }
  }

}

#
# CodeBuild
#
resource "aws_codebuild_project" "this" {
  name         = "${local.project_name_slug}-build"
  description  = "Code Build for ${var.project_name}"
  service_role = aws_iam_role.this_codebuild.arn

  tags = merge({ "Name" = "${var.project_name}" }, var.module_tags, var.tags)

  artifacts {
    type = "CODEPIPELINE"
  }

  source {
    type = "CODEPIPELINE"
  }


  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  logs_config {
    cloudwatch_logs {
      status = "DISABLED"
      # group_name  = "/aws/codebuild/${var.codebuild_name}"
      # stream_name = "/aws/codebuild/${var.codebuild_name}"
    }

  }

}
