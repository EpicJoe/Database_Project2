<?php
$host = 'localhost';
$dbUsername = 'root';
$password = '';
$database = 'project';

$conn = new mysqli($host, $dbUsername, $password, $database);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $username = $_POST["username"];
    $password = $_POST["password"];

    // 准备和绑定
    $stmt = $conn->prepare("SELECT password FROM users WHERE username = ?");
    $stmt->bind_param("s", $username);
    $stmt->execute();
    $result = $stmt->get_result();
    $user = $result->fetch_assoc();

    // 验证密码
    if ($user && password_verify($password, $user['password'])) {
        // 密码正确，用户验证成功
        // 进行登录后的操作，如创建会话等
        header('Location: main.html'); // 使用header重定向到主页
        exit();
    } else {
        // 密码错误或用户不存在, 防xss攻击
        $errorMessage = htmlspecialchars("Username or password is incorrect.", ENT_QUOTES, 'UTF-8');
        echo "<script type='text/javascript'>alert('$errorMessage');location='login.html';</script>";
    }

    $stmt->close();
}

$conn->close();
?>
