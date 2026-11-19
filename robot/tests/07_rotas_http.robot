*** Settings ***
Documentation    Testes de integracao HTTP diretamente nas rotas Express via RequestsLibrary.
Resource         ../resources/common.resource
Suite Setup      Criar Sessao HTTP Com Banco Limpo

*** Test Cases ***
Todas As Rotas GET Principais Devem Retornar Status 200
    [Tags]    http    smoke    positivo
    @{rotas}=    Create List    /    /especialidade    /especialidade/novo    /medico    /medico/novo    /paciente    /paciente/novo    /consulta    /consulta/novo
    FOR    ${rota}    IN    @{rotas}
        ${resp}=    GET On Session    hospital    ${rota}    expected_status=200
        Should Be Equal As Integers    ${resp.status_code}    200
    END

Rota Inexistente Deve Retornar Status 404
    [Tags]    http    negativo
    ${resp}=    GET On Session    hospital    /rota-inexistente-teste    expected_status=404
    Should Be Equal As Integers    ${resp.status_code}    404

POST Em Especialidade Deve Criar Registro E Redirecionar Com 302
    [Tags]    http    positivo
    &{payload}=    Create Dictionary    descricao=Dermatologia HTTP
    ${resp}=       POST On Session    hospital    /especialidade    data=${payload}    allow_redirects=${False}    expected_status=302
    Should Be Equal As Strings    ${resp.headers}[Location]    /especialidade

POST Em Medico Sem Nome Contornando HTML5 Deve Retornar Erro 500
    [Documentation]    Como Medico.nome tem allowNull: false no Sequelize e nao ha tratamento de erro no POST /medico, enviar corpo vazio retorna HTTP 500.
    [Tags]             http    negativo    contrato
    &{payload_vazio}=    Create Dictionary
    ${resp}=             POST On Session    hospital    /medico    data=${payload_vazio}    expected_status=500
    Should Be Equal As Integers    ${resp.status_code}    500

*** Keywords ***
Criar Sessao HTTP Com Banco Limpo
    Limpar Banco De Dados
    Create Session    hospital    ${BASE_URL}