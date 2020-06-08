resource "aws_iam_role" "this_pipeline" {
  name        = "${local.project_name_slug}-codepipeline"
  description = "${var.project_name} - Code pipeline"

  max_session_duration = 3600

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role" "this_codebuild" {
  name                 = "${local.project_name_slug}-codebuild"
  description          = "${var.project_name} - CodeBuild"
  path                 = "/service-role/"
  max_session_duration = 3600

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

data "template_file" "role_build_policy" {
  template = file("${path.module}/role_build.json")
  vars = {
    s3_artifact_arn = aws_s3_bucket.codepipeline.arn
    codebuild_name  = aws_iam_role.this_codebuild.name
    current_id      = var.account_id
    region          = var.region
  }
}


resource "aws_iam_role_policy" "this_codebuild" {
  name   = "${local.project_name_slug}-${var.environment}-codebuild-policy"
  role   = aws_iam_role.this_codebuild.id
  policy = data.template_file.role_build_policy.rendered
}

resource "aws_iam_role_policy" this {
  name = "${local.project_name_slug}-${var.environment}-codepipeline-policy"
  role = aws_iam_role.this_pipeline.id

  policy = file("${path.module}/role_pipeline.json")

}
