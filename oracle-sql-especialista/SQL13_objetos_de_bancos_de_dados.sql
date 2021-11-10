/* Os objetos oracle são classificados em dois tipos
   
  1 - SCHEMA OBJECTS (Objetos dos usuários do banco de dados)
  2 - NONSCHEMA OBJECTS (Objetos que não pertencem a um SCHEMA de usuário do banco de dados)

  Cada usuário possui um e apenas um SCHEMA.
  Schema Objects é uma coleção de estruturas lógicas de objetos de um usuário.
 
  Os objetos podem ser: 
  Tabelas 
    - Unidade base de armazenamento de dados composta por linhas e colunas
  Views 
    - Consulta armazenada no dicionário de dados, referenciando registros de outras tabelas ou views
  Sinonimos
    - Nome alternativo para objetos de bancos de dados
  Visões materializadas 
    - Views que possuem uma tabela real preenchida com o resultado de uma consulta SQL, truncada a cada referenciação.
  Constraints 
    - Regras de restrição para validação de entradas de dados e integridade das tabelas
  Database Links 
    - Conexões entre um ou mais bancos de dados
  Índices 
    - Otimizam a performance da recuperação de dados de tabelas
  Procedures e functions
    - Rotinas que executam tarefas a partir de eventos do banco de dados, compiladas e armazenadas no banco de dados
  Packages 
    - Programados em PL/SQL e armazenam um conjunto de funções, triggers, procedures, etc.
  Triggers
    - Unidades (gatilhos) compiladas e armazenadas no banco de dados que fazem chamadas às procedures e functions.
  Sequences
    - Incrementam valores de colunas automaticamente
*/

-- Objetos de usuários comuns

DESC user_objects;

SELECT 
  object_id, 
  object_name, 
  object_type,
  status
FROM user_objects
ORDER BY object_type;

SELECT * FROM user_tables;
SELECT * FROM user_sequences;
SELECT * FROM user_indexes;
SELECT * FROM user_constraints;
SELECT * FROM user_procedures;
SELECT * FROM user_views;
SELECT * FROM user_synonyms;
SELECT * FROM user_sys_privs; -- Privilégios sys para o usuário atual

-- Para o usuário DBA, existe um campo a mais que é o owner, permitindo visualizar quem é o dono de objetos.

DESC dba_objects;

SELECT 
  owner,
  object_id,
  object_name,
  object_type,
  status
FROM dba_objects
ORDER BY owner, object_type;
  

-- Os NONSCHEMA objects não pertencem a nenhum SCHEMA de usuários e são utilizados apenas pelo DBA.

SELECT * FROM dba_tablespaces;
SELECT * FROM dba_users;


-- É possível acessar informações de objetos de SCHEMAS de outros usuários prefixando o nome do usuário owner do SCHEMA
-- ou a partir de um sinônimo público. Para isso, é necessário que o usuário tenha as devidas permissões no SCHEMA desejado.

DROP USER aluno;

CREATE USER aluno
IDENTIFIED BY aluno;
DEFAULT TABLESPACE users
TEMPORARY TABLESPACE temp
QUOTA UNLIMITED ON USERS;

-- Privilégio apenas para conexão ao banco

GRANT CREATE SESSION TO aluno;

GRANT SELECT ON hr.employees TO aluno;
REVOKE SELECT ON hr.employees FROM aluno;

CREATE PUBLIC SYNONYM empregados
FOR hr.employees;

GRANT SELECT ON empregados TO aluno;
