
resource "aws_route53_zone" "eks" {
  name = var.zoneName
}
resource "aws_iam_policy" "external_dns_policy" {
  name        = "${var.external_dns_policy_name}"
  description = "policy to enable changing and listing recordsets and viewing hostedzones"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "route53:ChangeResourceRecordSets"
      ],
      "Resource": [
        "arn:aws:route53:::hostedzone/${aws_route53_zone.eks.zone_id}"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "route53:ListHostedZones",
        "route53:ListResourceRecordSets"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "external_dns" {
  role       = aws_iam_role.external_dns.name
  policy_arn = aws_iam_policy.external_dns_policy.arn
}

resource "aws_iam_role" "external_dns" {
  name = "${var.external_dns_role_name}"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::${var.account_id}:oidc-provider/${var.oidc_url}"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "${var.oidc_url}:sub": "system:serviceaccount:kube-system:external-dns"
        }
      }
    }
  ]
}
POLICY

}

resource "helm_release" "external-dns" {
  name       = "external-dns"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "external-dns"
  version  = "6.11.2"
  namespace  = "kube-system"

  values = [    
    "${file("${path.module}/values.yaml")}"
  ]
  
  set {
    name = "image.registry"
    value = "public.ecr.aws"
  }
  
  set {
    name = "image.repository"
    value = "bitnami/external-dns"
  }
  
  set {
    name = "image.tag"
    value = "0.13.0-debian-11-r0"
  }
  
  set {
    name  = "policy"
    value = "upsert-only"
  }

  set {
    name  = "provider"
    value = "aws"
  }

  set {
    name  = "domainFilters[0]"
    value = var.zoneName
  }
  
  set {
    name  = "aws.region"
    value = var.region
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.external_dns.arn
  }
  set {
    name  = "aws.zoneType"
    value = "public"
  }
  set {
    name  = "podSecurityContext.fsGroup"
    value = "65534"
  }

}

