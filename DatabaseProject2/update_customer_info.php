<?php
// Connect to the database
$servername = "localhost";
$username = "root";
$password = "";
$database = "project";

$conn = new mysqli($servername, $username, $password, $database);

if ($conn->connect_error) {
    die("Database connection failed: " . $conn->connect_error);
}

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Get the form submitted data
    session_start();
    $customerid = $_SESSION['customerid'];
    $street = $_POST["street"];
    $city = $_POST["city"];
    $state = $_POST["state"];
    $zipcode = $_POST["zipcode"];
    $email = $_POST["email"];
    $phonenum = $_POST["phonenum"];

    // Build SQL query to update customer information
    $sql = "UPDATE zc_customer SET street = '$street', city = '$city', state = '$state', zipcode = '$zipcode', email = '$email', phonenum = '$phonenum' WHERE customerid = '$customerid'";
    if ($conn->query($sql) === TRUE) {
        // Commit the transaction after a successful update
        $conn->commit();
        echo "Update successful";
        
        // After successful update, redirect to personal_info.php
        header("Location: personal_info.php");
        exit;
    } else {
        // Rollback the transaction in case of an error
        $conn->rollback();
        echo "Update failed: " . $conn->error;
    }
} else {
    echo "No customer records found.";
}

// Close the database connection
$conn->close();
?>
