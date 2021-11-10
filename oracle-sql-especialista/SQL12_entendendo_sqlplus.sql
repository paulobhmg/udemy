/* Para conexões utilizando diretamente o SQLPLUS, utiliza-se a seguinte sintaxe:
   sqlplus username/password@stringDeConexao - onde a string de conexão é o nome do serviço definido para conexão ao banco.
   
   No SQLPLUS, o último comando executado fica armazenado no SQL Buffer, utilizando o comando "list" ou apelas "l".
   Caso queira editar o comando no editor padrão do sistema operacional, utilizar o comando "edit".
   Para executar o comando armazenado no buffer, utiliza-se o comando "run" ou "/".
   Para salvar o comando do buffer em um arquivo, utiliza-se o comando save <nomeDoArquivo.sql>.
   Para editar o arquivo criado, utiliza-se o comando edit <nomeDoArquivo.sql>.
   Para executar um arquivo de script, utiliza-se "@<nomeDoArquivo.sql>" ou "start <nomeDoArquivo.sql>".
   Para mudar para o terminal do sistema operacional, utiliza-se o comando "host" e caso queira voltar para o sqlplus, digitar "exit" no prompt do sistema operacional.
   
   Por padrão, a saída dos comando SQL são exibidos em tela, mas é possível fazer com que as saídas dos comandos executados sejam armazenadas em um
   arquivo de texto, que pode ser utilizado como um arquivo de LOG do sistema.
   Para isso, utiliza-se o comando "SPOOL <nomeDoArquivo.txt|log|sql>" e todos os comandos executados posteriormente passarão a ser armazenados neste arquivo.
   Para que os dados sejam salvos no arquivo é necessário utilizar o comando "SPOOL OFF", que fechará o arquivo contendo as alterações.
   
   
   O comando ACCEPT permite interagir com o terminal sqlplus através da criação de uma variável de substituição
   O SQL buffer armazena apenas códigos SQL. Por isso, o comando prompt não pode ser armazenado no buffer
   Para interagir com o terminal sqlplus será necessário a utilização de um arquivo de script. 
   
   
   ** Lembrar que variáveis de substituição do tipo string de caracteres ou data devem estar entre aspas simples
   
   Variáveis de ambiente do SQLPLUS irá controlar o comportamento da sessão ativa no SQLPLUS.
   As variáveis de ambiente possuem o valor padrão
   
   SHOW ALL - exibe todas as variáveis de ambientes
   SHOW <nomeDaVariavel> - Exibe o valor de uma variável
   SET <nomeDaVariavel> <valor> - Define um novo valor para a variável.
   
   SHOW verify; -- exibe o valor antigo, antes da substuição de variável
   SET  verify OFF;
   
   SHOW pause; -- aguarda a tecla ENTER para exibir uma nova página de dados de uma consulta
   SE   pause ON;
   
   ** Para sair do SQLPLUS e encerrar a SESSÃO de forma normal, executar os comandos "quit" ou "exit"
      Dessa forma, se existir alguma operação em andamento, o ORACLE efetuará o COMMIT.
      
      Sair do SQLPLUs utilizando diretamente o botão "x" do prompt de comando é a forma anormal e as operações pendentes
      receberão um ROLLBACK.
 */
