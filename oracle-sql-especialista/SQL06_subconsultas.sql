/* Subconsultas nos permitem deixar uma consulta mais dinâmica através da utilização do seu resultado para uma
	 consulta principal.
	 
	 As consultas podem ser SINGLE-ROW, que retornam apenas uma linha, ou MULTIPLE-ROW, que retornam uma lista de valores.
	 
   Consultas SINGLE-ROW utilizam operadores de comparação do tipo single row, que são: =, >, >=, <, <=, <>
	 e eles podem ser utilizados tanto na cláusula WHERE quanto na HAVING.
	 
	 Consultas MULTIPLE-ROW utilizam os operadores de comparação do tipo multiple-row, que são: IN, ANY e ALL
*/

-- Utilizando subconsultas SINGLE-ROW com a clausula WHERE

SELECT first_name, last_name, salary
FROM employees
WHERE salary < (SELECT AVG(NVL(salary, 0)) media FROM employees);

-- Utilizando subconsultas SINGLE-ROW com a clausula HAVING

SELECT 
	department_id, department_name,
	MAX(NVL(salary, 0)) maior_salario
FROM employees
INNER JOIN departments USING(department_id)
GROUP BY department_id, department_name
HAVING 
	MAX(NVL(salary, 0)) < (SELECT AVG(NVL(salary, 0)) FROM employees);


-- Como uma subconsulta SINGLE-ROW retorna apenas uma única linha, a consulta abaixo irá lançar um erro
-- pois sua subconsulta é um agrupamento de dados que irá retornar mais de uma linha.

SELECT 
	employee_id,
	first_name,
	last_name,
	department_id,
	department_name,
	salary
FROM employees
INNER JOIN departments USING(department_id)
WHERE salary > (	SELECT AVG(NVL(salary, 0)) media
									FROM employees
									GROUP BY department_id
								);
									
-- Quando uma consulta não retorna nenhum valor, é como se retornasse nulo. No exemplo abaixo, a subconsulta não retorna 
-- nenhum valor, portanto está sendo feita uma comparação com um valor nulo. Logo, não retorna nenhuma linha.

SELECT first_name, last_name
FROM employees
WHERE last_name = ( SELECT last_name 
										FROM employees
										WHERE last_name = 'Nogueira'
									);
															
/* As subconsultas multiplo row podem retornar mais de uma linha e seus operadores de comparação são:
	- IN:  Subconsultas com esse operador retornam uma lista de valores e é feito a comparação para saber
			   se determinado valor está dentro do intervalo de valores retornados na subconsulta.	
	- ANY: Deve ser precedido por =, <>, >, <, <=, >= e compara se uma condição é verdadeira para qualquer
         um dos valores retornados na subconsulta.
				 Retorna FALSE caso a consulta retorna nenhuma lista.
	- ALL: Deve ser precedido por =, <>, >, <, <=, >= e compara se uma condição é verdadeira, baseado na comparação
         de todos os valores retornados por uma subconsulta.
         Retorna TRUE se a subconsulta retorna nenhuma lista.
*/

-- Subconsulta MULTIPLE-ROW utilizando o operador IN
-- No exemplo abaixo, para cada departamento será retornado um valor de média e a consulta principal irá comparar
-- se os valores de salário estão dentro daquele intervalo.

SELECT first_name, last_name, salary
FROM employees
WHERE salary IN ( SELECT AVG(NVL(salary, 0)) media
									FROM employees
									GROUP BY department_id)
ORDER BY salary;

SELECT first_name, last_name, salary
FROM employees
WHERE salary NOT IN ( SELECT AVG(NVL(salary, 0)) media
                      FROM employees
                      GROUP BY department_id)
ORDER BY salary;

-- Buscando funcionários de um departamento específico

SELECT first_name, last_name, department_name
FROM   employees
INNER JOIN departments USING(department_id)
WHERE  department_id IN ( SELECT department_id
                          FROM employees);

-- Subconsulta MULTIPLE-ROW utilizando o operador ANY
-- No exemplo abaixo, qualquer valor que seja menor do que os salários retornados na subconsulta

SELECT first_name, last_name, salary
FROM employees
WHERE salary > ANY ( SELECT salary 
                     FROM employees
                     WHERE job_id = 'IT_PROG');

-- Subconsulta MULTIPLE-ROW utilizando o operador ALL
-- No exemplo abaixo, a consulta deve trazer os dados de funcionários que tem o salário menor do que TODOS os itens
-- retornados pela subconsulta.

SELECT first_name, last_name, salary
FROM employees
WHERE salary < ALL ( SELECT salary
                     FROM   employees
                     WHERE  job_id = 'IT_PROG');
                     

-- O operador IN utiliza o OR como operador lógico de comparação. Portanto, valores nulos encontrados na lista não 
-- influenciam no resultado. Porém, ao utilizar o NOT IN, a comparação utiliza o operador AND e caso encontre um valor nulo poderá
-- retornar imediatamente uma lista vazia, pois a comparação não atenderá todas as condições.
-- Por esse motivo, é importante tratar os valores nulos no momento da consulta.

-- Exemplo com IN

SELECT first_name, last_name, manager_id
FROM   employees
WHERE  manager_id IN ( SELECT manager_id
                       FROM   employees); -- Se executar apenas a subconsulta percebe-se que tem um valor NULO
                       
-- Exemplo com NOT IN

SELECT first_name, last_name, manager_id
FROM   employees 
WHERE  manager_id NOT IN ( SELECT manager_id
                           FROM   employees); -- O primeiro campo da lista não possui MANAGER_ID, portanto já retorna nulo.

-- Para contornar esse tipo de situação existe uma alternativa utilizando os operadores EXISTS e NOT EXISTS

SELECT d.department_id, d.department_name
FROM   departments d
WHERE  EXISTS ( SELECT e.department_id
                FROM   employees e
                WHERE  d.department_id = e.department_id);

SELECT e.first_name, e.last_name, e.manager_id
FROM   employees e
WHERE  NOT EXISTS ( SELECT m.manager_id
                    FROM   employees m
                    WHERE  e.manager_id = m.employee_id);
                    
SELECT d.department_id, d.department_name
FROM   departments d
WHERE  NOT EXISTS ( SELECT e.department_id
                    FROM   employees e
                    WHERE  d.department_id = e.department_id);
                    
-- Subconsultas CORRELACIONADAS nos permitem fazer comparações entre as consultas interna e externa. Porém, vale se atentar que para 
-- cada linha da consulta externa é feito uma comparação com uma linha da consulta interna, afetando diretamente a performance da query.

SELECT e1.first_name, e1.last_name, e1.salary, dep1.department_name
FROM   employees e1, departments dep1
WHERE  e1.salary >= ( SELECT TRUNC(AVG(NVL(e2.salary, 0))) media
                      FROM employees e2
                      WHERE e1.department_id = e2.department_id);

-- Para subconsultas que retornam mais de uma coluna, MULTIPLE-COLUMNS, cada coluna que será retornada na consulta interna
-- deverá estar explícito na condição WHERE da consulta externa, separados por vírgula.
-- A comparação é feita coluna x coluna e é efetuada para cada linha das consultas interna e externa e só retornará TRUE caso as duas condições sejam satisfatórias.

SELECT e1.first_name, e1.last_name, e1.job_id, e1.salary
FROM   employees e1
WHERE  (e1.job_id, e1.salary) IN ( SELECT e2.job_id, MAX(NVL(e2.salary, 0)) 
                                   FROM   employees e2
                                   GROUP  BY e2.job_id); 


-- É possível utilizar subconsultas na clausula FROM. Essas são utilizadas quando não se tem uma consulta no layout que precisa
-- ou não tem uma VIEW com os campos necessários

SELECT 
  e.first_name, e.last_name, 
  TO_CHAR(e.salary, 'L99G9999G999D99') salary,
  TO_CHAR(maior_salario.maior, 'L99G999G999D99') maior_salario,
  TO_CHAR((maior_salario.maior - e.salary), 'L99G999G999D99') diferenca
FROM employees e
LEFT JOIN ( SELECT e2.job_id, MAX(e2.salary) maior
            FROM   employees e2
            GROUP  BY e2.job_id) maior_salario
  ON maior_salario.job_id = e.job_id;
