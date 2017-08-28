<?php

$dbtype=getenv('MOODLE_DB_TYPE');
$dbhost=getenv('MOODLE_DB_HOST');
$dbname=getenv('MOODLE_DB_NAME');
$dnuser=getenv('MOODLE_DB_USER');
$dbpassword=getenv('MOODLE_DB_PASSWORD');
$dbport=getenv('MOODLE_DB_PORT');


/**
* @param string $type  The database type
* @param string $host The database host
* @param string | int $port The database port
* @param string $database The database itself
* @return string
*/
function gererateDbConnectionString($type,$host,$port,$database) {

  $connectionString=""

  switch($type){
    case 'mysqli':
    case 'mariadb':
      $connectionString="mysql://host=$host;dbname=$database;port=$port";
      break;

    case 'postgresql':
        $connectionString="pgsql://host=$host;dbname=$database;port=$port";
      break;
  }

  return $connectionString;
}

/**
* @param string $connectionString
* @param string $username The darabase username
* @param string $password The database password
* @return PDO
*/
function testDbConnection($connectionString,$username,$password,$count=10) {

  while($count>0){
    try {
      $dbh = new PDO($connectionString,$username,$password);
      $dbh->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION); // <== add this line
      return $dbh;
    } catch(PDOException $e ){
      $count--;
    }
  }

  throw new Exception("Could not connect ito db");
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


$connection_string=gererateDbConnectionString($dbtype,$dbhost,$dbport,$dbname);

try {
  $pdo=testDbConnection($connectionString,$dbuser,$dbpass);
  if($dbtype==='mysqli' || $dbtype==='mariadb') {
    echo detectMysqlOrMariaDb($pdo);
  } else {
    echo 'postgresql'
  }
  exit(0);
} catch(Exception $e) {
  exit(1);
}
