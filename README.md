# Kubernetes GitOps Platform Lab

An honest, reproducible personal lab by **Levi N** demonstrating Kubernetes operations, Helm packaging, Argo CD GitOps, policy validation, observability, and incident response.

> Scope: this repository is a local engineering lab. It does not claim production traffic, team ownership, uptime, or business impact.

## Architecture

```text
Git commit -> GitHub Actions -> Helm + security validation
     |
     v
Argo CD -> kind Kubernetes cluster -> demo web service
                                      |-> health probes
                                      |-> NetworkPolicy / PDB / HPA
                                      +-> Prometheus metrics and alerts
```

## What it demonstrates

- Declarative delivery with Argo CD
- Reusable Kubernetes packaging with Helm
- Least-privilege runtime settings and network controls
- CI checks for manifests, charts, and infrastructure security
- Service-level objectives, Prometheus alerts, and a runbook
- A controlled failure exercise with recovery evidence

## Quick start

Prerequisites: Docker, `kind`, `kubectl`, and Helm 3.

```bash
make cluster
make validate
make install
kubectl -n platform-lab port-forward service/platform-demo 8080:80
```

Open <http://localhost:8080>. Remove everything with `make clean`.

## GitOps bootstrap

```bash
make argocd
kubectl apply -f gitops/application.yaml
```

The Argo CD application tracks `main` and deploys the Helm chart into `platform-lab`. For a fork, update `repoURL` in `gitops/application.yaml`.

## Reliability target

The lab defines a learning SLO of **99.5% successful HTTP probes over 30 days**. This is a design target, not a claim of measured production availability. See [the SLO](docs/slo.md) and [endpoint runbook](docs/runbooks/endpoint-unavailable.md).

## Controlled incident

Follow [the failure exercise](docs/failure-exercise.md) to introduce a bad readiness path, observe the unavailable endpoint, investigate, and recover with Git revert or Argo CD rollback. Record your own timestamps and screenshots when you run it.

## Optional AWS evolution

An honest next phase is EKS infrastructure with Terraform, GitHub-to-AWS OIDC, private networking, managed logging, and a cost estimate. Those capabilities are roadmap items and are not represented as already deployed.

## Author

**Levi N** — DevOps & Cloud Engineer
