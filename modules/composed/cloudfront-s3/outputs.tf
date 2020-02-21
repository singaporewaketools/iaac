output "robot_root_access_key_id" {
  value = aws_iam_access_key.robot_root.id
  sensitive = true
}

output "robot_root_secret_access_key" {
  value     = aws_iam_access_key.robot_root.secret
  sensitive = true
}
