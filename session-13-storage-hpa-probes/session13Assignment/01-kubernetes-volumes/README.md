Task 1 - Kubernetes Volumes

Notes on the different storage types. Ran the yamls from 01-volumes, 02-persistent-storage
and 03-storageclass on minikube to check each one.

emptyDir - blank folder made when the pod starts, deleted when the pod is deleted. Good for
temp/cache files or sharing files between 2 containers in the same pod.

hostPath - mounts a folder from the node itself. Data stays even if the pod dies, but it's
tied to that one node, so not great in a real multi-node cluster.

Tested both: wrote a file in each pod, deleted the pods, created them again.

```
$ kubectl exec emptydir-demo -- sh -c 'echo hello-emptydir > /data/a.txt; cat /data/a.txt'
hello-emptydir
$ kubectl exec hostpath-demo -- sh -c 'echo hello-hostpath > /data/b.txt; cat /data/b.txt'
hello-hostpath
$ minikube ssh -- cat /tmp/hostpath-data/b.txt
hello-hostpath

(deleted both pods and applied again)

--- emptydir after recreate:
$ kubectl exec emptydir-demo -- ls /data
                                            <- empty, file gone
--- hostpath after recreate:
$ kubectl exec hostpath-demo -- cat /data/b.txt
hello-hostpath                              <- still there
```

PersistentVolume (PV) - the actual piece of storage in the cluster, usually made by the admin.

PersistentVolumeClaim (PVC) - the pod asks for storage through a PVC ("give me 500Mi RWO")
and k8s binds it to a PV that fits. The pod only knows the PVC name, not where the disk is.

Got stuck here. The pvc.yaml from class didn't bind to student-pv, it made a new volume instead:

```
$ kubectl get pv student-pv; kubectl get pvc student-pvc
NAME         CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS      CLAIM   STORAGECLASS
student-pv   1Gi        RWO            Retain           Available
NAME          STATUS   VOLUME                                     CAPACITY   STORAGECLASS
student-pvc   Bound    pvc-f334f19f-9d23-46a2-8c89-587e8bd8e918   500Mi      standard
```

Since the PVC has no storageClassName, k8s gives it the default one (standard), and that
creates a new volume dynamically. Fixed it with `storageClassName: ""` (static-pvc.yaml):

```
$ kubectl get pv student-pv; kubectl get pvc student-pvc
NAME         CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM
student-pv   1Gi        RWO            Retain           Bound    default/student-pvc
NAME          STATUS   VOLUME       CAPACITY   ACCESS MODES
student-pvc   Bound    student-pv   1Gi        RWO
```

Asked for 500Mi but got 1Gi - a PVC takes the whole PV, it doesn't get split.
Then wrote a file, deleted the pod, made it again:

```
$ kubectl exec storage-demo -- sh -c 'echo saved-on-pv > /data/note.txt'
$ kubectl delete pod storage-demo
$ kubectl apply -f 02-persistent-storage/pod.yaml
$ kubectl exec storage-demo -- cat /data/note.txt
saved-on-pv
```

StorageClass - like a template for making PVs: which provisioner to use, and what
happens on delete (reclaim policy). minikube has one called standard.

```
$ kubectl get sc
NAME                 PROVISIONER                RECLAIMPOLICY   VOLUMEBINDINGMODE
standard (default)   k8s.io/minikube-hostpath   Delete          Immediate
```

Dynamic provisioning - you only make the PVC with a storageClassName and the PV gets
made for you. No admin needed.

```
$ kubectl apply -f 03-storageclass/pvc.yaml
$ kubectl get pvc dynamic-pvc
NAME          STATUS   VOLUME                                     CAPACITY   STORAGECLASS
dynamic-pvc   Bound    pvc-7c11b490-d07c-4b82-b186-2113791dfe44   500Mi      standard
$ kubectl get pv pvc-7c11b490-d07c-4b82-b186-2113791dfe44
NAME                                       CAPACITY   RECLAIM POLICY   STATUS   CLAIM
pvc-7c11b490-d07c-4b82-b186-2113791dfe44   500Mi      Delete           Bound    default/dynamic-pvc
```

This time it's exactly 500Mi, because the PV was made to fit the request. Reclaim is
Delete, so deleting the PVC deletes the PV and data too. My static one is Retain, so it stays.

What I learned: emptyDir lives as long as the pod, hostPath as long as the node, PV/PVC
outlive both. A PVC with no storageClassName still uses the default class, which is why
mine went dynamic. In cloud you basically always use dynamic provisioning.
