<?php
session_start();

// 数据库连接信息
$servername = "localhost";
$username = "root";
$password = "";
$database = "project";

// 连接到MySQL数据库
$conn = new mysqli($servername, $username, $password, $database);

// 检查连接是否成功
if ($conn->connect_error) {
    die("连接数据库失败: " . $conn->connect_error);
}

// 获取表单提交的数据
$firstName = $_POST['firstName'];
$lastName = $_POST['lastName'];
$paymentMethod = $_POST['paymentMethod'];
$cardNumber = $_POST['cardNumber'];
$expirationMonth = $_POST['expirationMonth'];
$expirationYear = $_POST['expirationYear'];
$cvv = $_POST['cvv'];

$expirationYear = $expirationYear . '-' . $expirationMonth;
$currentDate = date("Y-m-d");

//test
$invoiceID = $_SESSION['invoiceid'];
$paymentid = 111;
// 准备插入数据的SQL语句
$sql = "INSERT INTO zc_payment (method, DATE, cardnum, cvv, expdate, paymentfname, paymentlname, invoiceid) VALUES ('$paymentMethod', '$currentDate', '$cardNumber', '$cvv', '$expirationYear', '$firstName', '$lastName', '$invoiceID')";

// 执行SQL语句
if ($conn->query($sql) === TRUE) {
    echo "submit successfully";
    header("Location: rentcar.php");
    exit(); // 确保在跳转后停止执行当前脚本
} else {
    echo "error: " . $sql . "<br>" . $conn->error;
}

// 关闭数据库连接
$conn->close();
?>
