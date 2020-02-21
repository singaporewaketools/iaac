
# Access Group
##  RW access to example.com/* path
resource "aws_iam_group" "root_rw" {
  name = "${local.id}-root-rw"
}

resource "aws_iam_group_policy_attachment" "root_rw" {
  group      = aws_iam_group.root_rw.name
  policy_arn = aws_iam_policy.root_rw.arn
}

resource "aws_iam_policy" "root_rw" {
  name        = "${local.id}-root-rw"
  description = "ReadWrite access for ${local.id}"
  policy      = data.aws_iam_policy_document.root_rw.json
}

data "aws_iam_policy_document" "root_rw" {
  # allow listing of all buckets
  statement {
    sid = "1"

    actions = [
      "s3:ListAllMyBuckets",
    ]

    resources = [
      "arn:aws:s3:::*",
    ]
  }

  # bucket level actions (get / list objects, but only at root)
  statement {
    sid = "2"

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListObjects",
    ]

    resources = [
      aws_s3_bucket.site.arn,
    ]
  }

  # Path level actions
  statement {
    sid = "3"

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:ListBucket",
      "s3:ListObjects",
    ]

    resources = [
      "${aws_s3_bucket.site.arn}/*",
    ]
  }
}

# AWS System user for Automation of deployments of example.com (to the root of the bucket)
# other robot users could be created that can only push to sub paths within the bucket
resource "aws_iam_user" "robot_root" {
  name          = "${local.id}-robot-root"
  path          = "/"
  force_destroy = true
}

resource "aws_iam_access_key" "robot_root" {
  user = aws_iam_user.robot_root.name
}

resource "aws_iam_user_group_membership" "robot_root" {
  user = aws_iam_user.robot_root.name

  groups = [
    aws_iam_group.root_rw.name,
  ]

  depends_on = [
    aws_iam_user.robot_root,
    aws_iam_group.root_rw,
  ]
}
