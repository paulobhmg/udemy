/* SEQUENCES são utilizadas para geração automática de números sequenciais
   e sua principal utilização é a geração de números sequenciais para chaves primárias.
   Sequences permitem otimizar a performance de acesso aos valors gerados, utilizando CACHE em memória.
   
   Uma SEQUENCE é uma estrutura desvinculada de uma tabela e é recomendado sua criação para cada tabela.
   
   A sintaxe de criação de uma sequência é:
   CREATE SEQUENCE <nome>
   [INCREMENT BY n]
   [START WITH n]
   [{MAXVALUE n | NOMAXVALUE}]
   [{MINVALUE n | NOMINVALUE}]
   [{CYCLE | NOCYCLE}] - Se marcado, ao atingir o valor máximo, ao pedir o próximo número volta pro início
   [{CACHE n | NOCACHE}] 
   
   As SEQUENCES existentes no dicionário de dados do usuário logado estão disponíveis na tabela USER_SEQUENCES;
*/

-- Obtendo maior ID de empregados
SELECT MAX(employee_id)
FROM employees;

DROP SEQUENCE employees_seq;

CREATE SEQUENCE employees_seq
START WITH 209
INCREMENT BY 1
NOMAXVALUE
NOCACHE
NOCYCLE;

-- Para alterar a SEQUENCE, basta utilizar o comando ALTER SEQUENCE e passar novamente os parâmetros, se for o owner ou ter privilégios para tal
-- Os valores tem que ser Coerentes, ou seja, não podem violar as regras já criadas anteriormente para a SEQUENCE.
 
ALTER SEQUENCE employee_seq
CACHE 20;

-- Consultando SEQUENCES

SELECT * FROM user_sequences;

-- NEXTVAL é um método existente em uma SEQUENCE que retorna o seu próximo valor. Cada vez que ele é referenciado
-- gera um novo valor sequencial e seu uso indevido poderá ocasionar buracos na sequência.
-- Caso isso ocorra será necessário dropar a SEQUENCE e recriá-la iniciando a partir do valor desejado.

DROP SEQUENCE employees_id;
SELECT employees_seq.NEXTVAL FROM dual;

-- CURRVAL retorna o valor atual da SEQUENCE
-- Este método só poderá ser utilizado após o método anterior ter sido referenciado ao menos uma vez na sessão

SELECT employees_seq.CURRVAL FROM dual; 

-- Na prática, as SEQUENCES são implementadas de fato em comandos INSERT.
-- Vale observar que uma transação que esteja utilizando uma SEQUENCE, caso haja um ROLLBACK, o incremento da SEQUENCE não é desfeito.

INSERT INTO employees (employee_id, first_name, last_name, email, hire_date, job_id)
VALUES (employees_seq.NEXTVAL, 'Tiago', 'Nogueira', 'tiagobh.85@gmail.com', '27/09/2021', 'SOFT_ENG');

COMMIT;

--------------------------------------------------------------------------

/* 
  ÍNDICES são objetos de bancos de dados oracle utilizados para melhorar a performance durante a execução das consultas
  São independentes de tabelas e são mantidos automaticamente pelo banco de dados, sendo atualizados e gerenciados
  a cada operação DML realizada.
  
  Muitas das vezes em consultas SELECT, para satisfazer a condição WHERE, o oracle vai utilizar o FULL TABLE SCAN, que
  consiste em percorrer toda uma tabela para encontrar os registros que atendam à condição.
  
  ÍNDICES são criados automaticamente pelo oracle para colunas PRIMARY KEY e UNIQUE.
  Podem ser criados manualmente para os campos de referência FOREIGN KEY e também para demais colunas muito utilizadas em consultas.
  
  CREATE [UNIQUE][BITMAP] INDEX <nome>
  ON <nome_tabela>(<campo>)
  
  Os ÍNDICES disponíveis podem ser consultados através do dicionário de dados user_indexes e user_ind_columns;
*/

SELECT * FROM user_indexes
WHERE table_name = 'EMPLOYEES';

DROP INDEX emp_name_ix;

CREATE INDEX emp_name_ix
ON employees (first_name);

-- Antes de executar a consulta a seguir, verificar o plano de explicação utilizado pelo BD sem index.

SELECT * from employees
WHERE first_name = 'Tiago';

-- Na fase de execução da consulta, quem define se vai ou não utilizar o INDEX é o ORACLE, mas quem decide
-- como ele será utilizado é o processo OPTMIZER, que vai traçar o melhor plano de execução para a utilização do ÍNDEX.

-- Para reorganizar ou reindexar um index, utiliza-se o operador REBUILD;

ALTER INDEX emp_name REBUILD;


/* SINONIMOS são objetos de bancos de dados ORACLE utilizados para apelidar outro objeto, facilitando seu acesso 
   através de uma espécie de apelido.
   
   É necessário permissão para poder criá-los e apenas o DBA poderá criar SINÔNIMOS PÚBLICOS.
*/


-- SINÔNIMOS PRIVADOS
CREATE SYNONYM departamentos
FOR departments;

SELECT * FROM departamentos;

DROP SYNONYM departamentos;


-- SINÔNIMOS PÚBLICOS (criados apenas pelo DBA)
CREATE PUBLIC SYNONYM departamentos
FOR hr.departments;

SELECT * FROM departamentos;

DROP PUBLIC SYNONYM departamentos;
