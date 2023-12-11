<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
$host = 'localhost';
$dbUsername = 'root';
$password = '';
$database = 'project';

// 创建与数据库的连接
$conn = new mysqli($host, $dbUsername, $password, $database);

// 检查连接
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // 获取表单提交的数据
    $username = htmlspecialchars($_POST["username"], ENT_QUOTES, 'UTF-8');
    $password = $_POST["password"];
    $confirmPassword = $_POST["confirm_password"];

    // 检查两次输入的密码是否一致
    if ($password !== $confirmPassword) {
        echo "<script>alert('Passwords do not match.');window.location.href='register.html';</script>";
        exit();
    }

    // 检查用户名是否已存在
    $stmt = $conn->prepare("SELECT id FROM users WHERE username = ?");
    $stmt->bind_param("s", $username);
    $stmt->execute();
    $stmt->store_result();

    if ($stmt->num_rows > 0) {
        // 用户名已存在, 防xss攻击 using htmlspecialchars
        $username = htmlspecialchars($username, ENT_QUOTES, 'UTF-8');
        echo "<script>alert('Username $username already exists.');window.location.href='register.html';</script>";
    } else {
        $stmt->close();
        // 根据用户类型设置type字段

        $street = $_POST["street"];
        $city = $_POST["city"];
        $state = $_POST["state"];
        $zipcode = $_POST["zipcode"];
        $email = $_POST["email"];
        $phonenum = $_POST["phonenum"];


        $customerType = $_POST["customer_type"];
        $type = ($customerType == 'Individual') ? 'I' : 'C';

        //email check
        if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
            echo "<script>alert('Invalid email format');window.location.href='register.html';</script>";
            exit();
        }
        
        // 插入新用户数据到 zc_customer
        $insertCustomer = $conn->prepare("INSERT INTO zc_customer (street, city, state, zipcode, email, phonenum, type) VALUES (?, ?, ?, ?, ?, ?, ?)");
        $insertCustomer->bind_param("sssssss", $street, $city, $state, $zipcode, $email, $phonenum, $customerType);
        $insertCustomer->execute();
        $customerId = $conn->insert_id; // 获取刚插入的 customerid

        // 用户名可用，加密密码
        $hashedPassword = password_hash($password, PASSWORD_DEFAULT);
        $insertUser = $conn->prepare("INSERT INTO users (username, password, customerid) VALUES (?, ?, ?)");
        $insertUser->bind_param("ssi", $username, $hashedPassword, $customerId);
        $insertUser->execute();
        $insertUser->close();



        if ($customerType == 'I') {
            // 对于个人客户，插入数据到 zc_individual
            $fname = $_POST["individual_fname"];
            $lname = $_POST["individual_lname"];
            $dlnum = $_POST["individual_dlnum"];
            $insurance = $_POST["individual_insurance"];
            $policynum = $_POST["individual_policynum"];

            $insertIndividual = $conn->prepare("INSERT INTO zc_individual (customerid, fname, lname, dlnum, insurance, policynum) VALUES (?, ?, ?, ?, ?, ?)");
            $insertIndividual->bind_param("isssss", $customerId, $fname, $lname, $dlnum, $insurance, $policynum);
            $insertIndividual->execute();
            $insertIndividual->close();
        } elseif ($customerType == 'C') {
            // 对于公司客户，插入数据到 zc_corpcust
            $corpName = $_POST["corporation_name"];
            $regnum = $_POST["corporation_regnum"];

            $insertCorpcust = $conn->prepare("INSERT INTO zc_corporation (corpname, regnum) VALUES (?, ?)");
            $insertCorpcust->bind_param("ss", $corpName, $regnum);
            $insertCorpcust->execute();
            $insertCorpcust->close();
        }

        if ($insertCustomer->affected_rows > 0) {
            // 注册成功
            $insertCustomer->close(); // 现在关闭语句
            echo "<script>alert('Registration successful.');window.location.href='login.html';</script>";
        } else {
            // 注册失败
            $insertCustomer->close(); // 现在关闭语句
            echo "<script>alert('Registration failed.');window.location.href='register.html';</script>";
        }

        $insertCustomer->close();
    }
}

$conn->close();
?>
