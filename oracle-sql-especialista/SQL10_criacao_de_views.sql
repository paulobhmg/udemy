/*  Views são representações lógicas de um ou mais SELECT's baseado em uma ou mais tabelas ou em uma ou mais visões.
  - São subconjuntos lógicos dos dados de consultas de uma ou mais tabelas.
  - As views são armazenadas no dicionário de dados juntamente com o SELECT que a gerou e podem ser referenciadas
    da mesma forma que uma consulta comum.

  Vantagens de utilizar VIEWS
  - Restrição do acesso aos dados
  - Tornar simples consultas complexas através da abstração de código repetitivo
  - Proporcionar independência dos dados: não importa como é feito a consulta
  - Representar diferentes visões do mesmo dado

  - Views simples permitem operações DML.
  - Views complexas que possuem mais de uma tabela TALVEZ permitam.
  - Views complexas que possuem mais de uma tabela, contém funções e agrupamentos de dados NÃO permitem.
*/

-- VIEW simples

CREATE OR REPLACE VIEW vemployeesdept60
AS
SELECT employee_id, first_name, last_name, department_id, salary
FROM employees
WHERE department_id = 60;

DESC vemployeesdept60;

SELECT * from 
vemployeesdept60;

-- VIEW complexa

CREATE OR REPLACE VIEW vdepartments_total (department_id, department_name, minsal, avgsal) AS
SELECT 
	department_id, 
	department_name, 
	ROUND(MIN(NVL(salary, 0)), 2) minsal, 
	ROUND(AVG(NVL(salary, 0)), 2) avgsal
FROM employees
INNER JOIN departments USING(department_id)
GROUP BY department_id, department_name
ORDER BY department_name;

DESC vdepartments_total;

SELECT * 
FROM vdepartments_total;

-- NÃO é permitido UPDATE em views que possuem:
-- Funções de grupo, GROUP BY, DISTINCT, ROWNUM e colunas definidas por expressões
-- Para INSERT, além das restrições acima, não é permitido operar em VIEWS cujas colunas NOT NULL
   nas tabelas base não estejam no SELECT da view.

-- É possível criar uma CONSTRAINT CHECK na definição de uma VIEW utilizando a cláusula WHERE para validação.
-- Sendo assim, se o valor da cláusula WHERE for dinâmico e for diferente do valor definido pela constraint, lança um erro.

CREATE OR REPLACE VIEW vemployeedept100 AS
SELECT employee_id, first_name, last_name, department_id, salary
FROM   employees
WHERE  department_id = 100
WITH CHECK OPTION CONSTRAINT vemployeesdept100_ck;

DESC vemployeedept100;

-- Para criar VIEWS apenas para leitura, utiliza-se a cláusula WITH READ ONLY

CREATE OR REPLACE VIEW vemployeedept100 AS
SELECT employee_id, first_name, last_name, department_id, salary
FROM   employees
WHERE  department_id = 100;
WITH   READ ONLY;
