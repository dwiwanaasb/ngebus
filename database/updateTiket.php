<?php
$conn = mysqli_connect('localhost', 'root', '', 'db_ngebus');

$id_tiket = $_POST["id_tiket"];
$armada = $_POST["armada"];
$keberangkatan = $_POST["keberangkatan"];
$tujuan = $_POST["tujuan"];
$tanggal = $_POST["tanggal"];
$waktu = $_POST["waktu"];
$stok = $_POST["stok"];
$tarif = $_POST["tarif"];
$gambar = $_FILES["gambar"]["name"];

$imagePath = 'uploads/' . $gambar;
$tmp_name = $_FILES["gambar"]["tmp_name"];

move_uploaded_file($tmp_name, $imagePath);

mysqli_query($conn, "UPDATE tiket SET armada = '$armada', keberangkatan = '$keberangkatan', tujuan = '$tujuan', tanggal = '$tanggal', waktu = '$waktu', stok = '$stok', tarif = '$tarif', gambar = '$gambar' WHERE id_tiket = '$id_tiket'");
