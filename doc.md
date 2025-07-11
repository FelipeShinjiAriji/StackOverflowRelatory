## Etapas do trabalho

- Definição do schema  
- Carregamento dos dados  
- Criação de mapeamentos (países, moedas, etc.)  
- Criação de inserts padronizados para todos os carregamentos  

## Justificativa da Escolha dos Atributos

A seleção dos atributos foi feita com base nos objetivos da análise: entender o perfil dos profissionais de tecnologia, suas condições de trabalho e padrões salariais

- **`salario_anual`** e **`moeda_id`**: o salário na verdade é o TC, que é o ganho total no ano já incluindo outros bônus. A moeda só serve para depois realizar a conversão para dólar
- **`pais_id`**, **`formacao_id`**, **`trabalho_remoto_id`**, **`faixa_etaria_id`**: características demográficas dos respondentes. País acabou não utilizando pois tem outras consultas mais interessantes
- **`anos_programando`**: foi pensado para capturar a experiência do profissional. Acabou não sendo utilizado pois existem outras consultas mais interessantes
- **`resposta`** e **`ano`**: chave composta para relacionar quem respondeu com qual ano
- **Tabelas associativas (`Resposta_Cargo`, `Resposta_Linguagem`)**: feitas para realizar os relacionamentos N-N

## Execução

- Os dados foram carregados em ordem decrescente de ano (2023 a 2019)  
  - Isso porque os dados de 2019 e 2020 não possuem faixas etárias agrupadas. É necessário definir os grupos antes.

## Resultados

- Resultados das consultas estão na pasta `resultados`, em arquivos `.csv`  
- Planos de execução também estão disponíveis  
- Indexações manuais não trouxeram ganhos  
  - Provavelmente porque as principais chaves já são indexadas automaticamente pelo Oracle (ex: chaves estrangeiras)
