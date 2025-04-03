resource "kubernetes_manifest" "app-ingress-managed-cert" {
  depends_on = [ data.google_client_config.default ]
  manifest = yamldecode(<<-EOF
    apiVersion: networking.gke.io/v1
    kind: ManagedCertificate
    metadata:
      name: kareco-${var.environment}-certificate
      namespace: "default"
    spec:
      domains:
        - test-service.${var.domain_name}  
    EOF
  )
}