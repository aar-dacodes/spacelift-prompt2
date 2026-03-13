package spacelift

import future.keywords.in
import future.keywords.if
import future.keywords.contains

# Identificar cambios reales en recursos aws_iam_policy
iam_policy_changes contains resource if {
    some resource in input.terraform.resource_changes
    resource.type == "aws_iam_policy"
    some action in resource.change.actions
    not action == "no-op"
    not action == "read"
}

# Sin cambios en aws_iam_policy → aprobar automáticamente
approve if {
    count(iam_policy_changes) == 0
}

# Con cambios en aws_iam_policy → bloquear y pedir aprobación del security team
reject if {
    count(iam_policy_changes) > 0
}
