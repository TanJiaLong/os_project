<?php
if(!isset($_POST)){
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}
include_once('dbconnect.php');

if(isset($_POST['user_id'])){
    $userId = $_POST['user_id'];
    $sqlloadlocation = "SELECT * FROM `user_details` WHERE user_id = '$userId' ORDER BY user_time DESC";
}else{
    $sqlloadlocation = "SELECT * FROM `user_details` ORDER BY user_time DESC";
}

$result = $conn->query($sqlloadlocation);
if($result->num_rows > 0){
    $locationList['locations'] = array();
    while($row = $result->fetch_assoc()){
        $location['location_id'] = $row['location_id'];
        $location['user_id'] = $row['user_id'];
        $location['latitude'] = $row['user_lat'];
        $location['longitude'] = $row['user_long'];
        $location['state'] = $row['user_state'];
        $location['locality'] = $row['user_locality'];
        $location['check_in_date'] = $row['user_time'];
        array_push($locationList['locations'], $location);
    }
    $response = array('status' => 'success', 'data' => $locationList);
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray){
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>