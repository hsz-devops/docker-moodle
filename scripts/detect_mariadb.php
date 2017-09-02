
<?php

/**
* @param string $host The database host
* @param string | int $port The database port
* @param string $database The database itself
* @return string
*/
function gererateDbConnectionString($host,$port,$database) {
  $connectionString="mysql://host=$host;dbname=$database;port=$port";
  return $connectionString;
}

/**
* @param PDO $pdo
* @return String
*/
function detectMysqlOrMariaDb(PDO $pdo){
  $version=$pdo->query('select version()')->fetchColumn();
  if(preg_match("/^(\d*\.?)*-MariaDB-.*$/g",$version)){
    return 'mysqli';
  } else {
    return 'mariadb';
  }
}

/**
* Connection info
*/
$host=argparse('MOODLE_DB_HOST');
$port=argparse('MOODLE_DB_PORT');
$database=argparse('MOODLE_DB_NAME');
$username=argparse('MOODLE_DB_USER');
$password=argparse('MOODLE_DB_PASSWORD');

try {
  $connectionString=gererateDbConnectionString($host,$port,$database);
  $pdo=new PDO($connectionString,$username,$password);
  echo detectMysqlOrMariaDb($pdo);
  exit(0)
} catch (PDOExcetion $e) {
  file_put_contents('php://stderr',$e->getMessage(),FILE_APPEND);
  exit(1)
}
