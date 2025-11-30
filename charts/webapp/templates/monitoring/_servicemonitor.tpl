{{- define "service-monitor" }}
{{- $monitor := .monitor.serviceMonitor }}
{{- $port := .port }}
{{- $actuator := .actuator }}
{{- $root := .root }}
{{- $namespaceSelector := $monitor.namespaceSelector }}
{{- $annotations := $monitor.annotations }}
{{- $labels := $monitor.labels }}
{{- $interval := $monitor.interval }}
{{- $path := $monitor.path }}
{{- $scrapeTimeout := $monitor.scrapeTimeout }}
{{- $scheme := $monitor.scheme }}
{{- if $monitor.enabled }}
  {{- if $actuator.enabled }}
    {{- $port = $actuator.port.name }}
    {{- $path = $actuator.metrics.path }}
  {{- end }}
  {{- if $monitor.extraPort.enabled }}
    {{- $port = $monitor.extraPort.name }}
    {{- $path = $monitor.path }}
  {{- end }}
- port: {{ $port }}
  interval: {{ $interval }}
  scrapeTimeout: {{ $scrapeTimeout }}
  path: {{ $path }}
  scheme: {{ $scheme }}
  {{- $common := $root.Values.commonLabels | default dict }}
  {{- $extraRelabels := $monitor.relabelings | default (list) }}
  {{- $hasProject := and $common (hasKey $common "project") }}
  {{- $hasTeam := and $common (hasKey $common "team") }}
  {{- if or $hasProject $hasTeam (gt (len $extraRelabels) 0) }}
  metricRelabelings:
    {{- if $hasProject }}
    - action: replace
      targetLabel: project
      replacement: {{ index $common "project" | quote }}
    {{- end }}
    {{- if $hasTeam }}
    - action: replace
      targetLabel: team
      replacement: {{ index $common "team" | quote }}
    {{- end }}
    {{- with $extraRelabels }}
      {{- toYaml . | nindent 4 }}
    {{- end }}
  {{- end }}
{{- end }}
{{- end }}
