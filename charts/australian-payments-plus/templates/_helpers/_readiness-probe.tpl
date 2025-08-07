{{- define "readiness-probe" }}
{{- $readiness := .readiness }}
{{- $port := .port }}
{{- $path := $readiness.path }}
{{- $data := $readiness }}
{{- $headers := $readiness.httpHeaders }}

{{- if $readiness.enabled }}
readinessProbe:
  {{- if not $readiness.exec }}
  httpGet:
    port: {{ $port }}
    path: {{ $path }}
    scheme: {{ $data.scheme }}
    {{- if $headers }}
    httpHeaders:
      {{- range $headers }}
      - name: {{ .name }}
        value: {{ .value }}
      {{- end }}
    {{- end }}
  {{- else }}
  exec: {{- $data.exec | toYaml | nindent 4 }}
  {{- end }}
  initialDelaySeconds: {{ $data.initialDelaySeconds }}
  timeoutSeconds: {{ $data.timeoutSeconds }}
  periodSeconds: {{ $data.periodSeconds }}
  failureThreshold: {{ $data.failureThreshold }}
  successThreshold: {{ $data.successThreshold }}
{{- end }}
{{- end }}
