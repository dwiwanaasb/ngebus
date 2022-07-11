<?php

$conn = mysqli_connect('localhost', 'root', '', 'db_ngebus');

$id_order = $_POST["id_order"];

$result = mysqli_query($conn, "DELETE FROM orders WHERE id_order = '$id_order'");
$result2 = mysqli_query($conn, "SELECT * FROM orders ORDER BY id_order");

$no = 1;

while ($data = mysqli_fetch_assoc($result2)) {
    $id_order = $data['id_order'];
    mysqli_query($conn, "UPDATE orders SET id_order = $no WHERE id_order = '$id_order'");

    $no++;
}

mysqli_query($conn, "ALTER TABLE orders AUTO_INCREMENT = '$no'");
