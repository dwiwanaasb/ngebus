<?php

$conn = mysqli_connect('localhost', 'root', '', 'db_ngebus');


$result = mysqli_query($conn, "SELECT * FROM orders ORDER BY id_order DESC LIMIT 1");
$temp = array();

while ($row = mysqli_fetch_assoc($result)) {
    $temp[] = $row;
}

echo json_encode($temp);
