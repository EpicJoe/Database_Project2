<?php
// 数据库连接信息
$servername = "localhost";
$username = "root";
$password = "";
$database = "project";

$conn = new mysqli($servername, $username, $password, $database);

if ($conn->connect_error) {
    die("Database connection failed: " . $conn->connect_error);
}

// 获取表单提交的数据
$pickup_location = $_POST['pickup_location'];
$vehicle_model = $_POST['vehicle_model'];
$pickupdate = $_POST['pickupdate'];
$dropoffdate = $_POST['dropoffdate'];
$return_location = $_POST['return_location'];
$coupon = $_POST['coupon'];


// 查询zc_vehicle表中与vehicle_model匹配的记录，并获取相关值
$sql = "SELECT vin, dailylimit, odometer FROM zc_vehicle WHERE model = '$vehicle_model'ORDER BY RAND() LIMIT 1";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    $vin = $row['vin'];
    $dailylimit = $row['dailylimit'];
    $startodo = $row['odometer'];
} else {
    echo "don't find the corresponding information for the model";
    exit;
}


session_start();
$customerid = $_SESSION['customerid'];

$amount = 1500;
$invoiceDate = date("Y-m-d");
$endodo = $startodo + $dailylimit * (strtotime($dropoffdate) - strtotime($pickupdate)) / 86400;


// 构建 SQL 查询来插入数据到 zc_rental 表格
$sql = "INSERT INTO zc_rental (pickupdate, dropoffdate, startodo, endodo, pickuploc, customerid, vin, dropoffloc, couponid, dailylimit) 
    VALUES ('$pickupdate', '$dropoffdate', '$startodo', '$endodo', '$pickup_location', '$customerid', '$vin', '$return_location', '$coupon', '$dailylimit')";

// 执行 SQL 查询
if ($conn->query($sql) === TRUE) {
     // Start a HTML block with centered and enlarged text
    echo '<div style="text-align: center; font-size: 20px;">';

    // Rental Bill Information
    echo "<h2>Rental Bill Information</h2>";
    echo "<p>Pickup location: $pickup_location</p>";
    echo "<p>Dropoff location: $return_location</p>";
    echo "<p>Pickup Date: $pickupdate</p>";
    echo "<p>Dropoff Date: $dropoffdate</p>";
    echo "<p>Vehicle Model: $vehicle_model</p>";
    echo "<p>Starting Odometer: $startodo</p>";
    $rentalDays = (strtotime($dropoffdate) - strtotime($pickupdate)) / 86400;
    echo "<p>Rental Days: $rentalDays days</p>";
    if ($dailylimit === null) {
        echo "<p>Daily Limit: No Limitation</p>";
        $totalLimit = "No Limitation";
    } else {
        echo "<p>Daily Limit: $dailylimit miles</p>";
        $rentalDays = (strtotime($dropoffdate) - strtotime($pickupdate)) / 86400;
        // Calculate and display the total limit, or "No Limitation" if dailylimit is null
        $totalLimit = $dailylimit * $rentalDays;
    }
    
    // Display the total limit
    echo "<p>Total Limit: $totalLimit miles</p>";

    // End the HTML block
    echo '</div>';

    // End the HTML block
    echo '</div>';
    }else {
            echo "sql Error: " . $sql. "<br>" . $conn->error;
    }
    ?>

    <div style="text-align: center;">
        <form action="payment.php" method="POST">
            <!-- ... (existing form fields) ... -->

            <!-- Add a confirmation button with CSS styles -->
            <input type="submit" name="confirm_payment" value="Confirm Payment" onclick="return confirm('Are you sure you want to confirm the payment?');" style="font-size: 24px; padding: 10px 20px;">
        </form>
    </div>

<?php

    $sql = "SELECT MAX(rentalid) as rentalid FROM zc_rental";
    $result = $conn->query($sql);
    if ($result->num_rows > 0) {
        $row = $result->fetch_assoc();
        $rentalid = $row['rentalid'];
    }
    $invoiceSql = "INSERT INTO zc_invoice (invoicedate, rentalid, amount)VALUES ('$invoiceDate', '$rentalid','$amount')";
        // 执行 SQL 查询
        if ($conn->query($invoiceSql) === TRUE) {
        } else {
            echo "Error: " . $invoiceSql . "<br>" . $conn->error;
        }

    $sql = "SELECT MAX(invoiceid) invoiceid FROM zc_invoice";
    $result = $conn->query($sql);
    if ($result->num_rows > 0) {
        $row = $result->fetch_assoc();
        $invoiceid = $row['invoiceid'];
        $_SESSION['invoiceid'] = $invoiceid;
    }

// 关闭数据库连接
$conn->close();
?>

