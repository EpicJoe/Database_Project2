<!DOCTYPE html>
<html>
<head>
    <title>个人信息</title>
    <style>
        /* 样式化表格 */
        table {
            border-collapse: collapse;
            width: 100%;
            font-size: 18px;
        }

        th, td {
            border: 1px solid #ddd;
            text-align: left;
            padding: 8px;
        }

        th {
            background-color: #f2f2f2;
        }

        tr:nth-child(even) {
            background-color: #f2f2f2;
        }

        /* 按钮样式 */
        .btn {
            font-size: 16px;
            padding: 5px 10px;
            text-decoration: none;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 5px;
        }

        .btn-edit {
            background-color: #008CBA;
        }

        /* 表单样式 */
        .edit-form {
            display: none;
        }

        /* 输入字段样式 */
        input[type="text"], input[type="email"], input[type="tel"] {
            width: 100%;
            padding: 10px;
            font-size: 18px;
            margin-bottom: 20px;
        }

    </style>
</head>
<body>
    <?php
    // 连接到数据库
    $servername = "localhost";
    $username = "root";
    $password = "";
    $database = "project";

    $conn = new mysqli($servername, $username, $password, $database);

    if ($conn->connect_error) {
        die("数据库连接失败：" . $conn->connect_error);
    }

    session_start();
    $customerid = $_SESSION['customerid'];

    // 查询客户的个人信息
    $sql = "SELECT * FROM zc_customer WHERE customerid = '$customerid'";
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        echo "<h2>Personal Information</h2>";
        echo "<table border='1'>";
        echo "<tr><th>Customer ID</th><th>Street</th><th>City</th><th>State</th><th>Zipcode</th><th>Email</th><th>Phone</th><th>Actions</th></tr>";
        while ($row = $result->fetch_assoc()) {
            echo "<tr>";
            echo "<td>" . $row["customerid"] . "</td>";
            echo "<td>" . $row["street"] . "</td>";
            echo "<td>" . $row["city"] . "</td>";
            echo "<td>" . $row["state"] . "</td>";
            echo "<td>" . $row["zipcode"] . "</td>";
            echo "<td>" . $row["email"] . "</td>";
            echo "<td>" . $row["phonenum"] . "</td>";
            echo "<td><a class='btn btn-edit' href='javascript:void(0)' onclick='editCustomerInfo()'>Modify</a></td>"; // 编辑按钮
            echo "</tr>";
        }
        echo "</table>";
        // 添加编辑表单
        echo "<div class='edit-form'>";
        echo "<h2>编辑个人信息</h2>";
        echo "<form method='POST' action='update_customer_info.php'>";
        echo "<input type='hidden' name='customer_id' value='$customerid'>";
        echo "<label for='street'>Street:</label>";
        echo "<input type='text' id='street' name='street' required><br>";
        echo "<label for='city'>City:</label>";
        echo "<input type='text' id='city' name='city' required><br>";
        echo "<label for='state'>State:</label>";
        echo "<input type='text' id='state' name='state' required><br>";
        echo "<label for='zipcode'>Zipcode:</label>";
        echo "<input type='text' id='zipcode' name='zipcode' required><br>";
        echo "<label for='email'>Email:</label>";
        echo "<input type='email' id='email' name='email' required><br>";
        echo "<label for='phonenum'>Phone:</label>";
        echo "<input type='tel' id='phonenum' name='phonenum' required><br>";
        echo "<input type='submit' class='btn' value='提交'>";
        echo "</form>";
        echo "</div>";
    } else {
        echo "没有找到客户信息。";
    }

    $conn->close();
    ?>

    <script>
        function editCustomerInfo() {
            // 显示编辑表单
            var editForm = document.querySelector('.edit-form');
            editForm.style.display = 'block';

            // 隐藏编辑按钮
            var editButton = document.querySelector('.btn-edit');
            editButton.style.display = 'none';
        }
    </script>
</body>
</html>
