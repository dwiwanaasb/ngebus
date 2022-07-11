<?php

$conn = mysqli_connect('localhost', 'root', '', 'db_ngebus');

$id_tiket = $_POST["id_tiket"];

$result = mysqli_query($conn, "SELECT stok FROM tiket WHERE id_tiket = '$id_tiket'");
$temp = array();

while ($row = mysqli_fetch_assoc($result)) {
    $temp[] = $row;
}

echo json_encode($temp);
