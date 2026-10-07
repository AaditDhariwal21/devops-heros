Session 15 - Helm

Three parts, each folder has its own README and output.txt:

- 01-helm-commands/ - create, install, list, status, get, upgrade, history, rollback, uninstall, repo, search (chart: mychart)
- 02-rollback/ - install -> upgrade -> bad upgrade -> rollback (chart: app-chart)
- 03-mini-project/ - notes-chart with dev and prod values, install/upgrade/rollback/uninstall

Ran on minikube with helm v4.3.0 (installed with winget).

What I learned overall: Helm = templates + values -> k8s yaml, and it keeps a numbered history
of every release so upgrades and rollbacks are one command. But "deployed" from helm doesn't
mean the pods are actually healthy - you still check with kubectl.
