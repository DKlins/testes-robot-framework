*** Variables ***
${BASE_URL}                 http://localhost:3000
${BROWSER}                  chromium
${HEADLESS}                 ${True}
${SLOW_MO}                  0ms

&{VIEWPORT_DESKTOP}         width=${1280}    height=${720}
&{VIEWPORT_MOBILE}          width=${390}     height=${844}

@{ESPECIALIDADES_BASE}      Cardiologia    Pediatria    Ortopedia
&{PACIENTE_PADRAO}          nome=Maria Silva    prontuario=Historico de alergia a dipirona
${PAYLOAD_XSS}              <script>window.__xss=true</script>