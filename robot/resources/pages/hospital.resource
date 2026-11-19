*** Settings ***
Library     Browser
Resource    ../../variables/config.resource

*** Keywords ***
Acessar Pagina
    [Arguments]    ${rota}
    Go To    ${BASE_URL}${rota}

Cadastrar Especialidade Pela Interface
    [Arguments]    ${descricao}
    Acessar Pagina    /especialidade/novo
    Fill Text         id=descricao    ${descricao}
    Click             css=button[type="submit"]
    Wait For Elements State    css=.listaEspecialidades    visible

Verificar Especialidade Na Lista
    [Arguments]    ${descricao}
    Get Url     ==          ${BASE_URL}/especialidade
    Get Text    css=.listaEspecialidades    contains    ${descricao}

Cadastrar Medico Pela Interface
    [Arguments]    ${nome}    @{especialidades}
    Acessar Pagina       /medico/novo
    Fill Text            id=nome    ${nome}
    Select Options By    id=especialidades    text    @{especialidades}
    Click                css=button[type="submit"]
    Wait For Elements State    css=.listaMedicos    visible

Verificar Medico E Especialidades Na Lista
    [Arguments]    ${nome}    @{especialidades}
    Get Url     ==          ${BASE_URL}/medico
    Get Text    css=.listaMedicos    contains    ${nome}
    FOR    ${esp}    IN    @{especialidades}
        Get Text    css=.listaMedicos    contains    ${esp}
    END

Cadastrar Paciente Com Prontuario Pela Interface
    [Arguments]    ${nome}    ${descricao_prontuario}
    Acessar Pagina    /paciente/novo
    Fill Text         id=nome         ${nome}
    Fill Text         id=descricao    ${descricao_prontuario}
    Click             css=button[type="submit"]
    Wait For Elements State    css=.listaPacientes    visible

Verificar Paciente E Prontuario Na Lista
    [Arguments]    ${nome}    ${descricao_prontuario}
    Get Url     ==          ${BASE_URL}/paciente
    Get Text    css=.listaPacientes    contains    ${nome}
    Get Text    css=.listaPacientes    contains    ${descricao_prontuario}

Cadastrar Consulta Pela Interface
    [Arguments]    ${nome_paciente}    ${nome_medico}    ${hora}
    Acessar Pagina       /consulta/novo
    Select Options By    id=paciente    text    ${nome_paciente}
    Select Options By    id=medico      text    ${nome_medico}
    Fill Text            id=hora        ${hora}
    Click                css=button[type="submit"]
    Wait For Elements State    css=.listaConsultas    visible

Verificar Consulta Na Lista
    [Arguments]    ${nome_paciente}    ${nome_medico}    ${hora}
    Get Url     ==          ${BASE_URL}/consulta
    Get Text    css=.listaConsultas    contains    Hora: ${hora}
    Get Text    css=.listaConsultas    contains    ${nome_paciente}
    Get Text    css=.listaConsultas    contains    ${nome_medico}