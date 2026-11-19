*** Settings ***
Documentation    Fluxo E2E completo em estilo BDD integrando todas as entidades do hospital.
Resource         ../resources/common.resource
Resource         ../resources/pages/hospital.resource
Test Setup       Preparar Ambiente Limpo E Abrir Navegador
Test Teardown    Finalizar Teste Com Evidencia

*** Test Cases ***
Fluxo Completo De Agendamento De Consulta Ponta A Ponta
    [Documentation]    Valida integracao completa: Especialidade -> Medico -> Paciente/Prontuario -> Consulta.
    [Tags]             e2e    bdd    consulta    smoke
    ${nome_medico}=      Gerar Nome Unico    Dr. Roberto
    ${nome_paciente}=    Gerar Nome Unico    Paciente Lucas

    Dado que existem especialidade, medico e paciente cadastrados    Cardiologia    ${nome_medico}    ${nome_paciente}    Checkup anual
    Quando agendo uma consulta para o horario                        ${nome_paciente}    ${nome_medico}    14
    Entao a consulta deve aparecer corretamente na listagem e no banco    ${nome_paciente}    ${nome_medico}    14

Nao Deve Agendar Consulta Com Campo Hora Vazio
    [Tags]    consulta    negativo
    Cadastrar Especialidade Pela Interface              Clinica Geral
    Cadastrar Medico Pela Interface                     Dr. Pedro    Clinica Geral
    Cadastrar Paciente Com Prontuario Pela Interface    Ana Clara    Primeira consulta
    Acessar Pagina    /consulta/novo
    Click             css=button[type="submit"]
    Get Url           ==    ${BASE_URL}/consulta/novo
    Validar Campo Obrigatorio HTML5    id=hora

*** Keywords ***
Dado que existem especialidade, medico e paciente cadastrados
    [Arguments]    ${especialidade}    ${medico}    ${paciente}    ${prontuario}
    Cadastrar Especialidade Pela Interface              ${especialidade}
    Cadastrar Medico Pela Interface                     ${medico}    ${especialidade}
    Cadastrar Paciente Com Prontuario Pela Interface    ${paciente}    ${prontuario}

Quando agendo uma consulta para o horario
    [Arguments]    ${paciente}    ${medico}    ${hora}
    Cadastrar Consulta Pela Interface    ${paciente}    ${medico}    ${hora}

Entao a consulta deve aparecer corretamente na listagem e no banco
    [Arguments]    ${paciente}    ${medico}    ${hora}
    Verificar Consulta Na Lista    ${paciente}    ${medico}    ${hora}
    ${total}=    Contar Registros Na Tabela    consulta
    Should Be Equal As Integers    ${total}    1