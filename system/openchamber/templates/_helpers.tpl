{{- define "openchamber.labels" -}}
app.kubernetes.io/name: openchamber
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}
{{- define "openchamber.selectorLabels" -}}
app.kubernetes.io/name: openchamber
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
