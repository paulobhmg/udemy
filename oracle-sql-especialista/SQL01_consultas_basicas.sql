/* 
Este arquivo contempla:
	- Códigos SELECT simples
	- Concatenação de colunas
	- Operadores aritméticos, relacionais, lógicos e alternativo
	- Restrição de dados com cláusula WHERE
	- Operadores LIKE, BETWEEN, IN e caracteres coringa
	- ALIASES de colunas com caracteres especiais
	- Consultas com caracter de substituição
	- Definição de variáveis 
	
O SELECT permite a projeção de uma ou mais colunas, selecionar quantas linhas serão projetadas,
   relacionar os dados de uma ou mais tabelas, identificando quais serão as colunas e tabelas
*/

-- O comando DESCRIBE permite visualizar a estrutura de uma tabelas

DESCRIBE employees;
DESC employees;

-- Uma boa prática é utilizar o SQL explicitando quais serão as colunas exibidas.
-- Utilizá-lo dessa maneira garante melhor performance, pois limita a consulta apenas ao que é necessário.

SELECT * FROM employees;
SELECT first_name, last_name FROM employees;

-- É possível efetuar SELECT'S criando uma ou mais colunas com valores calculados a partir dos operadores aritméticos
-- É importante observar a precedência das operações, que segue a mesma regra da matemática
-- Predecência: 1° identificador (positivo ou negativo), 2° multiplicação ou divisão, 3° soma ou adição
-- NULL é a ausência de valor e os cálculos entre colunas que possuem valores nulos, retornam NULL, caso não sejam tratados

SELECT first_name, last_name, salary, salary * 2 AS new_salary
FROM employees;

SELECT first_name, last_name, salary, (salary + 1000) * 2 AS new_salary
FROM employees;

SELECT first_name, last_name, salary, commission_pct, salary * commission_pct AS full_salary
FROM employees
WHERE commission_pct IS NOT NULL;

-- A palavra reservada 'AS' permite apelidar uma coluna, permitindo também nomear colunas com espaços e caracteres
-- especiais e case sensitive, bastando colocar as palavras entre aspas duplas.

SELECT first_name "Primeiro Nome", last_name "Segundo Nome", salary "Salário ($)"
FROM employees;

-- É possível concatenar uma ou mais colunas, a partir dos caracteres ||.

SELECT 
  first_name || ' ' || last_name || ' foi contratado em ' || 
  hire_date || ' no departamento ' || department_id || '.' 
  contratacao
FROM 
  employees;

-- O operador alternativo permite utilizar ASPAS dentro de uma String de caracteres 

SELECT 
  first_name ||  q'[work's at ]' || department_id || q'[ department's.]' working
FROM 
  employees;

-- A cláusula DISTINCT permite remover a duplicidade de registros retornados em uma consulta

SELECT DISTINCT department_id 
FROM employees;

SELECT DISTINCT first_name, last_name
FROM employees;


-- A cláusula WHERE permite restringir ou filtrar quais serão os registros recuperados por uma query
-- Essa cláusula utiliza operadores relacionais e lógicos para fazer a comparação de valores
-- Para valores alfanuméricos, é necessário utilizá-los dentro de aspas simples

-- Operador de igualdade

SELECT 
  employee_id, last_name, job_id, department_id 
FROM 
  employees
WHERE 
  department_id = 60;

SELECT 
  employee_id, last_name, job_id, department_id
FROM 
  employees
WHERE 
  job_id = 'IT_PROG';

SELECT 
  first_name, last_name, job_id, department_id 
FROM 
  employees
WHERE 
  last_name = 'King';

-- Operadores <, >, <=, >=, <>

SELECT 
  first_name, last_name, job_id, department_id, hire_date
FROM 
  employees
WHERE 
  hire_date >= '30/01/01';

SELECT 
  first_name, last_name, job_id, department_id, hire_date
FROM 
  employees
WHERE 
  hire_date <= '30/01/01';

-- Operador BETWEEN compara valores dentro de determinado intervalo

SELECT 
  first_name, last_name, job_id, department_id, hire_date
FROM 
  employees
WHERE 
  hire_date BETWEEN '13/01/01' AND '17/08/02'
ORDER BY hire_date;

SELECT 
  first_name, last_name, salary
FROM 
  employees
WHERE 
  salary BETWEEN 10000 AND 13000;

-- Operador IN compara valores dentro de uma lista de valores

SELECT 
  first_name, last_name, job_id 
FROM 
  employees 
WHERE 
  job_id IN ('IT_PROG', 'FI_ACCOUNT', 'SA_REP');

-- Operador LIKE compara valores através de padrões utilizando caracteres coringa

SELECT 
  first_name, last_name, job_id
FROM 
  employees
WHERE 
  first_name LIKE 'S%'; -- Inicia com 'S' seguido de qualquer outra palavra

SELECT 
  first_name, last_name, job_id
FROM 
  employees
WHERE 
  first_name LIKE '_a%'; -- Inicia com uma letra qualquer, seguida da letra 'a', seguida de qualquer outra coisa

SELECT 
  first_name, last_name, job_id
FROM 
  employees
WHERE 
  first_name LIKE '%el_'; -- Termina com 'el' seguido de qualquer letra

SELECT 
  first_name, last_name, job_id
FROM 
  employees
WHERE 
  first_name LIKE '%mu%'; -- Tem as letras 'mu' em qualquer lugar do texto

-- Operador AND retorna true caso o resultado de duas expressões seja verdadeiro e false caso um dos resultados seja falso

SELECT 
  first_name, last_name, salary, job_id
FROM 
  employees
WHERE 
  job_id = 'IT_PROG' AND salary >= 5000;

-- Operador OR retorna true se uma das expressões for verdadeira e false caso todas as expressões sejam falsas

SELECT 
  first_name, last_name, salary, job_id
FROM 
  employees
WHERE 
  job_id = 'IT_PROG' OR salary >= 5000;

-- Operador NOT retorna a negação de uma expressão

SELECT 
  first_name, last_name, salary, job_id
FROM 
  employees
WHERE 
  job_id NOT IN ('IT_PROG', 'FI_ACCOUNT', 'SA_REP');


/* As operações de consulta, assim como os operadores aritméticos, 
   possuem uma ordem de procedência em sua execução, da esquerda para a direita
	 1 - Operadores aritméticos
	 2 - Operadores de concatenação
	 3 - Condições de comparação
	 4 - IS [NOT] NULL, LIKE, [NOT] IN
	 5 - [NOT] BETWEEN
	 6 - NOT EQUAL TO
	 7 - NOT condição lógica
	 8 - AND condição lógica
	 9 - OR  condição lógica
 
    Portanto, vale se atentar em controlar a precedência dessas operações através do uso de parênteses.
*/

SELECT 
  first_name, last_name, job_id, salary
FROM 
  employees
WHERE 
  job_id = 'SA_REP' OR job_id = 'IT_PROG' AND salary > 5000; -- Exemplo de resultado inesperado

SELECT 
  first_name, last_name, job_id, salary
FROM 
  employees
WHERE 
  (job_id = 'SA_REP' OR job_id = 'IT_PROG') AND salary > 5000;

-- A Cláusula ORDER BY permite ordenar os dados de forma crescente ou decrescente, permitindo referenciar uma colunas
-- pelo ALIAS ou pelo número da coluna, sendo o padrão crescente.

SELECT 
  first_name, last_name, job_id, hire_date
FROM 
  employees
ORDER BY hire_date;

SELECT 
  first_name, last_name, job_id, hire_date, salary * 12 AS annual_salary
FROM 
  employees
ORDER BY annual_salary DESC; 

SELECT 
  first_name, last_name, job_id, hire_date, salary * 12 annual_salary
FROM 
  employees
ORDER BY 5 ASC, first_name DESC;

-- É possível criar variáveis de substituição, utilizando a tecla '&'. Dessa forma, será solicitado como argumento um 
-- valor que deverá ser passado via interface gráfica. Valores do tipo String ou datas devem 
-- passados dentro de ASPAS SIMPLES.

SELECT 
  first_name, last_name, job_id, hire_date, salary
FROM 
  employees
WHERE 
  employee_id = &employee_id;

SELECT 
  first_name, last_name, job_id, hire_date, salary
FROM 
  employees
WHERE 
  first_name = '&first_name';

SELECT 
  first_name, last_name, job_id, hire_date, salary
FROM 
  employees
WHERE 
  hire_date BETWEEN '&initial' AND '&final';

-- Também é possível definir e apagar variáveis utilizando os comandos DEFINE e UNDEFINE
-- Fazendo dessa forma, A variável de substituição utilizará o valor definido para a variável criada
-- Esse comando é comumente utilizado por DBA's.

DEFINE employee_id = 101;

SELECT 
  first_name, last_name, job_id, hire_date, salary
FROM 
  employees
WHERE 
  employee_id = &employee_id;

DEFINE employee_id; -- visualizar o valor da variável

UNDEFINE employee_id;
