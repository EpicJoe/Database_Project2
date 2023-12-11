<!DOCTYPE html>
<html>
<head>
    <title>Rental Records</title>
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

        /* 定义每个记录的方框 */
        .record-box {
            border: 1px solid #ddd;
            padding: 10px;
            margin-bottom: 10px;
        }

        h2 {
            font-size: 24px;
        }

        /* 放大invoicedate */
        .invoicedate {
            font-size: 24px;
        }

        /* 其他样式化 */
        body {
            font-family: Arial, sans-serif;
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

      
    $sql = "SELECT r.*, r.pickuploc AS pickupcity, r.dropoffloc AS dropoffcity, COALESCE(i.invoicedate, 'N/A') AS invoicedate, i.amount AS price
        FROM zc_rental r
        LEFT JOIN zc_invoice i ON r.rentalid = i.rentalid
        WHERE r.customerid = '$customerid'";

    

    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        while ($row = $result->fetch_assoc()) {
            echo "<div class='record-box'>";
            
            // 查询对应的发票日期
            $invoiceDate = $row["invoicedate"];
            if (!empty($invoiceDate)) {
                echo "<p class='invoicedate'>$invoiceDate</p>";
            }
            
            echo "<table>";
            echo "<tr><th>Pickup Date</th><td>" . $row["pickupdate"] . "</td></tr>";
            echo "<tr><th>Dropoff Date</th><td>" . $row["dropoffdate"] . "</td></tr>";
            echo "<tr><th>Start Odometer</th><td>" . $row["startodo"] . "</td></tr>";
            echo "<tr><th>End Odometer</th><td>" . $row["endodo"] . "</td></tr>";
            echo "<tr><th>Pickup Location</th><td>" . $row["pickupcity"] . "</td></tr>";
            echo "<tr><th>Vehicle ID</th><td>" . $row["vin"] . "</td></tr>";
            echo "<tr><th>Return Location</th><td>" . $row["dropoffcity"] . "</td></tr>";

            $price = $row["price"];
            echo "<tr><th>Price</th><td>";
            if (!empty($price)) {
                echo "$price";
            } else {
                echo "N/A";
            }
            echo "</td></tr>";

            echo "</table>";
            echo "</div>";
        }
    } else {
        echo "<p>没有租车记录。</p>";
    }
    $conn->close();
    ?>
</body>
</html>
