*** Settings ***
Documentation    Testes de Pacientes e Prontuarios (relacionamento 1:1).
Resource         ../resources/common.resource
Resource         ../resources/pages/hospital.resource
Test Setup       Preparar Ambiente Limpo E Abrir Navegador
Test Teardown    Finalizar Teste Com Evidencia

*** Test Cases ***
Deve Cadastrar Paciente Com Seu Prontuario Associado
    [Tags]    paciente    prontuario    positivo    regressao
    Cadastrar Paciente Com Prontuario Pela Interface
    ...    ${PACIENTE_PADRAO}[nome]
    ...    ${PACIENTE_PADRAO}[prontuario]
    Verificar Paciente E Prontuario Na Lista
    ...    ${PACIENTE_PADRAO}[nome]
    ...    ${PACIENTE_PADRAO}[prontuario]
    ${total_pac}=     Contar Registros Na Tabela    paciente
    ${total_pront}=   Contar Registros Na Tabela    prontuario
    Should Be Equal As Integers    ${total_pac}      1
    Should Be Equal As Integers    ${total_pront}    1

Nao Deve Cadastrar Paciente Sem Descricao Do Prontuario
    [Tags]    paciente    prontuario    negativo
    Acessar Pagina    /paciente/novo
    Fill Text         id=nome    Joao Sem Prontuario
    Click             css=button[type="submit"]
    Get Url           ==    ${BASE_URL}/paciente/novo
    Validar Campo Obrigatorio HTML5    id=descricao

Handlebars Deve Escapar XSS No Nome E Prontuario Do Paciente
    [Tags]    paciente    seguranca    negativo
    Cadastrar Paciente Com Prontuario Pela Interface    Paciente Seguro    ${PAYLOAD_XSS}
    Garantir Que XSS Nao Foi Executado
    Verificar Paciente E Prontuario Na Lista            Paciente Seguro    ${PAYLOAD_XSS}