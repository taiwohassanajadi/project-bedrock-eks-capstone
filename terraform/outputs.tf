output "aws_region" {
  value = var.aws_region
}

output "cluster_name" {
  value = aws_eks_cluster.main.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.main.endpoint
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "vpc_name" {
  value = var.vpc_name
}
output "assets_bucket_name" {
  value = aws_s3_bucket.assets.bucket
}
