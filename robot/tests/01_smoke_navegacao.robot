*** Settings ***
Documentation    Testes de fumaça (Smoke), navegacao completa e responsividade mobile.
Resource         ../resources/common.resource
Resource         ../resources/pages/hospital.resource
Test Setup       Abrir Aplicacao No Navegador
Test Teardown    Finalizar Teste Com Evidencia

*** Test Cases ***
Home Deve Exibir Titulo E Os Quatro Modulos Do Sistema
    [Tags]    smoke    web    positivo
    Get Title    ==    Sistema Hospitalar
    Get Text     css=.tituloPrincipal    ==    Sistema Hospitalar
    Get Element Count    css=.card    ==    4

Navegacao Da Home Para Todas As Telas E Botao Voltar Deve Funcionar
    [Tags]    smoke    navegacao    positivo
    Click      css=a[href="/especialidade"]
    Get Url    ==    ${BASE_URL}/especialidade
    Click      css=a[href="/"]
    Get Url    ==    ${BASE_URL}/

    Click      css=a[href="/medico"]
    Get Url    ==    ${BASE_URL}/medico
    Click      css=a[href="/"]

    Click      css=a[href="/paciente"]
    Get Url    ==    ${BASE_URL}/paciente
    Click      css=a[href="/"]

    Click      css=a[href="/consulta"]
    Get Url    ==    ${BASE_URL}/consulta
    Click      css=a[href="/"]
    Get Title  ==    Sistema Hospitalar

Botao Cancelar Nos Formularios Deve Retornar Para A Listagem
    [Tags]    navegacao    positivo
    Acessar Pagina    /especialidade/novo
    Click             css=a[href="/especialidade"]
    Get Url           ==    ${BASE_URL}/especialidade

    Acessar Pagina    /medico/novo
    Click             css=a[href="/medico"]
    Get Url           ==    ${BASE_URL}/medico

    Acessar Pagina    /paciente/novo
    Click             css=a[href="/paciente"]
    Get Url           ==    ${BASE_URL}/paciente

    Acessar Pagina    /consulta/novo
    Click             css=a[href="/consulta"]
    Get Url           ==    ${BASE_URL}/consulta

Layout Mobile Deve Manter Botoes Visiveis E Clicaveis
    [Tags]    responsividade    web
    Set Viewport Size    ${VIEWPORT_MOBILE}[width]    ${VIEWPORT_MOBILE}[height]
    Wait For Elements State    css=a[href="/medico"]           visible
    Wait For Elements State    css=a[href="/especialidade"]    visible
    Wait For Elements State    css=a[href="/paciente"]         visible
    Wait For Elements State    css=a[href="/consulta"]         visible