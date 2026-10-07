# Session 20 - Task 2: Observability

Observability = how well you can figure out what's going on inside a system just by looking at what it outputs.
The way I think of it: monitoring tells you the patient has a fever, observability lets you find out why.

## The three pillars

**1. Metrics** - numbers over time (CPU, memory, request count, latency, error rate).
Answers: "is something wrong?"
Analogy: car dashboard. Speed, fuel, engine temp. Quick glance, no details.

```
http_requests_total{path="/health",status="200"} 1523
http_requests_total{path="/login",status="500"} 12
```
Cheap to store, easy to graph and alert on. But it won't tell you which user got the 500 or why.

**2. Logs** - timestamped records of events, one line per thing that happened.
Answers: "what happened?"
Analogy: airplane black box recorder. You read it after something goes wrong.

```json
{"ts":"2026-10-07T10:42:13Z","level":"error","service":"api","path":"/login","user_id":481,"msg":"db connection timeout after 5s"}
```
Structured (JSON) logs are way easier to search/filter than plain text.

**3. Traces** - follow one request as it moves across services. A trace is made of spans, each span = one step with a start time and duration.
Answers: "where in the request path is it slow / failing?"
Analogy: GPS route history. Shows every stop and how long you spent at each.

```
trace_id=7f3a9c  GET /checkout                 total 412ms
frontend   |==================================================| 412ms
  api        |=========================================|        340ms
    auth       |===|                                             30ms
    db query          |============================|            250ms   <- slow part
```
Here it's obvious the db query is eating most of the time. Metrics would only say "checkout is slow".

## Monitoring vs observability

- Monitoring: you decide ahead of time what to watch (CPU > 80%, service down) and get alerts. Good for known problems.
- Observability: the data is rich enough that you can ask new questions you didn't plan for. Good for "unknown unknowns".
- Monitoring is kind of a subset of observability.

Why it's needed now:
- Microservices - one click can hit 10+ services. Without traces you're guessing which one broke.
- Kubernetes pods come and go. A pod crashes, gets replaced, its logs are gone unless you shipped them somewhere.
- Weird bugs that only happen for some users / some requests - can't predict them, so you can't pre-build a dashboard for them.
- MTTR (mean time to recovery) - faster you find the root cause, faster you fix it. That's the whole point.

## Common tools

| Tool | What it does | Pillar |
|------|--------------|--------|
| Prometheus | Scrapes /metrics endpoints, stores time series, PromQL, alert rules | Metrics |
| Grafana | Dashboards on top of Prometheus, Loki, Tempo etc. | All (visualization) |
| Loki | Log storage from Grafana Labs, indexes only labels so it's cheap | Logs |
| ELK / EFK | Elasticsearch (store + search), Logstash or Fluentd/Fluent Bit (collect), Kibana (UI) | Logs |
| Jaeger | Distributed tracing backend + UI | Traces |
| Tempo | Grafana's trace backend, pairs with Loki/Prometheus | Traces |
| Zipkin | Older tracing system, similar idea to Jaeger | Traces |
| OpenTelemetry | Vendor-neutral standard + SDKs + Collector for instrumenting and shipping all three | All |
| Datadog / New Relic / CloudWatch | Hosted (paid) options, everything in one place | All |

Common combos: Prometheus + Grafana + Loki + Tempo ("Grafana stack"), or EFK + Jaeger. OpenTelemetry sits in front of whatever backend you pick so you're not locked in.

## Observability in Kubernetes

**Metrics**
- metrics-server - lightweight, keeps only current CPU/memory. This is what `kubectl top` and HPA use (used it in session 13 for HPA).
- cAdvisor - built into the kubelet, exposes per-container CPU/mem/network (`container_*` metrics).
- node-exporter - runs as a DaemonSet, node-level stuff (disk, CPU, memory of the machine).
- kube-state-metrics - state of k8s objects: deployments, replicas, pod status, restarts (`kube_*` metrics).
- kube-prometheus-stack Helm chart - installs Prometheus, Grafana, Alertmanager, node-exporter, kube-state-metrics with ready-made dashboards in one go (Helm from session 15).

```
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install monitoring prometheus-community/kube-prometheus-stack -n monitoring --create-namespace
```

**Logs**
- `kubectl logs` works but only for pods that still exist (plus `--previous` for the last crashed container).
- For real setups a log collector runs as a DaemonSet on every node, reads container logs from the node, ships them out. Fluent Bit -> Elasticsearch, or Promtail -> Loki (Grafana Alloy is the newer replacement for Promtail).

**Events + describe**
- `kubectl get events` and `kubectl describe pod` show scheduling failures, image pull errors, OOMKilled, failed probes. Used these a lot in session 14 troubleshooting.

**Probes as health signals**
- Liveness fails -> container restarted. Readiness fails -> pod removed from Service endpoints. Startup probe -> gives slow apps time before liveness kicks in.
- Restart count going up is a signal on its own.

**Traces**
- Apps are instrumented with OpenTelemetry SDK, send spans to an OpenTelemetry Collector (Deployment or DaemonSet), Collector forwards to Jaeger or Tempo.

### Handy commands

```
kubectl top nodes
kubectl top pods -n default --sort-by=cpu
kubectl logs deploy/my-app --tail=50 -f
kubectl logs my-pod --previous
kubectl get events --sort-by=.metadata.creationTimestamp
kubectl describe pod my-pod
```

### Example PromQL

CPU usage per pod in cores (x100 for % of one core):
```
sum by (pod) (rate(container_cpu_usage_seconds_total{namespace="default", container!=""}[5m]))
```

Pods that restarted in the last hour:
```
increase(kube_pod_container_status_restarts_total[1h]) > 0
```

Memory per pod:
```
sum by (pod) (container_memory_working_set_bytes{namespace="default", container!=""})
```

## How this ties to Task 1

In Task 1 I built Prometheus + Grafana + node-exporter + a Flask app exposing /metrics with alert rules, so that covers the metrics pillar.
Logs I only looked at with `docker compose logs`, and traces weren't set up (would need OpenTelemetry + Jaeger or Tempo).

What I learned:
Metrics tell you something is off, logs tell you what happened, traces tell you where. You need all three, especially with k8s where pods disappear.
OpenTelemetry is the standard way to collect them, and kube-prometheus-stack is the quickest way to get metrics going on a cluster.
