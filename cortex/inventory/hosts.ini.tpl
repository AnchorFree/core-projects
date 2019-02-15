[all]
{{- range $i, $e := ( ds "infra" ).nodes }}
{{ $e.name }} ip={{ $e.ip }} ansible_host={{ $e.ansible_host }} ansible_user={{ $e.ansible_user }} {{ if $e.etcd_member }}etcd_member_name=etcd{{ $i }}{{ end }}
{{- end }}

[etcd]
{{- range ( ds "infra" ).nodes }}
{{- if .etcd_member }}
{{ .name }}
{{- end }}
{{- end }}

[kube-master]
{{- range ( ds "infra" ).nodes }}
{{- if .master_member }}
{{ .name }}
{{- end }}
{{- end }}

[kube-node]
{{- range ( ds "infra" ).nodes }}
{{ .name }}
{{- end }}

[k8s-cluster:children]
kube-master
kube-node
