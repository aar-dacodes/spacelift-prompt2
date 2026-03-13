terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# ─────────────────────────────────────────────────────────────
# Este recurso es el que dispara la política de aprobación.
# Cuando este stack corra en Spacelift, la Approval Policy
# detectará el aws_iam_policy y bloqueará el run pidiendo
# aprobación del security team.
# ─────────────────────────────────────────────────────────────
resource "aws_iam_policy" "demo_policy" {
  name        = "demo-security-policy"
  description = "Política de demo para mostrar el flujo de aprobación de Spacelift"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:GetObject"]
        Resource = "*"
      }
    ]
  })

  tags = {
    Environment = "demo"
    ManagedBy   = "spacelift"
  }
}

output "policy_arn" {
  description = "ARN de la política IAM creada"
  value       = aws_iam_policy.demo_policy.arn
}
