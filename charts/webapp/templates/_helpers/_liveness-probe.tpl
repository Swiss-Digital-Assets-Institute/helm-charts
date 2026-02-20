{{- define "liveness-probe" }}
{{- $liveness := .liveness }}
{{- $readiness := .readiness | default dict }}
{{- $port := .port }}
{{- $actuator := .actuator }}
{{- $path := $liveness.path }}
{{- $data := $liveness }}
{{- $headers := $liveness.httpHeaders }}
{{- $readinessPath := $readiness.path }}
{{- $readinessData := $readiness }}

{{- if $liveness.enabled }}
  {{- if $actuator.enabled }}
    {{- $port = $actuator.port.port }}
    {{- $path = $actuator.liveness.path }}
    {{- $data = $actuator.liveness }}
    {{- $headers = $actuator.liveness.httpHeaders }}
    {{- if $readiness.enabled }}
      {{- $readinessPath = $actuator.readiness.path }}
      {{- $readinessData = $actuator.readiness }}
    {{- end }}
  {{- end }}
livenessProbe:
  {{- if and (not $liveness.exec) $readiness.enabled (not $readiness.exec) (eq (toString $path) (toString $readinessPath)) (eq (toString $data.scheme) (toString $readinessData.scheme)) }}
  tcpSocket:
    port: {{ $port }}
  {{- else if not $liveness.exec }}
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
