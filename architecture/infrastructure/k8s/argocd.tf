#Provider
terraform {
  required_providers {
    kubectl = {
      source = "gavinbunney/kubectl"
      version = "1.14.0"
    }
  }
}

provider "kubectl" {
  load_config_file = true
}

# ArgoCD namespace
data "kubectl_file_documents" "argocd-namespace" {
    content = file("../../applications/argocd/templates/argocd-namespace.yaml")
}

data "kubectl_file_documents" "argocd" {
    content = file("../../applications/argocd/templates/install.yaml")
}

resource "kubectl_manifest" "argocd-namespace" {
    count     = length(data.kubectl_file_documents.argocd-namespace.documents)
    yaml_body = element(data.kubectl_file_documents.argocd-namespace.documents, count.index)
    override_namespace = "argocd"
}

resource "kubectl_manifest" "argocd" {
    depends_on = [
      kubectl_manifest.argocd-namespace,
    ]
    count     = length(data.kubectl_file_documents.argocd.documents)
    yaml_body = element(data.kubectl_file_documents.argocd.documents, count.index)
    override_namespace = "argocd"
}