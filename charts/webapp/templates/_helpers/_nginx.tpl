{{- define "nginx-configmap" }}
{{- $configs := dict }}
  {{- range $k, $v := .Values.nginx.data }}
    {{- $_ := set $configs $k $v }}
  {{- end }}
{{- toYaml $configs }}
{{- end }}

{{- define "nginx-config-name" }}
{{- printf "%s-nginx-config" .Values.name }}
{{- end }}

{{- define "nginx-probe" -}}
{{- $probe := .Values.nginx.livenessProbe -}}
{{- if $probe.enabled -}}
livenessProbe:
  {{- if not $probe.exec }}
  httpGet:
    path: {{ $probe.path }}
    scheme: {{ $probe.scheme}}
    port: {{ .Values.port }}
  {{- else }}
  exec: {{- $probe.exec | toYaml | nindent 4 }}
  {{- end }}
  initialDelaySeconds: {{ $probe.initialDelaySeconds }}
  timeoutSeconds: {{ $probe.timeoutSeconds }}
  periodSeconds: {{ $probe.periodSeconds }}
  failureThreshold: {{ $probe.failureThreshold }}
  successThreshold: {{ $probe.successThreshold }}
{{- end -}}
{{- end -}}

{{- define "nginx-lifecycle" }}
{{- if .Values.nginx.shared.enabled }}
{{- $destiny := .Values.nginx.shared.path }}
{{- $configName := (include "nginx-config-name" .) }}
lifecycle:
  postStart:
    exec:
      command:
      - "sh"
      - "-c"
      - "mkdir -p {{$destiny}} && cp -r /shared/* {{$destiny}}"
{{- else }}
lifecycle: {}
{{- end }}
{{- end }}

{{- define "nginx-volumeMounts" }}
{{- $mounts := .Values.volumeMounts }}
{{- $configName := (include "nginx-config-name" .) }}
{{- $mounts = append $mounts (dict "name" $configName "mountPath" "/etc/nginx/conf.d") }}
{{- if .Values.nginx.shared.enabled }}
  {{- $mounts = append $mounts (dict "name" "files" "mountPath" "/shared") }}
{{- end }}
{{- toYaml $mounts }}
{{- end }}
