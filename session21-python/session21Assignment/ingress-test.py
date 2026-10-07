# small helper I ran inside the backend pod to call the app THROUGH the ingress controller
# (taskboard.local isn't in my windows hosts file, so I set the Host header myself)
import json, sys, urllib.request as u

BASE = "http://ingress-nginx-controller.ingress-nginx.svc"


def call(method, path, body=None):
    data = json.dumps(body).encode() if body else None
    req = u.Request(BASE + path, data=data, method=method,
                    headers={"Host": "taskboard.local", "Content-Type": "application/json"})
    with u.urlopen(req) as r:
        return r.status, r.read().decode()[:300]


for title, status in [("Deploy TaskBoard with Helm", "DONE"), ("Fix ingress service name", "DONE"),
                      ("Load test the HPA", "IN_PROGRESS"), ("Write README", "TODO")]:
    print("POST /api/tasks", call("POST", "/api/tasks", {"title": title, "status": status, "assignee": "Aadit"}))
print("GET  /api/tasks/stats", call("GET", "/api/tasks/stats"))
print("GET  /", call("GET", "/")[0], call("GET", "/")[1][:120])
