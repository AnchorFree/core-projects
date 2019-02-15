CORTEX_NAMESPACE=cortex
MONITORING_NAMESPACE=monitoring


.PHONY: infra-prepare
infra-prepare:
	gomplate -d global=global.yaml -f infrastructure/main.tf.tpl -o infrastructure/main.tf
	gomplate -d global=global.yaml -f infrastructure/variables.tf.tpl -o infrastructure/variables.tf
	gomplate -d global=global.yaml -f infrastructure/dynamodb.tf.tpl -o infrastructure/dynamodb.tf
	gomplate -d global=global.yaml -f infrastructure/ec2.tf.tpl -o infrastructure/ec2.tf
	gomplate -d global=global.yaml -f infrastructure/ec2sg.tf.tpl -o infrastructure/ec2sg.tf
	gomplate -d global=global.yaml -f infrastructure/s3.tf.tpl -o infrastructure/s3.tf

.PHONY: infra
infra: infra-prepare
	cd infrastructure && terraform apply

.PHONY: kubespray-prepare
kubespray-prepare: infra
	gomplate -d global=global.yaml -d infra=infrastructure/infra.yaml -f inventory/hosts.ini.tpl -o inventory/hosts.ini
	gomplate -d global=global.yaml -d infra=infrastructure/infra.yaml -f inventory/group_vars/k8s-cluster/k8s-cluster.yml.tpl -o inventory/group_vars/k8s-cluster/k8s-cluster.yml --left-delim %% --right-delim %%

.PHONY: values-prepare
values-prepare: infra
	gomplate -d global=global.yaml -d infra=infrastructure/infra.yaml -f values/cortex.yaml.tpl -o values/cortex.yaml
	gomplate -d global=global.yaml -d infra=infrastructure/infra.yaml -f values/external-dns.yaml.tpl -o values/external-dns.yaml
	gomplate -d global=global.yaml -d infra=infrastructure/infra.yaml -f values/prometheus-operator.yaml.tpl -o values/prometheus-operator.yaml

.PHONY: memcached
memcached:
	helm upgrade --install memcached-chunk stable/memcached -f values/memcached.yaml --namespace=${CORTEX_NAMESPACE}
	helm upgrade --install memcached-read stable/memcached -f values/memcached.yaml --namespace=${CORTEX_NAMESPACE}
	helm upgrade --install memcached-write stable/memcached -f values/memcached.yaml --namespace=${CORTEX_NAMESPACE}
	kubectl apply -f manifests/memcached-servicemonitor.yaml -n ${CORTEX_NAMESPACE}

.PHONY: cortex
cortex:
	helm upgrade --install cortex afcharts/cortex -f values/cortex.yaml --namespace=${CORTEX_NAMESPACE}

.PHONY: consul
consul: storageclass
	helm upgrade --install consul stable/consul -f values/consul.yaml --namespace=${CORTEX_NAMESPACE}

.PHONY: postgresql
postgresql: storageclass
	helm upgrade --install postgresql stable/postgresql -f values/postgresql.yaml --namespace=${CORTEX_NAMESPACE}

.PHONY: memcached-purge
memcached-purge:
	helm delete --purge memcached-chunk
	helm delete --purge memcached-read
	helm delete --purge memcached-write
	kubectl delete -f manifests/memcached-servicemonitor.yaml -n ${CORTEX_NAMESPACE}

.PHONY: cortex-purge
cortex-purge:
	helm delete --purge cortex

.PHONY: consul-purge
consul-purge:
	helm delete --purge consul
	kubectl delete pvc -l "component=consul-consul,release=consul" -n ${CORTEX_NAMESPACE}

.PHONY: postgresql-purge
postgresql-purge:
	helm delete --purge postgresql
	kubectl delete pvc -l "app=postgresql,release=postgresql" -n ${CORTEX_NAMESPACE}

.PHONY: shared-purge
shared-purge: memcached-purge consul-purge postgresql-purge

.PHONY: shared
shared: memcached consul postgresql

.PHONY: cortex-delete
cortex-delete:
	kubectl delete pod -l "app.kubernetes.io/name=cortex,app.kubernetes.io/instance=cortex" --force --grace-period=0 -n ${CORTEX_NAMESPACE}

.PHONY: prometheus
prometheus:
	helm upgrade --install prometheus-operator stable/prometheus-operator -f values/prometheus-operator.yaml --namespace=${MONITORING_NAMESPACE}

.PHONY: helm
helm:
	kubectl apply -f manifests/kube-tiller.yaml
	helm init --service-account=kube-tiller --upgrade

.PHONY: storageclass
storageclass:
	kubectl apply -f manifests/storageclass.yaml
	kubectl patch storageclass gp2 -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'

.PHONY: external-dns
external-dns:
	helm upgrade --install external-dns stable/external-dns -f values/external-dns.yaml --namespace kube-system

.PHONY: jaeger
jaeger:
	helm upgrade --install jaegertracing incubator/jaeger -f values/jaeger.yaml --namespace ${CORTEX_NAMESPACE}