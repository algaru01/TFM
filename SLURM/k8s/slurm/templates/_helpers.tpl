{{- define "slurm.frontend.hostname" }}
    {{- .Release.Name }}-{{ .Values.frontend.hostname -}}
{{- end }}

{{- define "slurm.workers.baseHostname" }}
    {{- .Release.Name }}-{{ .Values.workers.baseHostname }}
{{- end }}

{{- define "slurm.workers.service.fqdn" }}
    {{- .Release.Name }}-workers-service.default.svc.cluster.local
{{- end }}

{{- define "slurm.db.hostname" }}
    {{- .Release.Name }}-{{ .Values.db.hostname -}}
{{- end }}