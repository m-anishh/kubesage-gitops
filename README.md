# kubesage-gitops

Desired state of the KubeSage cluster. ArgoCD reads this public repo (no credentials needed); it holds no secrets.

- **CI writes here:** `ci-apps.yml` and `ci-agent.yml` in `m-anishh/kubesage` bump `image.tag` in `envs/dev/`.
- **Humans write here:** fault switches in `envs/dev/values-*.yaml` start an incident.
- **Rollbacks write here:** `/approve-rollback` on an incident issue reverts the suspect commit.
- **ArgoCD reads here:** `argocd/root.yaml` (app-of-apps) syncs everything in `argocd/apps/`, with `prune` and `selfHeal`.

| Path | What it is |
|---|---|
| `argocd/root.yaml` | Root Application, applied once per session by `scripts/bootstrap-argocd.sh` |
| `argocd/apps/` | One Application each: external-secrets, external-secrets-config, monitoring, dashboards, orders-api, payments-api, kubesage-agent |
| `charts/demo-app/` | Helm chart for orders-api and payments-api (fault switches, probes, limits, ServiceMonitor, load generator) |
| `charts/kubesage-agent/` | Helm chart for the agent (read-only RBAC, Pod Identity service account) and its Qdrant |
| `manifests/external-secrets/` | ClusterSecretStore for AWS Secrets Manager and the `github-token` ExternalSecret |
| `manifests/dashboards/` | Grafana dashboard as a ConfigMap |
| `envs/dev/` | Values per app: image tags and fault switches |

## Start an incident

```yaml
# envs/dev/values-payments-api.yaml
faults:
  memoryLeak: true   # -> OOMKilled -> KubeSageOOMKilled -> GitHub issue
```

Commit and push. ArgoCD applies it within about 3 minutes.
