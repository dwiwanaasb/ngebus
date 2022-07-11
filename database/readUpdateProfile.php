<?php

$conn = mysqli_connect('localhost', 'root', '', 'db_ngebus');

$username = $_POST["username"];

$result = mysqli_query($conn, "SELECT * FROM users WHERE username = '$username'");
$temp = array();

while ($row = mysqli_fetch_assoc($result)) {
    $temp[] = $row;
}

echo json_encode($temp);
