<?php
$host = 'localhost';
$dbUsername = 'root';
$password = '';
$database = 'project';

$conn = new mysqli($host, $dbUsername, $password, $database);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// 查询最大 invoiceid 行的 amount 值
$sql = "SELECT amount FROM zc_invoice WHERE invoiceid = (SELECT MAX(invoiceid) FROM zc_invoice)";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    $amount = $row['amount'];
} else {
    $amount = 0; // 如果没有记录，设置默认值为 0 或其他您认为合适的值
}

$conn->close();
?>

<!DOCTYPE html>
<html>
<head>
    <title>Payment information</title>
    <style>
        /* Center-align and enlarge input fields */
        body {
            text-align: center;
        }

        form {
            display: inline-block;
            text-align: left;
        }

        label {
            font-size: 18px;
            display: block;
        }

        input[type="text"],
        select {
            width: 100%;
            padding: 10px;
            font-size: 18px;
            margin-bottom: 20px;
        }

        input[type="submit"] {
            font-size: 24px;
            padding: 10px 20px;
        }
    </style>
</head>
<body>
    <h1>Price: <?php echo $amount; ?></h1>
    <h1>Please Enter Your Payment Information</h1>
    <form method="POST" action="process_payment.php">
        <label for="firstName">First Name:</label>
        <input type="text" id="firstName" name="firstName" required><br><br>

        <label for="lastName">Last Name:</label>
        <input type="text" id="lastName" name="lastName" required><br><br>

        <label for="paymentMethod">Payment Method:</label>
        <select id="paymentMethod" name="paymentMethod" required>
            <option value="credit">Credit</option>
            <option value="debit">Debit</option>
            <option value="giftcard">Gift Card</option>
        </select><br><br>

        <label for="cardNumber">Card Number:</label>
        <input type="text" id="cardNumber" name="cardNumber" required><br><br>

        <label for="expirationMonth">Expiration Month:</label>
        <select id="expirationMonth" name="expirationMonth" required>
            <option value="01">01</option>
            <?php
            for ($i = 2; $i <= 12; $i++) {
                $month = str_pad($i, 2, '0', STR_PAD_LEFT);
                echo "<option value='$month'>$month</option>";
            }
            ?>
        </select><br><br>

        <label for="expirationYear">Expiration Year:</label>
        <select id="expirationYear" name="expirationYear" required>
            <option value="2023">2023</option>
            <?php
            $currentYear = date("Y");
            for ($i = $currentYear; $i <= $currentYear + 10; $i++) {
                echo "<option value='$i'>$i</option>";
            }
            ?>
        </select><br><br>

        <label for="cvv">CVV:</label>
        <input type="text" id="cvv" name="cvv" required><br><br>

        <input type="submit" value="Submit Payment">
    </form>
</body>
</html>
