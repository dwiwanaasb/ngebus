<?php
$conn = mysqli_connect('localhost', 'root', '', 'db_ngebus');

$nama_lengkap = $_POST["nama_lengkap"];
$no_telepon = $_POST["no_telepon"];
$username = $_POST["username"];
$password = $_POST["password"];

$result = mysqli_query($conn, "SELECT * FROM users WHERE username = '$username' AND password = '$password'");
$result2 = mysqli_query($conn, "SELECT username FROM users WHERE username = '$username'");
$count = mysqli_num_rows($result);
$password_ = password_hash($password, PASSWORD_DEFAULT);

if (mysqli_fetch_assoc($result2)) {
    echo json_encode("Already");
} else {
    if ($count == 1) {
        echo json_encode("Error");
    } else {
        $query = mysqli_query($conn, "INSERT INTO users VALUES('','$nama_lengkap','$no_telepon','$username','$password_')");
        if ($query) {
            echo json_encode("Success");
        }
    }
}
