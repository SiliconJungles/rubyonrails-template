output "docker_repo_arn" {
  description = "ARN of the Docker Image repository"
  value       = aws_ecr_repository.repo.arn
}

output "docker_repo_registry_id" {
  description = "The registry ID where the repository was created"
  value       = aws_ecr_repository.repo.registry_id
}

output "docker_repo_repository_url" {
  description = "The URL of the docker repository"
  value       = aws_ecr_repository.repo.repository_url
}
