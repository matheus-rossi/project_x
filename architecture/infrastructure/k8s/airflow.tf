# Airflow Namespace
resource "kubectl_manifest" "airflow-namespace" {
  yaml_body = file("../../applications/airflow/templates/airflow-namespace.yaml")
}

# Airflow ArgoCD Application
resource "kubectl_manifest" "argocd-airflow-app" {
  depends_on = [
    kubectl_manifest.argocd
  ]
  yaml_body = templatefile(
    "../../applications/argocd-server/template/applications-airflow.yaml",
    {
      REPO_URL                    = var.architecture_repo_url,
      REPO_BRANCH                 = var.architecture_repo_branch,
      REPO_PATH                   = "applications/airflow/chart"
      DAG_SYNC_REPO               = var.pipeline_repo_url,
      DAG_SYNC_REPO_BRANCH        = local.pipeline_repo_branch,
      DAG_SYNC_REPO_SUB_PATH      = "airflow/dags/",
      AIRFLOW_SA_NAME             = local.airflow_sa_name,
      AIRFLOW_LOGGING_BUCKET_PATH = "gs://${local.airflow_logging_bucket}",
      PROJECT_ID                  = var.project_id,
    }
  )
}