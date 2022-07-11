<?php

$conn = mysqli_connect('localhost', 'root', '', 'db_ngebus');

$id_tiket = $_POST["id_tiket"];

$result = mysqli_query($conn, "DELETE FROM tiket WHERE id_tiket = '$id_tiket'");
$result2 = mysqli_query($conn, "SELECT * FROM tiket ORDER BY id_tiket");

$no = 1;

while ($data = mysqli_fetch_assoc($result2)) {
    $id_tiket = $data['id_tiket'];
    mysqli_query($conn, "UPDATE tiket SET id_tiket = $no WHERE id_tiket = '$id_tiket'");

    $no++;
}

mysqli_query($conn, "ALTER TABLE tiket AUTO_INCREMENT = '$no'");
