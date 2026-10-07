Session 20 - Monitoring, Observability & GitOps

Three parts, each folder has its own README:

- 01-monitoring/ - Prometheus + Grafana + node-exporter + a Flask app with /metrics, in docker compose.
  Metrics, logs, alerts (app down, error rate, cpu, memory), cpu/memory utilization, app health.
- 02-observability/ - notes on metrics / logs / traces, why observability, tools, k8s observability.
- 03-gitops/ - Argo CD on minikube deploying an app straight from this github repo, self-heal
  demo, and a change made only through git.

Screenshots are in this folder (screenshot-1-grafana, screenshot-2-alerts, screenshot-3-argocd).

What I learned overall: monitoring tells me something is wrong (metrics + alerts), observability
is being able to work out why (logs, traces), and GitOps makes git the only way to change
what's running, with Argo CD constantly fixing anything that drifts.
