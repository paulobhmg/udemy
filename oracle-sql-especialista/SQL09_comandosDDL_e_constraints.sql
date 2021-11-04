/* Comandos DDL são executados de forma a manipular os objetos de bancos de dados do SCHEMA do usuário logado ou outro.
  
  O que é um Schema?
  Cada usuário possui um Schema, que são seus objetos.
  tables, triggers, procedures e functions, sequences e indexes são todos objetos de um Schema.
  Não é permitido ter duas tabelas de mesmo nome em um mesmo Schema.
*/

-- Tabelas de dicionários de dados

DESC user_tables; 
DESC user_objects;

DESC use_constraints; 
DESC user_cons_columns;
  
-- Lista de objetos existentes no usuário atual.

SELECT * 
FROM   user_objecs
ORDER  BY object_type;

SELECT table_name
FROM   user_tables;

-- Para criar tabelas é necessário ter privilégios e espaço de armazenamento (storage area)
-- Na criação de uma tabela é necessário especificar cada coluna a partir de um nome, um tipo, tamanho máximo e opcionalmente um valor default.
-- Por padrão, uma tabela será criada no SCHEMA atual e para criar uma tabela para outro SCHEMA é necessário referenciar o 
-- ONWER daquele schema com a sintaxe SCHEMA.TABLE, assim como referenciá-la nas consultas.

SELECT *
FROM   SCHEMA1.employees;

/* Tipos de dados 
   - LONG armazena caracteres de tamanho variável até 2GB -1 (texto)
   - CLOB similar ao LONG, porém comporta tamanho maior
   - RAW  dados binários tamanho máximo 2000 bytes (imagens, sons, vídeos, PDF, doc)
   - LONG RAW dados binários de amanho vaiável de até 2GB -1
   - BLOB dados binários com tamanho até 4GB ou mais
   - BFILE ponteiro para um arquivo externo de tamanho máximo de 4GB
   - ROWID armazena o endereço lógico de uma linha de tabela (String representando 64bits)
   - BYNARY_FLOAT armazena dados numéricos no formato ponto flutuante 32-bits.
   - BYNARY_DOUBLE armazena no formato ponto flutuante com precisão dupla 64-bits.
   - Os dois anteriores são mais performáticos do que operações com NUMBER, pois requerem menos espaço de armazenamento.
   - TIMESTAMP armazena até 9 dígitos decimais de segundo, fornecendo mais precisão que o DATE
   - INTERVAL YEAR TO MONTH formato de intervalo de anos e meses entre duas datas
   - INTERVAL DAY TO SECOND formato de itervalo de dias, horas, minutos e segundos entre duas datas.
*/

-- Exemplo de criação de tabelas

DROP TABLE projects;

CREATE TABLE projects (
	project_id   NUMBER(6) NOT NULL,
	project_code VARCHAR2(10) NOT NULL,
	project_name VARCHAR2(100) NOT NULL,
	created_at   DATE DEFAULT SYSDATE NOT NULL,
	started_at   DATE,
	finished_at  DATE,
	status	     VARCHAR2(20) NOT NULL,
	priority     VARCHAR2(10) NOT NULL,
	budget 	     NUMBER(11,2) NOT NULL,
  description  VARCHAR2(400) NOT NULL
);

DROP TABLE teams;

CREATE TABLE teams(
	project_id  NUMBER(6) NOT NULL,
	employee_id NUMBER(6) NOT NULL
);

-- É possível criar tabelas a partir do resulado de consultas e a tabela terá os mesmos campos contidos na consulta.

CREATE TABLE employees_department60 AS
SELECT first_name, last_name, department_id, salary
FROM   employees
WHERE  department_id = 60;

-- É possível recuperar uma tabela DROPADA que está na lixeira. 
-- Porém, caso queira que uma tabela não vá para a lixeira, é necessário adicionar a cláusula PURGE ao final da query.

DROP TABLE employees_department60 
PURGE;

-- Para DROPAR tabelas que possuem CONSTRAINS de relacionamento com outras tabelas, é necessário utilizar o CASCADE CONSTRAINTS;

DROP TABLE employees_department60 
CASCADE CONSTRAINTS 
PURGE;

-- Ao adicionar uma nova coluna, caso já existam dados na tabela, o valor da coluna será NULL para cada registro da tabela. 
-- Caso não queira esse comportamento é necessário configurar um valor DEFAULT ao adicionar essa nova coluna.

ALTER TABLE employees_department60
ADD (job_id NUMBER(3));

-- Removendo colunas de uma tabela
ALTER TABLE employees_department60
DROP COLUMN job_id;

-- Alterando os o tipo de uma coluna
ALTER TABLE projects
MODIFY (project_code VARCHAR2(6));

ALTER TABLE projects
RENAME COLUMN project_name TO name;

-- Alterando estado da tabela
ALTER TABLE projects READ ONLY;

ALTER TABLE projects READ WRITE;

/* CONSTRAINTS são regras de integridade para uma coluna ou tabela que impedem operações DML ou DDL que violem uma CONSTRAINT.

  - Ao criar uma CONSTRAINT, deve-se definir um nome.
  - O oracle cria indices únicos automáticos para todas as CONSTRAINTS com excessão da FOREIGN KEY, nomeado-as de acordo com seu próprio padrão.
  - CONSTRAINTS podem ser criadas no momento da definição da tabela ou após a sua criação utilizando a cláusula ALTER TABLE.
  - CONSTRAINTS podem ser consultadas pelo dicionário de dados através das colunas USER_CONSTRAINTS e USER_CONS_COLUMNS

  - PRIMARY KEY estabelece uma identificação única para um registro. ( P ) 
  
  - UNIQUE estabelece identificação única para outros campos da tabela que não são primary key. ( U ) 
  
  - NOT NULL impede a insersão de valores nulos.
  
  - FOREIGN KEY estabelece a relação entre duas tabelas, garantindo sua integridade. ( R - reference)
    A integridade se refere ao fato de não ser possível inserir como chave estrangeira um valor de ID de um dado que não existe.   
    O oracle não cria índices únicos automáticos para as FOREIGN KEYS. Esses deverão ser criados de forma manual e não serão únicos.
    
  - CHECK faz uma validação em uma coluna, garantindo a coluna aceite apenas os valores que atendam a condição passada em seu parâmetro. ( C )
    Não é permitido passar como parâmetro referência às pseudocolunas CURRVAL, NEXTVAL, LEVEL E ROWNUM, bem como chamar as funções SYSDATE, UID, USER E USERENV
    Também não é permitido referenciar consultas de outras tabelas ou outras linhas da mesma tabela.
*/

SELECT UID, USERENV('language'), USER, SYSDATE 
FROM dual;

SELECT employee_id, first_name, ROWNUM
FROM employees;

-- CONSTRAINTS a nível de coluna.

DROP TABLE projects; -- testar o comando abaixo dps.
DROP TABLE projects CASCADE CONSTRAINTS; -- Dropa uma tabela, removendo as referências existentes em outras tabelas.

CREATE TABLE projects(
	project_id     NUMBER(6) NOT NULL CONSTRAINT projects_project_id_pk PRIMARY KEY,
	project_code   VARCHAR2(6) NOT NULL CONSTRAINT projects_project_code_uk UNIQUE,
	project_name   VARCHAR2(10),
	department_id  NUMBER(4) NOT NULL CONSTRAINT projects_department_id_fk REFERENCES departments (department_id)
);

-- CONSTRAINTS a nivel de tabela.

DROP TABLE projects;

CREATE TABLE projects(
	project_id    NUMBER(6),
	project_code  VARCHAR(6),
	project_name  VARCHAR(10),
	department_id NUMBER(4) NOT NULL,
	CONSTRAINT projects_project_id_pk PRIMARY KEY (project_id),
	CONSTRAINT projects_project_code_uk UNIQUE (project_code),
	CONSTRAINT projects_department_id_fk FOREIGN KEY (department_id) REFERENCES departments (department_id)
);

-- Por padrão, as regras de deleção de uma CONSTRAINT é definida como NO ACTION. 
-- Isso significa que o banco de dados não efetuará a deleção de tabelas que possuem relacionamento ativo em outras tabelas.

-- Ao dropar uma tabela que é referenciada em outras, é possível permitir a deleção em cascata de todos os registros, utilizando o padrão ON DELETE CASCADE.
-- Isso irá eliminar todos os registros das outras tabelas que fazem referência à tabela dropada.

CREATE TABLE projects (
	project_id    NUMBER(6),
	project_code  VARCHAR(6),
	budge         NUMBER(6,2) NOT NULL CONSTRAINT projects_budge_ck CHECK (budge > 0),
	department_id NUMBER(4) NOT NULL,
	CONSTRAINT projects_department_id_fk FOREIGN KEY (department_id) REFERENCES departments (department_id)
	ON DELETE CASCADE
);

-- De forma similar à anterior, o padrão ON DELETE SET NULL não apagará os registros das outras tabelas, mas definirá os valores como nulos.
-- Para que isso ocorra, a coluna de chave estrangeira na outra tabela deverá aceitar valores nulos

CREATE TABLE projects(
	project_id    NUMBER(6),
	project_code  VARCHAR(6),
	budge	      VARCHAR(6,2) NOT NULL,
	department_id NUMBER(4),
	CONSTRAINT projects_budge_ck CHECK (budge > 0),
	CONSTRAINT projects_department_id_fk FOREIGN KEY (department_id) REFERENCES departments (department_id)
	ON DELETE SET NULL
	ON UPDATE CASCADE
);

-- Adicionar, remover ou desabilitar CONSTRAINTS a partir do ALTER TABLE

ALTER TABLE projects ADD CONSTRAINT projects_department_id_fk (department_id) REFERENCES departments (department_id);
ALTER TABLE projects DROP CONSTRAINT projects_department_id_fk CASCADE;
ALTER TABLE projects DISABLE CONSTRAINT projects_department_id_fk CASCADE;




