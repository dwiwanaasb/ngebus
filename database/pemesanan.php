<?php
$conn = mysqli_connect('localhost', 'root', '', 'db_ngebus');

$nama_penumpang = $_POST["nama_penumpang"];
$no_telepon = $_POST["no_telepon"];
$armada = $_POST["armada"];
$rute = $_POST["rute"];
$tanggal = $_POST["tanggal"];
$waktu = $_POST["waktu"];
$tarif = $_POST["tarif"];
$nominal_pembayaran = $_POST["nominal_pembayaran"];
$jumlah_kembalian = $_POST["jumlah_kembalian"];

$query = mysqli_query($conn, "INSERT INTO orders VALUES('','$nama_penumpang','$no_telepon','$armada','$rute','$tanggal','$waktu','$tarif','$nominal_pembayaran','$jumlah_kembalian')");
if ($query) {
    echo json_encode("Success");
}
