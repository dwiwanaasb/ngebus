<?php
$conn = mysqli_connect('localhost', 'root', '', 'db_ngebus');

$id_user = $_POST["id_user"];
$nama_lengkap = $_POST["nama_lengkap"];
$no_telepon = $_POST["no_telepon"];
$username = $_POST["username"];
$password = $_POST["password"];

$password_ = password_hash($password, PASSWORD_DEFAULT);
$result = mysqli_query($conn, "UPDATE users SET nama_lengkap = '$nama_lengkap', no_telepon = '$no_telepon', username = '$username', password = '$password_' WHERE id_user = '$id_user'");
$count = mysqli_num_rows($result);

if ($count == 1) {
    echo json_encode("Error");
} else {
    if ($result) {
        echo json_encode("Success");
    }
}
