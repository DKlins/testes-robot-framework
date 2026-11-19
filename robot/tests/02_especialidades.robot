*** Settings ***
Documentation    Testes funcionais, negativos e seguranca XSS para Especialidades.
Resource         ../resources/common.resource
Resource         ../resources/pages/hospital.resource
Test Setup       Preparar Ambiente Limpo E Abrir Navegador
Test Teardown    Finalizar Teste Com Evidencia

*** Test Cases ***
Deve Cadastrar Multiplas Especialidades E Persistir No SQLite
    [Tags]    especialidade    positivo    regressao
    FOR    ${esp}    IN    @{ESPECIALIDADES_BASE}
        Cadastrar Especialidade Pela Interface    ${esp}
        Verificar Especialidade Na Lista          ${esp}
    END
    ${total}=    Contar Registros Na Tabela    especialidade
    Should Be Equal As Integers    ${total}    3

Nao Deve Enviar Formulario De Especialidade Com Descricao Vazia
    [Tags]    especialidade    negativo
    Acessar Pagina    /especialidade/novo
    Click             css=button[type="submit"]
    Get Url           ==    ${BASE_URL}/especialidade/novo
    Validar Campo Obrigatorio HTML5    id=descricao
    ${total}=    Contar Registros Na Tabela    especialidade
    Should Be Equal As Integers    ${total}    0

Handlebars Deve Escapar Tentativa De XSS Na Especialidade
    [Tags]    especialidade    seguranca    negativo
    Cadastrar Especialidade Pela Interface    ${PAYLOAD_XSS}
    Garantir Que XSS Nao Foi Executado
    Verificar Especialidade Na Lista          ${PAYLOAD_XSS}