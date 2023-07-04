<?php
	$servername = "sql12.freemysqlhosting.net";
	$username = "sql12629739";
	$password = "rT7j7ckLyN";
	$dbname = "sql12629739";
	
	$conn = new mysqli($servername,$username, $password, $dbname);
	
	if($conn->connect_error){
		die("Connection failed" . $conn->connect_error);
	}
?>