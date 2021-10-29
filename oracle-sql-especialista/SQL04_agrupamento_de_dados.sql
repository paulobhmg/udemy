/* As funções de grupo são utilizadas para agrupar conjuntos de valores e consultas nesse formato seguem a seguinte sequência lógica

  - WHERE: Selecionar as linhas a serem recuperadas
  - GROUP BY: Formar os grupos
  - HAVING: Selecionar os grupos a serem recuperados
  - Exibir colunas ou expressões do SELECT ordenando pelo critério definido no ORDER BY

  Funções de grupo tem como principal funcionalidade fornecer dados estatísticos. 
*/

-- Seleciona os dados e a partir desse resultado cria o agrupamento 

SELECT 
  department_id, 
  TO_CHAR(AVG(salary), 'L99G999G999D99') media
FROM 
  employees
GROUP BY department_id; -- O agrupamento foi feito com base no SELECT já efetuado

SELECT 
  department_id,
  TO_CHAR(AVG(salary), 'L99G999G999D99') media
FROM 
  employees
GROUP BY department_id
ORDER BY department_id; -- Irá ordenar os dados já agrupados

SELECT 
  department_id,
  TO_CHAR(AVG(salary), 'L99G999G999D99') media,
  COUNT(employee_id) qtde_funcionarios
FROM 
  employees
GROUP BY department_id
ORDER BY department_id;

-- É IMPORTANTE observar que as funções de grupo IGNORAM valores nulos. Isso significa que caso exista a possibilidade
-- de um valor agrupado ter o valor NULO, este deverá ser tratado para não gerar um resultado incorreto na consulta.

-- Exemplos de resultado incorreto

SELECT 
  AVG(commission_pct) media_commissao 
FROM 
  employees;

SELECT 
  department_id, AVG(commission_pct) media_comissao
FROM 
  employees
GROUP BY department_id
ORDER BY media_comissao; -- a maioria dos funcionarios tem comissao nula. Portanto, esse resultado estará incorreto.

--Exemplos de resultado correto

SELECT 
  AVG(NVL(commission_pct, 0)) media_commissao 
FROM 
  employees;

SELECT 
  department_id, AVG(NVL(commission_pct, 0)) media_comissao
FROM 
  employees
GROUP BY department_id
ORDER BY media_comissao; -- Neste exemplo, as comissões nulas serão 0, então não serão ignoradas no agrupamento


-- COUNT poderá contar todas as linhas de uma consulta ou linhas distintas

SELECT 
  count(department_id) departamentos
FROM 
  employees;

SELECT count(distinct department_id) departamentos_em_uso
FROM employees;

-- Como regra, qualquer campo em um SELECT que não seja uma função de grupo deve estar incluído na cláusula GROUP BY

SELECT
  department_id,
  TO_CHAR(AVG(salary), 'L99G999G999D99') media,
  COUNT(employee_id) qtde_funcionarios
FROM 
  employees 
GROUP BY department_id
ORDER BY department_id, job_id; -- erro pois job_id não é função de grupo e deve ser agrupado

-- Para agrupar um campo, não é obrigatório que ele esteja incluso no SELECT.

SELECT
  department_id, job_title, -- job_id,
  TO_CHAR(AVG(salary), 'L99G999G999D99') media,
  COUNT(employee_id) qtde_funcionarios
FROM 
  employees
INNER JOIN jobs USING(job_id)
GROUP BY department_id, job_id, job_title
ORDER BY department_id, job_id; -- Correto. Todos os campos estão agrupados

-- Funções de grupo só funcionam em códigos que possuem a cláusula GROUP BY

SELECT 
  department_id, AVG(salary)
FROM 
  employees; -- Erro, não é possível utilizar a média sem agrupamento.


-- A cláusula WHERE faz a filtragem dos registros que comporão um grupo. Sendo assim, 
-- não é possível utilizá-la referenciando funções de grupo. Para isso utilizamos a cláusula HAVING.

SELECT 
  department_id, MAX(salary)
FROM 
  employees
WHERE 
  MAX(salary) > 10000 -- WHERE não pode ser utilizado com funções de grupo.
GROUP BY department_id;

SELECT 
  department_id, 
  MAX(salary) maior_salario, 
  COUNT(employee_id) funcionarios
FROM 
  employees
GROUP BY department_id
HAVING 
  MAX(salary) < 10000;

SELECT 
  department_id,
  COUNT(*) total_funcionarios,
  SUM(salary) total_salary
FROM 
  employees
WHERE 
  job_id <> 'SA_REP'
GROUP BY department_id
HAVING 
  MAX(salary) > 10000
ORDER BY department_id, total_salary;

SELECT 
  department_id, job_title,
  COUNT(*) total_funcionarios,
  SUM(salary) total_salary
FROM 
  employees
INNER JOIN jobs USING(job_id)
WHERE 
  job_id <> 'SA_REP'
GROUP BY department_id, job_id, job_title
HAVING 
  SUM(salary) > 30000
ORDER BY department_id, job_title, total_salary;

-- É possível aninhar funções de grupo. Porém elas só podem ser aninhadas uma única vez.

SELECT,
  TO_CHAR(
    MAX(AVG(salary)), 
    'L99G999G999D99'
) maior_media
FROM 
  employees
GROUP BY department_id;

-- No exemplo acima, primeiro haverá um agrupamento da média do salário e depois um novo agrupamento, retornando a maior média no grupo.

-- 1°
SELECT 
  AVG(salary) media
FROM 
  employees
GROUP BY department_id;

-- 2° 
SELECT 
  MAX(AVG(salary)) media
FROM 
  employees
GROUP BY department_id;
