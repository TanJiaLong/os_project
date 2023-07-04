<?php
if(!isset($_POST)){
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}
include_once('dbconnect.php');

if(isset($_POST['locationId'])){
    $locationId = $_POST['locationId'];
    $sqlDeletelocation = "DELETE FROM `user_details` WHERE location_id = '$locationId'";
}

if( $conn->query($sqlDeletelocation)){
    $response = array('status' => 'success', 'data' => null);
    sendJsonResponse($response);
}else{
    $response = array('status' => 'failed', 'data' => null);
	sendJsonResponse($response);
}


function sendJsonResponse($sentArray){
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>