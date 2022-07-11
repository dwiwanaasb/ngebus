<?php
$conn = mysqli_connect('localhost', 'root', '', 'db_ngebus');

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

mysqli_query($conn, "INSERT INTO tiket VALUES('','$armada','$keberangkatan','$tujuan','$tanggal','$waktu','$stok','$tarif','$gambar')");
