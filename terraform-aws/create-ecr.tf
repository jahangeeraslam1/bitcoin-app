resource "aws_ecr_repository" "bitcoin_price_app" {
  name                 = "bitcoin-price-app-repo"  
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

# Output the repository URL
output "repository_url" {
  value = aws_ecr_repository.bitcoin_price_app.repository_url
}

