# language: pt
# encoding: utf-8

Funcionalidade: Cadastro de Notas Fiscais por Upload de XML

  Como um micro/pequeno empreendedor,
  para que eu possa registrar minhas notas fiscais de forma rápida e precisa,
  eu quero poder fazer o upload do arquivo XML da nota fiscal diretamente no sistema.

  Contexto:
    Dado que existe um usuário com nome "João Upload", email "upload@teste.com" e senha "senha123"
    E que eu estou logado como "upload@teste.com" com senha "senha123"

  Cenário: Upload de um arquivo XML válido com sucesso
    Dado que eu estou na página de novo upload
    Quando eu anexo um arquivo XML válido ao formulário
    E eu pressiono "Enviar Arquivo"
    Então eu devo estar na página inicial
    E eu devo ver a mensagem de sucesso "Arquivo enviado e processado com sucesso!"

  Cenário: Envio do formulário sem selecionar um arquivo
    Dado que eu estou na página de novo upload
    Quando eu pressiono "Enviar Arquivo"
    Então eu devo estar na página de novo upload
    E eu devo ver a mensagem de alerta "Por favor, selecione um arquivo para enviar."

  Cenário: Exibir mensagem padrão quando nenhum arquivo for selecionado
    Dado que eu estou na página de novo upload
    Então o campo de nome do arquivo deve mostrar "Nenhum arquivo selecionado"
