{{- define "vs-hosts" }}
{{- $hosts := list }}
{{- $name := .Values.name }}
{{- $namespace := .Release.Namespace }}
{{- $env := .Values.global.env }}  # The environment: dev, mng, prd
{{- $domain := .Values.global.network.domain }}  # The domain
{{- $access := "" }}  # Initialize the $access variable
{{- if .Values.istio.virtualServices.public }}
  {{- $access = "pub" }}  # If public, use pub
{{- else }}
  {{- $access = "pvt" }}  # If not public, use pvt
{{- end }}
{{- $hosts = append $hosts (printf "%s.%s.%s.%s" $name $access $env $domain) }}  # Generate the full host
{{- if .Values.istio.virtualServices.custom.hosts }}
  {{- range $_, $host := .Values.istio.virtualServices.custom.hosts }}
    {{- $hosts = append $hosts $host }}  # Append custom hosts if defined
  {{- end }}
{{- end }}
{{- $hosts | toYaml | nindent 2 }}  # Return hosts in YAML format, indented
{{- end }}
