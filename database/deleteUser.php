<?php

$conn = mysqli_connect('localhost', 'root', '', 'db_ngebus');

$id_user = $_POST["id_user"];

$result = mysqli_query($conn, "DELETE FROM users WHERE id_user = '$id_user'");
$result2 = mysqli_query($conn, "SELECT * FROM users ORDER BY id_user");

$no = 1;

while ($data = mysqli_fetch_assoc($result2)) {
    $id_user = $data['id_user'];
    mysqli_query($conn, "UPDATE users SET id_user = $no WHERE id_user = '$id_user'");

    $no++;
}

mysqli_query($conn, "ALTER TABLE users AUTO_INCREMENT = '$no'");
