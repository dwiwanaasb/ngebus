<?php
$conn = mysqli_connect('localhost', 'root', '', 'db_ngebus');

$id_tiket = $_POST["id_tiket"];
$stok = $_POST["stok"];

mysqli_query($conn, "UPDATE tiket SET stok = '$stok' WHERE id_tiket = '$id_tiket'");
