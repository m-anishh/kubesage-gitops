{{- define "kubesage-agent.labels" -}}
app.kubernetes.io/name: kubesage-agent
app.kubernetes.io/part-of: kubesage
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
{{- end -}}

{{- define "kubesage-agent.selectorLabels" -}}
app.kubernetes.io/name: kubesage-agent
{{- end -}}
