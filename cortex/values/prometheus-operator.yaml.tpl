fullNameOverride: prometheus-operator

prometheus:
  prometheusSpec:
    remoteWrite:
    - url: http://cortex-nginx.cortex.svc.cluster.local:80/api/prom/push
      queue_config:
        max_samples_per_send: 10000

grafana:
  service:
    type: LoadBalancer
    annotations:
      external-dns.alpha.kubernetes.io/hostname: "{{ ( ds "global" ).cortex_external_dns }}"
      external-dns.alpha.kubernetes.io/ttl: "10"
      external-dns.alpha.kubernetes.io/alias: "false"

kubelet:
  serviceMonitor:
    https: true

kubeControllerManager:
  service:
    selector:
      tier: control-plane
      component: kube-controller-manager
      k8s-app:

kubeScheduler:
  service:
    selector:
      tier: control-plane
      component: kube-scheduler
      k8s-app:

kubeEtcd:
  endpoints:
  - 10.16.1.184
  - 10.16.31.19
  - 10.16.37.116
