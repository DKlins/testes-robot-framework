*** Settings ***
Documentation    Testes Data-Driven (Valor Limite) para o campo hora da consulta.
Resource         ../resources/common.resource
Resource         ../resources/pages/hospital.resource
Suite Setup      Preparar Base Para Testes De Horario
Suite Teardown   Close Browser
Test Template    Agendar E Validar Hora Da Consulta

*** Variables ***
${MEDICO_DDT}      Dr. Horario Teste
${PACIENTE_DDT}    Paciente Horario Teste

*** Test Cases ***                 HORA
Hora Limite Inferior Zero          0
Hora Comercial Manha               8
Hora Comercial Tarde               15
Hora Limite Superior 23            23
Hora Negativa Sem Validacao App    -1
Hora Acima De 23 Sem Validacao     24

*** Keywords ***
Preparar Base Para Testes De Horario
    Preparar Ambiente Limpo E Abrir Navegador
    Cadastrar Especialidade Pela Interface              Clinica Medica
    Cadastrar Medico Pela Interface                     ${MEDICO_DDT}    Clinica Medica
    Cadastrar Paciente Com Prontuario Pela Interface    ${PACIENTE_DDT}    Acompanhamento de rotina

Agendar E Validar Hora Da Consulta
    [Arguments]    ${hora}
    [Tags]         ddt    limite    consulta
    Cadastrar Consulta Pela Interface    ${PACIENTE_DDT}    ${MEDICO_DDT}    ${hora}
    Verificar Consulta Na Lista          ${PACIENTE_DDT}    ${MEDICO_DDT}    ${hora}