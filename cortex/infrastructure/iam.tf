resource "aws_iam_role" "master" {
  name               = "${var.cluster_name}-k8s-master"
  assume_role_policy = "${data.aws_iam_policy_document.assume.json}"
}

data "aws_iam_policy_document" "assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "master" {
  statement {
    actions   = ["ec2:*"]
    resources = ["*"]
  }

  statement {
    actions   = ["elasticloadbalancing:*"]
    resources = ["*"]
  }

  statement {
    actions   = ["route53:*"]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "master_inline" {
  name   = "${var.cluster_name}-k8s-master"
  role   = "${aws_iam_role.master.id}"
  policy = "${data.aws_iam_policy_document.master.json}"
}

resource "aws_iam_instance_profile" "master" {
  name = "${var.cluster_name}-k8s-master"
  role = "${aws_iam_role.master.name}"
}

resource "aws_iam_role" "worker" {
  name               = "${var.cluster_name}-k8s-worker"
  assume_role_policy = "${data.aws_iam_policy_document.assume.json}"
}

data "aws_iam_policy_document" "worker" {
  statement {
    actions   = ["ec2:Describe*"]
    resources = ["*"]
  }

  statement {
    actions   = ["ec2:AttachVolume"]
    resources = ["*"]
  }

  statement {
    actions   = ["ec2:DetachVolume"]
    resources = ["*"]
  }

  statement {
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:BatchGetImage",
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:GetBucketLocation",
      "s3:ListAllMyBuckets",
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:ListBucket",
    ]

    resources = ["${aws_s3_bucket.cortex.arn}"]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
    ]

    resources = ["${aws_s3_bucket.cortex.arn}/*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "dynamodb:List*",
      "dynamodb:DescribeReservedCapacity*",
      "dynamodb:DescribeLimits",
      "dynamodb:DescribeTimeToLive",
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "dynamodb:BatchGet*",
      "dynamodb:DescribeStream",
      "dynamodb:DescribeTable",
      "dynamodb:Get*",
      "dynamodb:Query",
      "dynamodb:Scan",
      "dynamodb:BatchWrite*",
      "dynamodb:CreateTable",
      "dynamodb:Delete*",
      "dynamodb:Update*",
      "dynamodb:PutItem",
    ]

    resources = [
      "${aws_dynamodb_table.cortex.arn}",
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "route53:ChangeResourceRecordSets",
    ]

    resources = [
      "arn:aws:route53:::hostedzone/${data.terraform_remote_state.core.core_devops_zone_id}",
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "route53:ListHostedZones",
      "route53:ListResourceRecordSets",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "worker_inline" {
  name   = "${var.cluster_name}-k8s-worker"
  role   = "${aws_iam_role.worker.id}"
  policy = "${data.aws_iam_policy_document.worker.json}"
}

resource "aws_iam_instance_profile" "worker" {
  name = "${var.cluster_name}-k8s-worker"
  role = "${aws_iam_role.worker.name}"
}
