/* Comandos DML são um conjunto de comandos de manipulação de dados que afetam o estado do banco.
   - INSERT: Insere dados nas tabelas do banco
   - UPDATE: Atualiza um registro já existente no banco
   - DELETE: Remove um registro do banco
   
   Toda operação DML pertence a uma transação no banco de dados, portanto é necessário efetuar 
   um COMMIT, ROLLBACK ou SAVEPOINT dependendo da situação.
   
   O usuário da sessão que está executando a operação poderá efetuar um comando SELECT e visualizar as alterações 
   no banco antes de commitá-las com o objetivo de validar se as informações foram armazenadas corretamente.
   Porém, para os usuários de outras sessões, os novos registros, atualizações ou exclusões ó estarão disponíveis após COMMIT.
   
   Operações executadas após o commando COMMIT não poderão ser desfeitas.
*/

-- Inserindo um registro explicitando todas as colunas da tabelas

INSERT INTO departments (department_id, department_name, manager_id, location_id)
VALUES (271, 'Development', NULL, NULL);

-- Inserindo um registro com valores NULL implícitos

INSERT INTO departments (department_id, department_name)
VALUES (272, 'Support Analisys');

-- Inserindo registro ocultando colunas

INSERT INTO departments VALUES (273, 'Front Develpment', NULL, NULL);

COMMIT;
-----------------------------------------------------

-- Inserindo novo funcionário

SELECT * FROM employees ORDER BY employee_id DESC;

INSERT INTO employees (employee_id, first_name, last_name, email, hire_date, job_id, salary, department_id)
VALUES (207, 'Paulo', 'Nogueira', 'paulo@gmail.com', TO_DATE('03/11/2021', 'DD/MM/YYYY'), 'IT_PROG', 6850, 271);

COMMIT;

-- Utilizando variáveis de substituição para INSERIR dados

INSERT INTO departments (department_id, department_name, manager_id, location_id)
VALUES (&department_id, '&department_name', &manager_id, &location_id);

SELECT * FROM departments ORDER BY department_id DESC;

COMMIT;
------------------------------------------------------

-- É possível INSERIR registros a partir de uma consulta SELECT. A quantidade de colunas para o INSERT deve ser igual
-- à quantidade de colunas recuperadas no SELECT, que devem ter o mesmo tipo da sua respectiva coluna.
-- Porém, não é possível utilizar a cláusula VALUES na insersão dos valores.

INSERT INTO sales_reps
SELECT employee_id, first_name, salary, NVL(commission_pct, 0)
FROM   employees
WHERE  employee_id BETWEEN 100 AND 110;

SELECT * FROM sales_reps;

COMMIT;

INSERT INTO 
-------------------------------------------------------

-- Atualizando registros com UPDATE
-- Atentar-se à NUNCA esquecer de limitar a atualização apenas a registros específicos através da cláusula WHERE.

UPDATE sales_reps 
SET    salary = salary * 1.2
WHERE  id = 100;

SELECT * FROM sales_reps;

COMMIT;

-- O comando UPDATE também pode ser utilizado com subconsultas

UPDATE sales_reps
SET    salary = salary * 1.3
WHERE  name = ( SELECT name
                FROM sales_reps
                WHERE name = 'David');
                
SELECT * FROM sales_reps;

COMMIT;

-- Exemplo de UPDATE com resultado incorreto
-- No exemplo abaixo, o EXISTS irá executar uma comparação para cada registro da tabela e caso a subconsulta tenha sua condição atendida
-- retornará TRUE.

UPDATE sales_reps
SET    salary = salary * 1.3
WHERE  EXISTS ( SELECT salary
                FROM   sales_reps
                WHERE  salary < 5000);

ROLLBACK;
--------------------------------------------------------

-- Removendo registros com DELETE
-- Importantíssimo atentar-se a cláusula WHERE para limitar quais são os registros que deverão ser apagados.

-- Tabela para exemplo prático de INSERSÃO de dados

DELETE FROM sales_reps
WHERE id = 105;

SELECT * FROM sales_reps;

COMMIT;
---------------------------------------------------------

/* Uma TRANSAÇÃO pode se iniciar no momento em que o banco ORACLE é aberto ou no momento em que um comando DML é executado.
  - O fim de uma transação é dado a partir do momento em que ocorre o evento de COMMIT ou ROLLBACK.
  - Comandos DDL e DCL iniciam e finalizam transações com COMMIT ou ROLLBACK automático, sendo o COMMIT caso não tenha lançado
    erros e o ROLLBACK nos casos em que algum erro ocorre no momento de sua execução.
  - Transações também podem ser encerradas em casos de finalização de Sessão no SQL PLUS ou afins e também quando ocorre
    um CRASH no sistema, que significa algum erro no sistema operacional, no cliente de bancos de dados, etc. Isso ocasiona automaticamente um ROLLBACK.
    
  - O controle de transações permite garantir a consistência dos dados, pois permite visualizar as mudanças dos dados antes de efetivamente ser alterados
  - Permite também agrupar operações relacionadas logicamente, de forma que ou TODOS os comandos executados são efetivados ou NENHUM.
  
  - É possível criar SAVEPOINTS em uma transação, marcando pontos para retornar o estado das operações já executadas, nos casos em que ocorra algum erro
  - ou comportamento inesperado. Quando isso ocorre é possível desfazer as operações feitas a partir de um SAVEPOINT específico.
  - As linhas manipuladas dentro de uma TRANSAÇÃO ficarão com o estado LOCKED até que a transação seja finalizada com COMMIT ou ROLLBACK e 
    caso outra sessão tente manipular os registros contidos naquela transação, ficarão com estado WAIT até que a transação seja concluída.
    
  - Se um comando DML falha durante uma transação, APENAS o comando atual é desfeito, pois o ORACLE implementa um SAVEPOINT implícito,
    mantendo a transação ativa e o usuário da sessão deverá commitar ou efetuar o rollback de forma explícita.
    
  - O oracle faz a leitura consistente, garantindo que os dados recuperados por um SELECT sejam do momento atual e não serão modificados
    por alterações feitas por outras transações após o momento da consulta.
  
  - Leituras não esperam por escritas: SELECT's não geram locks 
  - Escritas não esperam por leituras: DML não esperam por SELECT'S
  - Escritas esperam por escritas: Alterações alteram o estado para lock, portanto, escritas devem esperar.
  
  - A leitura consistente é garantida através de SEGMENTOS UNDO, que fazem que as as consultas a dados que estão em transação
    sejam feitas em um bloco específico que armazena o estado dos dados antes de serem alterados.
*/

INSERT INTO sales_reps 
VALUES (200, 'Paulo', 299999, 0.8);

COMMIT;

INSERT INTO sales_reps
VALUES (201, 'Nadille', 299929, 0.8);

INSERT INTO sales_reps
VALUES (202, 'Tiago', 991219, 0.09);

SAVEPOINT user_created;

DELETE FROM sales_reps
WHERE id = ( SELECT DISTINCT id
             FROM   sales_reps
             WHERE  id = 201);

ROLLBACK TO SAVEPOINT user_created;

COMMIT;

SELECT * FROM sales_reps;

-- FOR UPDATE permite bloquear os dados de uma consulta SELECT para que eles não possam ser alterados até que a consulta esteja concluída
-- Para desbloquear os registros da consulta, é necessário utilizar o COMMIT.

SELECT firt_name, last_name, job_id, salary
FROM   employees
WHERE  salary > 10000
FOR UPDATE
ORDER BY salary;

COMMIT;

-- Nos casos em que há JOINS entre mais de uma tabela e há a necessidade de bloquear uma consulta para evitar que seja feita alguma transação
-- mas não há a necessidade de bloquear todas as tabelas, é necessário usar o FOR UPDATE OF, mencionando uma coluna de uma da tabela que se deseja bloquear.

SELECT e.first_name, e.last_name, e.job_id, e.salary, d.department_name
FROM   employees e
INNER  JOIN departments d USING (department_id)
WHERE  e.salary > 10000
FOR UPDATE OF e.salary
ORDER BY e.salary; -- Dessa forma, as transações serão bloqueadas apenas para a tabela de employees, deixando a tabela departments livre para transações.

COMMIT;

-- Tabela para exercitar

CREATE TABLE sales_reps (
  id NUMBER(6,0),
  name VARCHAR(20),
  salary NUMBER(8,2),
  commission_pct NUMBER(2,2)
);
