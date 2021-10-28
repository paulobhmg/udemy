/* Funções Single Row são funções que retornam um valor para cada linha recuperada em um SELECT
   Cada função tem um nome e recebe uma lista de argumentos de acordo com seu objetivo e sintaxe.
   
   - Podem manipular itens de dados, receber argumentos e retornar um valor
   - Atuam sobre cada linha retornada e retorna um valor
   - Podem modificar o tipo de dado e ser aninhadas
   - Podem receber como argumento colunas ou expressões
   
   Este arquivo contempla funções para manipulação de Strings, Numbers e Datas
*/

-- Funções que manipulam caracteres
-- Conversão de caracteres maiúsculos e minúsculos

SELECT employee_id, last_name, department_id
FROM employees 
WHERE UPPER(last_name) = 'KING'; 

SELECT employee_id, last_name, department_id
FROM employees
WHERE LOWER(last_name) = 'king'; 

SELECT employee_id, last_name, department_id
FROM employees
WHERE INITCAP(last_name) = 'King';

-- Concatenação

SELECT CONCAT('Curso: ', 'Introdução Oracle') FROM dual;

-- SUBSTRING retorna uma parte de uma String de caracteres recebido como argumento
-- Iniciando da posição informada no primeiro parâmetro até a posição informada no segundo parâmetro, incluindo ambos.

SELECT SUBSTR('Introdução ao banco de dados Oracle', 1, 11)
FROM dual;

-- INSTR retorna a posição inicial de uma String de carateres passada como argumento

SELECT INSTR('Introdução ao banco de dados Oracle', 'Oracle') 
FROM dual;

-- LENGTH retorna o tamanho de um dado String de caracters

SELECT LENGTH('Oracle') FROM dual;

-- A partir da combinação das duas últimas, é possível deixar dinâmica a função SUBSTR

DEFINE palavra = 'Oracle';
DEFINE inicio = INSTR('Introdução ao banco de dados Oracle', '&palavra');
DEFINE tamanho = LENGTH('&palavra');

SELECT SUBSTR('Introdução ao banco de dados Oracle', &inicio, &inicio + &tamanho)
FROM dual;

-- LPAD e RPAD alinham um texto à esquerda e à direita, respectivamente, definindo em seu segundo parâmetro qual será o 
-- tamanho do texto e em seu terceiro, qual será o caracter que irá preencher os espaços restantes. 

SELECT 
	RPAD('Texto alinhado à direita.', 40, '*') "RPAD", 
	LPAD('Texto alinhado à esquerda.', 40, '*') "LPAD"
FROM dual;

SELECT 
	RPAD('Texto alinhado à direita com espaços.', 40, ' ') "RPAD",
	LPAD('Texto alinhado à esquerda com espaços.', 40, ' ') "LPAD"
FROM dual;

-- REPLACE recebe como parâmetros um texto, uma String a ser encontrada e uma String que substituirá a String encontrada
-- Pode ser utilizada em resultados de outros replaces.

SELECT 
	REPLACE(
		REPLACE(
			REPLACE('Baixei o Oracle 21c e estou estudando arduamente',
				'21c', '18c'
			),'Baixei', 'Instalei'
		),'estudando', 'fritando'
	) texto
FROM dual;

----------------------------------------------------------------------------------------------------

-- Funções para manipulação de números
-- ROUND arredonda um número para cima, passando o número de casas decimais desejado, levando em consideração 
-- a precisão do número e a regra matemática para o arredondamento

SELECT ROUND(6.852,2) duas_casas
FROM dual; -- arredonda pra 2 casas decimais

SELECT ROUND(6.856,0) zero_casas
FROM dual; -- arredonda para 0 casas decimais

SELECT ROUND(6.499,0) zero_casas
FROM dual; -- notar que sempre arredonda para cima

-- TRUNC, diferente da função anterior, corta o número decimal a partir do parâmetro informado,
-- ignorando completamente o arredondamento. O que acontece aqui é a remoção da parte fracionária de um número

SELECT TRUNC(45.923,2) duas_casas
FROM dual; 

SELECT TRUNC(45.929,2) duas_casas
FROM dual; 

SELECT TRUNC(6.856,0) zero_casas
FROM dual; -- notar que para os dois últimos exemplos não houve arredondamento

-- MOD retorna o resto de uma divisão

SELECT MOD(1630,225) resto
FROM dual;

-- ABS retorna o valor absoluto de um número

SELECT ABS(-5) FROM dual;

-- SQRT retorna a raiz quadrada de um número

SELECT SQRT(81) FROM dual;

-- POWER retorna a exponenciação

SELECT POWER(10, 2) FROM dual;

---------------------------------------------------------------------------------------------------

-- Funções para manipulação de datas 
-- O padrão das datas utilizadas nos bancos de dados Oracle é definodo pelo DBA através do parâmetro NLS_DATE_FORMAT

-- SYSDATE retorna a data atual
SELECT SYSDATE FROM dual;

/* Cálculos com datas
   - data + n = data + n dias
   - data - n = data - n dias
   - data - data   = diferença de n dias entre duas datas
   - data + (n / 24) = adiciona n horas para uma data
*/

SELECT SYSDATE + 2 data_contrato
FROM dual;

SELECT SYSDATE - 30 data_mes_passado 
FROM dual;

SELECT 
	employee_id, first_name, hire_date,
	ROUND((SYSDATE - hire_date) / 7, 2) semanas_trabalhadas 
FROM employees;

/*  Funções úteis para datas
	- MONTHS_BETWEEN retorna o número de meses entre duas datas
	- ADD_MONTHS retorna a data adicionada x meses
	- NEXT_DAY retorna o próximo dia relativo à data específica
	- LAST_DAY retorna o último dia do mês em relação à uma data
	- ROUND arredonda uma data
	- TRUNC trunca a data
	
	- ROUND(SYSDATE, 'MONTH') arredonda para o 1° dia do próximo mês ou primeiro dia do mês atual, considerando a metade do mês para o cálculo
	- ROUND(SYSDATE, 'YEAR')  similar à função acima, porém arredonda o para o início do ano vigente ou o próximo
	
	- TRUNC(SYSDATE, 'MONTH') considera a data como o primeiro dia do mes
	- TRUNC(SYSDATE, 'MONTH') considera a data como primeiro dia do ano
	
	- TRUNC(SYSDATE) zera a data atual, considerando a hora como 00:00:00
	- Esta última opção é muito utilizada quando não há a necessidade de considerar a hora em uma data.
*/

SELECT 
	employee_id, first_name, last_name hire_date,
	ROUND(MONTHS_BETWEEN(SYSDATE, hire_date),2) months
FROM employees; -- diferença entre meses

SELECT 
	employee_id, first_name, last_name, hire_date,
	ADD_MONTHS(hire_date, 12) year_complete
FROM employees; -- adicionando meses

SELECT NEXT_DAY(SYSDATE, 'Quarta Feira') dia
FROM dual; -- próxima quarta feira a partir da data informada
	
SELECT LAST_DAY(SYSDATE) ultimo_dia
FROM dual; -- último dia do mês referente à data argumento


SELECT ROUND(SYSDATE, 'MONTH') arredonda_mes
FROM dual;

SELECT ROUND(SYSDATE, 'YEAR') arredonda_ano
FROM dual;

SELECT TRUNC(SYSDATE, 'MONTH') trunca_mes
FROM dual;

SELECT TRUNC(SYSDATE, 'YEAR') trunca_ano
FROM dual;

SELECT 
	TO_CHAR(SYSDATE, 'DD/MM/YYYY HH24:MI:SS') data_hora_atual,
	TO_CHAR(TRUNC(SYSDATE), 'DD/MM/YYYY HH24:MI:SS') data_hora_zerada
FROM dual;
