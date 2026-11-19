*** Settings ***
Library     Browser
Library     RequestsLibrary
Library     Process
Library     ../libraries/BancoDados.py    ${CURDIR}/../../bd.sqlite
Resource    ../variables/config.resource

*** Variables ***
${PROJECT_ROOT}    ${CURDIR}/../..

*** Keywords ***
Iniciar Servidor Da Aplicacao
    [Documentation]    Sobe o servidor Node.js em segundo plano e aguarda responder na porta 3000.
    Start Process    node    app.js
    ...    cwd=${PROJECT_ROOT}
    ...    alias=servidor_node
    ...    stdout=${OUTPUT DIR}/servidor_stdout.log
    ...    stderr=${OUTPUT DIR}/servidor_stderr.log
    Wait Until Keyword Succeeds    15s    500ms    Verificar Servidor Online

Verificar Servidor Online
    ${resp}=    GET    ${BASE_URL}    expected_status=200
    Should Be Equal As Integers    ${resp.status_code}    200

Encerrar Servidor Da Aplicacao
    [Documentation]    Encerra o processo do servidor Node.js ao final da bateria de testes.
    Run Keyword And Ignore Error    Terminate Process    servidor_node    kill=True

Preparar Ambiente Limpo E Abrir Navegador
    Limpar Banco De Dados
    Abrir Aplicacao No Navegador

Abrir Aplicacao No Navegador
    [Arguments]    ${largura}=${VIEWPORT_DESKTOP}[width]    ${altura}=${VIEWPORT_DESKTOP}[height]
    New Browser    browser=${BROWSER}    headless=${HEADLESS}    slowMo=${SLOW_MO}
    New Context    viewport={'width': ${largura}, 'height': ${altura}}
    New Page       ${BASE_URL}

Finalizar Teste Com Evidencia
    Run Keyword And Ignore Error    Take Screenshot    fullPage=True
    Close Browser

Validar Campo Obrigatorio HTML5
    [Arguments]    ${seletor}
    ${vazio}=    Evaluate JavaScript    ${seletor}    (el) => el.validity.valueMissing
    Should Be True    ${vazio}    O campo ${seletor} deveria acusar valueMissing no HTML5.

Garantir Que XSS Nao Foi Executado
    ${executou}=    Evaluate JavaScript    ${None}    () => window.__xss === true
    Should Not Be True    ${executou}    Falha de seguranca: script XSS foi executado na pagina!