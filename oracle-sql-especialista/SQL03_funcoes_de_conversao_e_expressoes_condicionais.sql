/* O SQL possui as conversões implícitas e explícitas
   - Conversões implícitas ocorrem quando um tipo de dado recebe o valor de ontro e consegue converte-lo.
   Nesse tipo de conversão, o SQL vai tentar converter e caso não consiga irá gerar um erro no sistema.
   Exemplo: String para data só converte se a string de data estiver no mesmo padrão definido pelo dev.
   
   - Conversões explícitas fornecem maior controle e legibilidade de código, pois está expresso qual é 
   o tipo de dado a ser convertido e como ele será convertido.
 

   TO_CHAR converte uma data para o formato caracter e é case sensitive.
   - As case sensitive delimitam o formato que será exibido determinado trecho da formatação
   
   YYYY ou RRRR - Ano com 4 dígitos
   MM - Mês com 2 dígitos
   DD - Dia do mês com 2 dígitos
   MONTH - Nome do mês com 9 caracteres (completo)
   MON - Nome do mês abreviado com 3 caracteres
   DAY - Dia da semana com 9 caracteres (completo)
   DY - Dia da semana abreviado com 3 caracteres
   D - Dia da semana de 1 a 7, sendo 1 domingo e 7 sábado
   YEAR - Ano soletrado (só funciona se o banco estiver em ingles)
   CC - Século
   AC ou DC - Antes ou dps de Cristo
   HH ou HH12 - Hora de 1 a 12
   HH24 - Hora de 0 a 23
   MI - Minuto
   SS Segundo
   
   ** Caracteres literais devem ser informados dentro de aspas duplas "Belo horizonte"
   ** Espaçõs, pontos e vírgula são permitidos na formatação
   ** Ao inserir "FM" junto de um dos formatos remove os espaços desnecessários e zeros à esquerda
*/

SELECT 
  first_name, last_name,
  TO_CHAR(sysdate, 'DD/MM/YYYY "às" HH24:MI:SS') hire_date
FROM 
  employees;

SELECT 
  first_name, last_name,
  TO_CHAR(sysdate, '"Belo Horizonte", FMDD "de" FMMonth "de" YYYY "-" HH24:MI:SS') data_atual
FROM 
  employees;


/* TO_CHAR também converte um número para formato caracteres

L - Símbolo de moeda definido pelo parâmetro NLS_CURRENCY
$ - Símbolo de moeda (não usado no Brasil)
G - Símbolo de milhar de acordo com o parâmetro do banco de dados
D - Símbolo de decimal de acordo com o parâmetro do banco de dados
. - Símbolo decimal
, - Símbolo milhar
9 - Número com supressão de zeros à esquerda
0 - Números incluíndo zeros à esquerda a partir da posição onde foi colocado o elemento 0.
*/

SELECT
  first_name, last_name,
  TO_CHAR(salary, 'L99G999G999D99') salary
FROM 
  employees;

-- Quando utiliza esse padrão e um número for maior do que o valor da máscara, a máscara retorna valor inesperado
SELECT 
  first_name, last_name,
  TO_CHAR(salary, 'L99D99') salary
FROM 
  employees; 

-- TO_NUMBER converte uma expressão em caracter para número, desde que esteja em um formato válido

SELECT 
  TO_NUMBER('1200,50') 
FROM 
  dual;

-- TO_DATE converte uma string de caracteres para data, passando no segundo argumento qual é o formato da data

SELECT 
  TO_DATE('03/11/2021', 'DD/MM/YYYY') today
from 
  dual;

SELECT 
  TO_CHAR(
    TO_DATE('03/11/21 08:00:00', 'DD/MM/YYYY HH24:MI:SS'), 
    'DD/MM/YYYY HH24:MI:SS'
) today
FROM 
  dual;

-- Também é possível utilizar as conversões como comparações
SELECT 
  first_name, last_name, hire_date
FROM 
  employees
WHERE 
  hire_date BETWEEN TO_DATE('01/03/2002', 'DD/MM/YYYY') AND TO_DATE('01/03/2004', 'DD/MM/YYYY')
ORDER BY hire_date;

SELECT 
  first_name, last_name, hire_date,
  ROUND(MONTHS_BETWEEN(sysdate, hire_date), 0) qtde_de_meses
FROM 
  employees
WHERE 
  ROUND(MONTHS_BETWEEN(sysdate, hire_date), 0) > 20;

-- NVL substitui um valor nulo por outro, passado em seu segundo parâmetro

SELECT 
  first_name, last_name, salary,
  ROUND(NVL(commission_pct, 0), 2) commission 
FROM 
  employees;

-- Calculos com valores nulos retornam null, portanto o NVL deve ser utilizado tambem para os cálculos
SELECT 
  first_name, last_name, salary,
  ROUND(NVL(commission_pct, 0), 2) comission,
  (salary * 12) * commission_pct commission_pct_full
FROM 
  employees;

SELECT 
  first_name, last_name, salary,
  ROUND(NVL(commission_pct, 0), 2) commission,
  TO_CHAR((salary * 12) * NVL(commission_pct, 0), 'L99G999G999D99') total
FROM 
  employees;

-- COALESCE receberá uma lista de argumentos e vai retornar o primeiro argumento encontrado diferente de nulo

SELECT	
  COALESCE(NULL, NULL, 'EXPRESSÃO 1') expressao1,
  COALESCE(NULL, 'EXPRESSÃO 2', NULL) expressao2,
  COALESCE('EXPRESSAO 3', NULL, NULL) expressao3
FROM 
  dual;

SELECT
  first_name, last_name,
  NVL(commission_pct, 0) commission,
  NVL(TO_CHAR(manager_id), 'vazio') manager,
  COALESCE(TO_CHAR(commission_pct), TO_CHAR(manager_id), 'Não possui cargo ou comissão') mensagem
FROM 
  employees;

-- ***** Testar a funcionalidade desses dois últimos códigos depois.
SELECT
  first_name, last_name,
  NVL(commission_pct, 0) commission,
  NVL(TO_CHAR(manager_id), 'vazio') manager,
  COALESCE(TO_CHAR(ROUND(NVL(commission_pct,0),2)), TO_CHAR(manager_id), 'Não possui cargo ou comissão') mensagem
FROM 
  employees;

-- NVL2 é uma variação de NVL e recebe 3 argumentos
-- Se o 1° argumento é nulo, utiliza o 3°. Se o 1° argumento for <> nulo, utiliza o 2°
-- Nesse exemplo, funcionários que recebem comissão, tem a comissão bonificada em 3%

SELECT
  first_name, last_name, salary,
  NVL(commission_pct, 0) commission,
  NVL2(commission_pct, commission_pct + 0.03, 0) * salary comission_pay
FROM 
  employees;

-- NULLIF recebe 2 argumentos. Se eles forem iguais, retorna null, senão retorna o primeiro.

SELECT 
  NULLIF(1000,1000)
FROM 
  dual;

SELECT 
  NULLIF(1000, 2000)
FROM 
  dual;

-----------------------------------------------------

/* Expressões condicionais testam o valor de uma expressão e de acordo com o valor retornado pode
retornar um valor predefinido ou default. */

-- CASE
SELECT
  first_name, last_name, salary,
  CASE salary 
    WHEN 3000 THEN salary + salary * 0.03
    WHEN 4000 THEN salary + salary * 0.04
    WHEN 5000 THEN salary + salary * 0.05
    WHEN 6000 THEN salary + salary * 0.06
    WHEN 7000 THEN salary + salary * 0.07
    WHEN 8000 THEN salary + salary * 0.08
    ELSE salary
  END commission_paid
FROM 
  employees
ORDER BY salary;

-- DECODE
SELECT
  first_name, last_name, salary,
DECODE(
  job_id, 
    'IT_PROG', salary + 1.10 * salary,
    'ST_CLEARK', salary + 1.15 * salary,
    'SA_REP', salary + 1.20 * salary
            , salary
) novo_salario
FROM employees;
