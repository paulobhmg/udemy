/* Quando há a necessidade de extrair dados de uma ou mais tabelas relacionadas entre si, é necessário utilizar
   JOINS, que permite buscar, identificando qual é o campo em uma tabela que está linkado à outra.
   
   Todos os JOIN entre tabelas que retornam apenas dados onde as condições de ligação são atendidas, ou seja, tem coincidências,
   são conhecidos como INNER JOIN. A palavra INNER é opcional.
   
   Este arquivo contempla
   - Conceitos e códigos relacionados a JOIN, INNER JOIN, SELF JOIN, OUTER JOIN e CROSS JOIN
   - Diferenças entre as sintaxes ANSII e ORACLE para JOINS  
   - Produto cartesiano
*/

-- JOINS com a cláusula ON permite passar uma ou mais condições para definir qual será a ligação entre duas tabelas
-- Geralmente é utilizado o id da tabela.

SELECT 
    emp.employee_id,
	emp.first_name,
	emp.last_name,
	emp.department_id,
	dep.department_name
FROM employees emp
INNER JOIN departments dep ON dep.department_id = emp.department_id
ORDER BY emp.first_name, dep.department_name;

SELECT 
    emp.employee_id,
    emp.first_name,
    emp.last_name,
    dep.department_name,
    loc.street_address,
    cnt.country_name
FROM employees emp
INNER JOIN departments dep 
    ON emp.department_id = dep.department_id
INNER JOIN locations loc 
    ON dep.location_id = loc.location_id
INNER JOIN countries cnt 
    ON loc.country_id = cnt.country_id
WHERE emp.salary BETWEEN 7000 AND 10000 -- Condiçõies adicionais são adicionadas com a cláusula WHERE
ORDER BY cnt.country_name, emp.first_name, dep.department_name;

-- NATURAL JOIN faz a unificação entre tabelas de forma implícita, utilizando como chave os campos de mesmo nome
-- Os campos devem ter, além do mesmo nome, o mesmo tipo de dado, caso contrário ocasionará erros.

SELECT 
	department_id,
	department_name,
	street_address
FROM departments
NATURAL JOIN locations
ORDER BY department_name, street_address;

-- USING faz a junção entre duas tabelas, definindo em seu parâmetro o nome da coluna que será utilizada para linkar a segunda tabela
-- A coluna utilizada na cláusula USING não pode ter um alias prefixado.

SELECT 
	department_id,
	department_name,
	street_address
FROM departments
JOIN locations USING (location_id)
ORDER BY department_name, street_address;

-- SELF JOIN é utilizado quando precisamos fazer a junção de dados em uma mesma tabela

SELECT 
	emp.first_name funcionario,
	ger.first_name gerente
FROM employees emp
INNER JOIN employees ger ON emp.manager_id = ger.employee_id
ORDER BY emp.first_name, ger.first_name;

-- NONEQUIJOINS são JOIN cujas condições de ligação entre as tabelas não é uma igualdade. No exemplo abaixo, a condição para 
-- a ligação entre as tabelas é o intervalo do salário do empregado, que definirá qual é a categoria daquele funcionario.

SELECT 
	emp.employee_id id,
	emp.first_name first_name,
    emp.salary,
	grd.grade_level categoria
FROM employees emp
INNER JOIN job_grades grd
ON NVL(emp.salary, 0) BETWEEN grd.lowest_sal AND grd.highest_sal
ORDER BY emp.salary;

-- LEFT OUTER JOIN retorna todas as correspondências encontradas a partir da condição passada como argumento de ligação
-- considerando também os registros da tabela à esquerda, que podem NÃO ter correspondências com a tabela da direita.

SELECT 
	emp.employee_id,
	emp.first_name,
	dep.department_name
FROM employees emp
LEFT OUTER JOIN departments dep ON emp.department_id = dep.department_id
ORDER BY dep.department_name;

-- RIGHT OUTER JOIN funciona de forma similar ao anterior, porém considera os registros da tabela à direita.

SELECT 
	emp.employee_id,
	emp.first_name,
	dep.department_name
FROM employees emp
RIGHT OUTER JOIN departments dep ON emp.department_id = dep.department_id
ORDER BY dep.department_name;

-- FULL OUTER JOIN considera os dados das duas tabelas

SELECT 
	emp.employee_id,
	emp.first_name,
	dep.department_name
FROM employees emp
FULL OUTER JOIN departments dep ON emp.department_id = dep.department_id
ORDER BY dep.department_name;

-- CROSS JOIN faz a ligação de todos os registros para todas as tabelas envolvidas.
-- Dessa forma, em uma consulta nas tabelas employees e departments, todos os employees serão
-- linkados à todos os departments. Essa funcionalidade é conhecida como PRODUTO CARTESIANO.

SELECT 
	emp.employee_id, emp.first_name, dep.department_name
FROM employees emp
CROSS JOIN departments;

-- EQUIJOIN com syntaxe ORACLE

SELECT 
	emp.employee_id,
	emp.first_name,
	emp.salary,
	dep.department_name,
	loc.street_address
FROM 
	employees emp, departments dep, locations loc
WHERE 
	emp.department_id = dep.department_id AND
	dep.location_id = loc.location_id
ORDER BY dep.department_name, emp.salary;

-- Diferente dos JOINS escritos no padrão ANSI, no padrão ORACLE as condições adicionais também são adicionadas
-- diretamente na cláusula WHERE, juntamente com as condições de ligação.

SELECT 
	emp.employee_id,
	emp.first_name,
	emp.salary,
	dep.department_name,
	loc.street_address
FROM 
	employees emp, departments dep, locations loc
WHERE 
	emp.department_id = dep.department_id AND
	dep.location_id = loc.location_id AND
	emp.salary >= 7000
ORDER BY dep.department_name, emp.salary;

-- SELF JOIN
SELECT 
	emp.first_name nome_empregado,
	ger.employee_id id_gerente,
	ger.first_name nome_gerente
FROM employees emp, employees ger
WHERE emp.manager_id = ger.employee_id
ORDER BY emp.employee_id;

-- SELF JOIN COM RIGHT OUTER JOIN
SELECT 
	emp.first_name nome_empregado,
	ger.employee_id id_gerente,
	ger.first_name nome_gerente
FROM employees emp, employees ger
WHERE emp.manager_id = ger.employee_id (+)
ORDER BY emp.employee_id;

-- NONEQUIJOINS na syntaxe ORACLE também recebem suas condições de ligação na cláusula WHERE,
-- que pode ter ou não condições adicionais.

SELECT
	emp.first_name,
	emp.salary,
	grd.grade_level categoria
FROM 
	employees emp, job_grades grd
WHERE 
	NVL(emp.salary, 0) BETWEEN grd.lowest_sal AND grd.highest_sal
ORDER BY categoria;


-- OUTER JOINS tem uma pequena diferença na sintaxe ORACLE. Aqui, para setar qual tabela deve ser considerada como
-- LEFT ou RIGHT, é necessário colocar um "(+)" ao lado da coluna que pode não ter correspondências.

-- RIGHT OUTER JOIN
SELECT 
	emp.first_name,
	emp.department_id,
	dep.department_name
FROM 
	employees emp, departments dep
WHERE 
	emp.department_id = dep.department_id (+)
ORDER BY dep.department_name; -- Departamento pode estar nulo na tabela de funcionários

-- LEFT OUTER JOIN
SELECT 
	emp.first_name,
	emp.department_id,
	dep.department_name
FROM 
	employees emp, departments dep
WHERE 
	emp.department_id (+) = dep.department_id
ORDER BY dep.department_name; -- Departamento pode não ter empregados e os campos de empregados estar vazios

-- FULL JOIN
SELECT 
	emp.first_name,
	emp.department_id,
	emp.department_name,
FROM 
	employees emp, departments dep
WHERE
	emp.department_id (+) = dep.department_id (+)
ORDER BY dep.department_name; -- Todos os dados e as duas tabelas podem ter valores nulos.

-- PRODUTO CARTESIANO na sintaxe ORACLE
-- Para gerar um produto cartesiano nesta sintaxe, basta ignorar qualquer condição de ligação, apenas referenciando as tabelas da consulta

SELECT 
	emp.first_name, emp.last_name,
	dep.department_id, dep.department_name
FROM employees emp, departments dep;

-- ** Produtos cartesianos normalmente não são utilizados e o código acima, provavelmente será resultado de um erro de lógica
-- ou de digitação. A solução para esta questão é adicionar uma cláusula WHERE com condição de ligação.

---------------------------------------------------------------

CREATE TABLE job_grades (
	grade_level VARCHAR2(2) NOT NULL,
	lowest_sal NUMBER(11,2),
	highest_sal NUMBER(11,2), 
	CONSTRAINT job_grades_pk PRIMARY KEY (grade_level)
);

INSERT INTO job_grades VALUES ('A', 1000, 2999);
INSERT INTO job_grades VALUES ('B', 3000, 5999);
INSERT INTO job_grades VALUES ('C', 6000, 9999);
INSERT INTO job_grades VALUES ('D', 10000, 14999);
INSERT INTO job_grades VALUES ('E', 15000, 24999);
INSERT INTO job_grades VALUES ('F', 25000, 40000);

COMMIT;
