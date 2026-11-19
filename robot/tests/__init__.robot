*** Settings ***
Documentation     Inicializacao global da suite: inicia o servidor Node.js antes dos testes e encerra ao final.
Resource          ../resources/common.resource
Suite Setup       Iniciar Servidor Da Aplicacao
Suite Teardown    Encerrar Servidor Da Aplicacao