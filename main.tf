terraform {
  required_providers {
    spacelift = {
      source  = "spacelift-io/spacelift"
      version = "~> 1.0"
    }
  }
}

provider "spacelift" {
  # SPACELIFT_API_TOKEN se inyecta automáticamente
  # en stacks con rol administrativo (Space Admin).
  # No se necesitan credenciales manuales.
}

# ─────────────────────────────────────────────────────────────
# Política de aprobación: requiere revisión del security team
# cuando cualquier stack modifica un recurso aws_iam_policy.
#
# El label "autoattach:*" adjunta esta política automáticamente
# a TODOS los stacks de la cuenta, incluyendo los futuros.
# ─────────────────────────────────────────────────────────────
resource "spacelift_policy" "iam_approval" {
  name = "Require Security Approval for aws_iam_policy Changes"
  body = file("${path.module}/iam_approval_policy.rego")
  type = "APPROVAL"

  labels = ["autoattach:*"]
}

# ─────────────────────────────────────────────────────────────
# Output: ID de la política creada
# ─────────────────────────────────────────────────────────────
output "policy_id" {
  description = "ID de la política de aprobación creada en Spacelift"
  value       = spacelift_policy.iam_approval.id
}
