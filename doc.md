## Etapas do trabalho

- Definição do schema  
- Carregamento dos dados  
- Criação de mapeamentos (países, moedas, etc.)  
- Criação de inserts padronizados para todos os carregamentos  

## Execução

- Os dados foram carregados em ordem decrescente de ano (2023 a 2019)  
  - Isso porque os dados de 2019 e 2020 não possuem faixas etárias agrupadas. É necessário definir os grupos antes.

## Resultados

- Resultados das consultas estão na pasta `resultados`, em arquivos `.csv`  
- Planos de execução também estão disponíveis  
- Indexações manuais não trouxeram ganhos  
  - Provavelmente porque as principais chaves já são indexadas automaticamente pelo Oracle (ex: chaves estrangeiras)
