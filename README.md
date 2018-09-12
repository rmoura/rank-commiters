# RankCommiters

Com esta gem é possível montar um rank de commiters, pela quantidade de commits dos autores, de determinado projeto que esteja no GitHub.

## Instalação

```bash
$ git clone git@github.com:rmoura/rank-commiters.git
$ gem install rank-commiters-0.1.0.gem
```

## Utilização

Para maiores detalhes de utilização:

```bash
Usage: rank-commiters [options]

Specific options:
    -r, --repository ["owner/repo"]  [Obrigatório] Projeto a ser analisado (Ex.: "Dinda-com-br/braspag-rest")
    -t, --access_token [token]       Token de Acesso do GitHub
    -o, --output_path [path]         Caminho do diretório onde o arquivo será salvo

Common options:
    -h, --help                       Show this message
```

O parâmetro repositório é obrigatório.

Exemplo de utilização:

```bash
$ rank-commiters -r Dinda-com-br/braspag-rest -t xyzyzxzxyyxz -o /tmp
```

Este comando irá gerar uma mensagem indicando que o arquivo de saída com os commiters ordenados por quantidade de commits foi gerado com sucesso da seguinte forma:

```bash
Arquivo de saída gerado com sucesso. O arquivo está localizado em Dinda-com-br_braspag-rest_YYYYmmddHHMMSS.txt.
```

A estrutura deste arquivo será semelhante a:

```txt
Rodrigo;rodrigo123@gmail.com;rodrigosimoes;https://github.com/RodrigoSimoesAraujo­Dinda;300;
Jose;jose@hotmail.com;josedascouves;https://github.com/joselinho;14;
```

##### Casos que nenhum arquivo será gerado:

Repositório inexistente:
```bash
Ops! Repositório Não Encontrado.
```

Repositório vázio, sem commits:
```bash
Ops! Repositório Vázio (Sem Commits).
```

Quando limite de acessos permitido pelo GitHub for excedido:
```bash
Ops! Limite de Acessos Excedido.
```

Quando token de acesso a API do GitHub não for válido:
```bash
Ops! Acesso Não Autorizado.
```

## License

Esta gem está disponível como código aberto sob os termos de Licença MIT.
