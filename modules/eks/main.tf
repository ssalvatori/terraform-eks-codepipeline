data "aws_subnet_ids" "this" {
  vpc_id = var.vpc_id
}

data "aws_subnet" "this" {
  for_each = data.aws_subnet_ids.this.ids
  id       = each.value
}

resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = aws_iam_role.cluster.arn

  vpc_config {
    subnet_ids = [for s in data.aws_subnet.this : s.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSServicePolicy
  ]

  tags = merge({ "Name" = "${var.cluster_name}" }, var.module_tags, var.tags)
}

resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.cluster_name}_workers"
  node_role_arn   = aws_iam_role.node_group.arn
  subnet_ids      = [for s in data.aws_subnet.this : s.id]

  instance_types = var.instance_types

  scaling_config {
    desired_size = var.node_group_desired
    max_size     = var.node_group_max
    min_size     = var.node_group_min
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
}
