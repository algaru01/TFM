{{- define "myapp.formatValue" -}}
{{- $myVal := "" -}}
{{- if kindIs "string" . -}}
  {{- $myVal = . | quote -}}
{{- else if kindIs "map" . -}}
  {{- $myVal = toJson . -}}
{{- else if kindIs "bool" . -}}
  {{- if eq . true -}}
    {{- $myVal = "True" -}}
  {{- else -}}
    {{- $myVal = "False" -}}
  {{- end -}}
{{- else }}
  {{- $myVal = . -}}
{{- end -}}
{{- $myVal }}
{{- end -}}
