*** Settings ***
Documentation    Testes do cadastro de Medicos e relacionamento N:M com Especialidades.
Resource         ../resources/common.resource
Resource         ../resources/pages/hospital.resource
Test Setup       Preparar Ambiente Limpo E Abrir Navegador
Test Teardown    Finalizar Teste Com Evidencia

*** Test Cases ***
Deve Cadastrar Medico Com Uma Unica Especialidade
    [Tags]    medico    positivo    regressao
    Cadastrar Especialidade Pela Interface         Cardiologia
    Cadastrar Medico Pela Interface                Dr. Carlos Andrade    Cardiologia
    Verificar Medico E Especialidades Na Lista     Dr. Carlos Andrade    Cardiologia
    ${total_vinculos}=    Contar Registros Na Tabela    MedicoEspecialidade
    Should Be Equal As Integers    ${total_vinculos}    1

Deve Cadastrar Medico Com Multiplas Especialidades
    [Tags]    medico    positivo    relacionamento
    FOR    ${esp}    IN    @{ESPECIALIDADES_BASE}
        Cadastrar Especialidade Pela Interface    ${esp}
    END
    Cadastrar Medico Pela Interface                Dra. Ana Paula    Cardiologia    Pediatria    Ortopedia
    Verificar Medico E Especialidades Na Lista     Dra. Ana Paula    Cardiologia    Pediatria    Ortopedia
    ${total_vinculos}=    Contar Registros Na Tabela    MedicoEspecialidade
    Should Be Equal As Integers    ${total_vinculos}    3

Nao Deve Cadastrar Medico Sem Selecionar Especialidade
    [Tags]    medico    negativo
    Cadastrar Especialidade Pela Interface    Neurologia
    Acessar Pagina    /medico/novo
    Fill Text         id=nome    Dr. Sem Especialidade
    Click             css=button[type="submit"]
    Get Url           ==    ${BASE_URL}/medico/novo
    Validar Campo Obrigatorio HTML5    id=especialidades
    ${total_medicos}=    Contar Registros Na Tabela    medico
    Should Be Equal As Integers    ${total_medicos}    0