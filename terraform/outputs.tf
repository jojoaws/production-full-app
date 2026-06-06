output "backend_ecr_url" {
  value = aws_ecr_repository.backend.repository_url
}

output "uploads_bucket_name" {
  value = aws_s3_bucket.uploads.bucket
}

output "alb_dns_name" {
  value = aws_lb.app.dns_name
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.main.name
}

output "ecs_service_name" {
  value = aws_ecs_service.backend.name
}
