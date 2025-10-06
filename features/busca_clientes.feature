# language: pt
Funcionalidade: Busca e filtro de clientes
  Como dono do estabelecimento
  Eu quero poder filtrar minha busca pelos clientes
  Para que eu possa entender em qual clientela eu devo focar

  Cenário: Buscar clientes quando não há resultados
    Dado que existem clientes cadastrados no sistema
    Quando eu acesso a página de busca de clientes
    E eu busco por "Farmácia"
    Então não devo ver resultados de busca
    E devo ver a mensagem "Nenhum resultado encontrado"

  Cenário: Acessar página de busca sem realizar busca
    Dado que existem clientes cadastrados no sistema
    Quando eu acesso a página de busca de clientes
    Então devo ver o campo de busca vazio

  Cenário: Filtrar por tipo de estabelecimento para focar na clientela
    Dado que existem clientes cadastrados no sistema
    Quando eu acesso a página de busca de clientes
    E eu busco por "Restaurante"
    Então devo ver todos os clientes do tipo "Restaurante"
    E os resultados devem conter o texto "Restaurante" na descrição

  Cenário: Buscar quando não existem clientes cadastrados
    Dado que não existem clientes cadastrados no sistema
    Quando eu acesso a página de busca de clientes
    E eu busco por "Cliente"
    Então não devo ver resultados de busca
    E devo ver a mensagem "Nenhum resultado encontrado"

  Cenário: Termo de busca é mantido após a pesquisa
    Dado que existem clientes cadastrados no sistema
    Quando eu acesso a página de busca de clientes
    E eu busco por "Supermercado"
    Então devo ver o termo "Supermercado" no campo de busca
    E devo ver o cliente "Supermercado Grande Rede"
