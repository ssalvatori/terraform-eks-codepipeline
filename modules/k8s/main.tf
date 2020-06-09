provider "kubernetes" {
  host                   = var.k8s_host
  cluster_ca_certificate = base64decode(var.k8s_ca_certificate)
  token                  = var.k8s_token
  load_config_file       = false
}


module "k8s_metrics_server" {
  source  = "cookielab/metrics-server/kubernetes"
  version = "0.9.0"
}

module "kubernetes_dashboard" {
  source  = "cookielab/dashboard/kubernetes"
  version = "0.9.0"

  kubernetes_namespace_create                     = true
  kubernetes_dashboard_csrf                       = var.k8s_dashboard_csrf
  kubernetes_deployment_metrics_scraper_image_tag = "v1.0.4"
  kubernetes_deployment_image_tag                 = "v2.0.1"
}

resource "kubernetes_service_account" "eks-admin" {
  metadata {
    name      = "eks-admin"
    namespace = "kube-system"
  }
}

resource "kubernetes_cluster_role_binding" "kubernetes_dashboard" {
  metadata {
    name = "eks-admin"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "eks-admin"
    namespace = "kube-system"
  }
}

# provider "helm" {
#   version = "v1.1.1"
#   kubernetes {
#     host                   = var.k8s_host
#     cluster_ca_certificate = base64decode(var.k8s_ca_certificate)
#     token                  = var.k8s_token
#     load_config_file       = false
#   }
# }
