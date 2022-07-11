<?php
session_start();
$conn = mysqli_connect('localhost', 'root', '', 'db_ngebus');

$_SESSION["admin"] = "admin";
$username = $_POST['username'];
$password = $_POST['password'];

$result = mysqli_query($conn, "SELECT * FROM users WHERE username = '$username'");

if (mysqli_num_rows($result) > 0) {
    $row = mysqli_fetch_assoc($result);
    if (password_verify($password, $row["password"])) {
        if ($row['username'] == "admin") {
            echo json_encode("Admin");
            exit();
        } else {
            echo json_encode("User");
            exit();
        }
    }
    echo json_encode("Error");
} else {
    echo json_encode("Error");
}
