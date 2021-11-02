/* Os OPERADORES DE CONJUNTOS são utilizados para fazer a união de consultas, que podem ser de uma mesma tabela ou 
   podem ser várias consultas para tabelas distintas, aplicando-se a seguinte regra:
   
   - A ordem de execução dos SELECT's é feita de cima para baixo, podendo ter sua precedência alterada com a utilização de parênteses.
   - Independente do número de consultas unificadas, todas devem ter a mesma quantidade de colunas.
   - As colunas devem ter, obrigatoriamente, o mesmo tipo. Porém não é necessário que tenham o mesmo nome ou sejam da mesma tabela.
   - A clausula ORDER BY pode ser utilizada apenas no final, ordenando todas as consultas. Não pode ser utilizada para ordenar cada consulta.
   
   */
   
 -- UNION e UNION ALL unificam todos os registros das consultas realizadas.
 -- A diferença é que o primeiro remove os registros duplicados, enquanto o segundo mantém.
   
-- Unifica as consultas, removendo resultados duplicados
SELECT first_name, last_name, department_id, salary
FROM   employees
WHERE  department_id IN (100, 160, 130)
UNION  
SELECT first_name, last_name, department_id, salary
FROM   employees
WHERE  salary > 10000
ORDER  BY salary;

-- Unifica as consultas, mantendo resultados duplicados (Mais rápido)
SELECT first_name, last_name, department_id, salary
FROM   employees
WHERE  department_id IN (100, 160, 130)
UNION  ALL
SELECT first_name, last_name, department_id, salary
FROM   employees
WHERE  salary > 10000
ORDER  BY salary;

-- INTERSECT faz a união dos dados, porém trás apenas os dados que são comuns à todas as consultas

SELECT first_name, last_name, department_id, salary
FROM   employees
WHERE  department_id IN (100, 160, 130)
INTERSECT 
SELECT first_name, last_name, department_id, salary
FROM   employees
WHERE  salary > 10000
ORDER  BY salary;

-- MINUS faz a união dos dados, retornando em sua consulta APENAS os dados da PRIMEIRA consulta que NÃO estão presentes na SEGUNDA consulta.

SELECT first_name, last_name, department_id, salary
FROM   employees
WHERE  department_id IN (100, 160, 130)
MINUS
SELECT first_name, last_name, department_id, salary
FROM   employees
WHERE  salary > 10000
ORDER  BY salary;

-- Controlando a ordem de execução (Não funcionou... dps me aprofundar)
SELECT first_name, last_name, department_id, salary
  FROM   employees
  WHERE  department_id IN (100, 160, 130)
UNION ( 
SELECT first_name, last_name, department_id, salary
  FROM   employees
  WHERE  salary > 10000
INTERSECT 
MINUS
  SELECT first_name, last_name, department_id, salary
  FROM   employees
WHERE  salary > 10000 )
ORDER  BY salary;
