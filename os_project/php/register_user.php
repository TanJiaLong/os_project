<?php
	//check whether the data is posted or not
	if(!isset($_POST)){
		$response = array(
			'status' => 'failed', 
			'data' => null);
		sendJsonResponse($response);
		die();
	}
	
	//connect database
	include_once('dbconnect.php');
	
	$name = $_POST['name'];
	$email = $_POST['email'];
	$phone = $_POST['phone'];
	$password = $_POST['password'];
	$userRegDate = $_POST['userRegDate'];

	$sql_insert = "INSERT INTO `tbl_users`(`user_email`,
										   `user_name`,
										   `user_phone`,
										   `user_password`,
										   `user_regDate`)
				  VALUES ('$email',
						 '$name',
						 '$phone',
						 '$password',
						 '$userRegDate')";
	
	if($conn->query($sql_insert) === true){
		$response = array('status' => 'success',
						  'data' => null);
		sendJsonResponse($response);
	}
	else{
		$response = array('status' => 'failed',
						  'data' => null);
		sendJsonResponse($response);
	}
	
	function sendJsonResponse($sentArray){
		header('Content-Type:application/json');
		echo json_encode($sentArray);
	}
?>
