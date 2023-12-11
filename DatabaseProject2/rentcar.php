<!DOCTYPE html>
<html>
<head>
    <title>WOW CAR RENTAL</title>
    <style>

        /* 样式化用户导航栏 */
        #user-navbar {
            position: absolute;
            top: 10px;
            right: 10px;
        }

        #user-navbar ul {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        #user-navbar ul li {
            display: inline;
            margin-right: 10px;
        }

        #user-navbar ul li a {
            text-decoration: none;
            padding: 5px 10px;
            background-color: #333;
            color: #fff;
            border-radius: 5px;
        }

        #user-navbar ul li a:hover {
            background-color: #555;
        }

        body {
            font-family: Arial, Helvetica, sans-serif;
            background-color: #f5f5f5;
            margin: 0;
            padding: 0;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        h1 {
            text-align: center;
            color: #333;
            font-size: 36px; /* Increase font size */
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            width: 100%;
            padding: 20px;
            background-color: #0076c0;
        }

        .header img {
            width: 100px; /* Adjust image width as needed */
            height: auto; /* Maintain aspect ratio */
        }

        form {
            background-color: #fff;
            border-radius: 5px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            padding: 20px;
            width: 400px;
            margin-top: 20px; /* Add margin to separate from header */
        }

        label {
            font-size: 16px;
            color: #333;
        }

        select,
        input[type="date"] {
            width: 100%;
            padding: 10px;
            font-size: 16px;
            margin-bottom: 20px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }

        select {
            appearance: none;
            -webkit-appearance: none;
            -moz-appearance: none;
            background-image: url("https://www.expedia.com/_dms/header/touch/hmsk-select_arrow.png");
            background-repeat: no-repeat;
            background-position: right center;
            padding-right: 30px;
        }

        input[type="submit"] {
            width: 100%;
            padding: 10px;
            font-size: 18px;
            background-color: #0076c0;
            color: #fff;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        input[type="submit"]:hover {
            background-color: #00508e;
        }
    </style>
</head>
<body>
    <header>
        <nav id="user-navbar">
            <ul>
                <!-- 其他用户选项 -->
                <li><a href="personal_info.php">Personal Infomation</a></li>
                <li><a href="rental_records.php">Rental</a></li>
            </ul>
        </nav>
    </header>


    <div class="header">
        <img src="https://www.topgear.com/sites/default/files/2023/11/1%20Mercedes%20AMG%20GT.jpg" alt="" style="width: 900px; height: 500px; margin-right: 20px;">
    <div style="position: relative; text-align: center;">
      <h1 style="font-family: 'Open Sans', Muli, Helvetica, Arial, sans-serif; color: #FFD700; z-index: 1; position: relative; transform: skewY(-10deg); display: inline-block; padding: 10px 20px; background-color: rgba(0, 0, 0, 0.5);font-size: 42px;">WOW CAR RENTAL</h1>
    <img src="/iris.jpg" alt="" style="width: 300px; height: 400px; position: absolute; top: -200px; left: 0; z-index: 0;">
</div>


        <img src="https://p9-pc-sign.douyinpic.com/tos-cn-i-0813c001/o4EkIgCeAACQSDzpAAgfCcBJENG9yIhCFAwNiA~tplv-dy-aweme-images:q75.webp?biz_tag=aweme_images&from=3213915784&s=PackSourceEnum_AWEME_DETAIL&sc=image&se=false&x-expires=1704700800&x-signature=nMzsbLoH9I%2BYN%2BewLm8%2B0EZSciY%3D" alt="" style="width: 900px; height: 550px;">
    <img src="https://www.carpro.com/hs-fs/hubfs/IMG_0222.jpg?width=1020&name=IMG_0222.jpg" alt="Left Car" style="width: 900px; height: 600px; position: absolute; bottom: 10px; left: 10px;">
    <img src="https://electro-car.by/wp-content/uploads/2023/01/li-l9-24.jpg" alt="" style="width: 1000px; height: 600px; position: absolute; bottom: 10px; right: 10px;">
    </div>

    <form action="process_rental.php" method="POST">
        <label for="pickup_location">Pickup Location:</label>
        <select name="pickup_location" id="pickup_location">
            <?php
            // 连接到数据库
            $servername = "localhost";
            $username = "root";
            $password = "";
            $database = "project";

            $conn = new mysqli($servername, $username, $password, $database);

            // 检查数据库连接是否成功
            if ($conn->connect_error) {
                die("数据库连接失败：" . $conn->connect_error);
            }

            // Create an array to store unique cities
            $uniqueCities = array();

            // Query zc_office table for officeid and city
            $sql = "SELECT officeid, city FROM zc_office";
            $result = $conn->query($sql);

            if ($result->num_rows > 0) {
                while ($row = $result->fetch_assoc()) {
                    $city = $row["city"];
                    $officeid = $row["officeid"];

                    // Check if the city is already in the array
                    if (!in_array($city, $uniqueCities)) {
                        echo "<option value='$officeid'>$city</option>";
                        // Add the city to the uniqueCities array to prevent duplicates
                        $uniqueCities[] = $city;
                    }
                }
            }
            ?>
        </select>


        <label for="vehicle_model">Vehicle Model:</label>
        <select name="vehicle_model" id="vehicle_model">
            <?php
            // Create an array to store unique vehicle models
            $uniqueModels = array();

            // Query zc_vehicle table for distinct vehicle models
            $sql = "SELECT DISTINCT model FROM zc_vehicle";
            $result = $conn->query($sql);

            if ($result->num_rows > 0) {
                while ($row = $result->fetch_assoc()) {
                    $model = $row["model"];
                    // Check if the model is already in the array
                    if (!in_array($model, $uniqueModels)) {
                        // Check if the model matches the selected value
                        $isSelected = ($model == $vehicle_model) ? "selected" : "";
                        echo "<option value='$model' $isSelected>$model</option>";
                        // Add the model to the uniqueModels array to prevent duplicates
                        $uniqueModels[] = $model;
                    }
                }
            }
            ?>
        </select>




        <label for="pickupdate">Pickup Date:</label>
        <input type="date" name="pickupdate" id="pickupdate" min="<?php echo date("Y-m-d"); ?>" max="<?php echo date("Y-m-d", strtotime("+1 year")); ?>" required>

        <label for="dropoffdate">Dropoff Date:</label>
        <input type="date" name="dropoffdate" id="dropoffdate" min="<?php echo date("Y-m-d"); ?>" required>

        <script>
        document.getElementById("pickupdate").addEventListener("change", function() {
            var pickupdate = new Date(this.value);
            var minDate = new Date(pickupdate.getTime() + 24 * 60 * 60 * 1000); // Add one day
            document.getElementById("dropoffdate").setAttribute("min", minDate.toISOString().split("T")[0]);
        });
        </script>

    
        <label for="return_location">Return Location:</label>
        <select name="return_location" id="return_location">
            <?php
            // Create an array to store unique cities
            $uniqueCities = array();

            // Query zc_office table for officeid and city
            $sql = "SELECT officeid, city FROM zc_office";
            $result = $conn->query($sql);

            if ($result->num_rows > 0) {
                while ($row = $result->fetch_assoc()) {
                    // Check if the city is already in the array
                    if (!in_array($row["city"], $uniqueCities)) {
                        echo "<option value='" . $row["officeid"] . "'>" . $row["city"] . "</option>";
                        // Add the city to the uniqueCities array to prevent duplicates
                        $uniqueCities[] = $row["city"];
                    }
                }
            }
            ?>
        </select>


        <label for="coupon">Coupon:</label>
        <select name="coupon" id="coupon">
            <?php
            // 查询zc_coupons表中的coupon id
            $sql = "SELECT couponid FROM zc_coupons";
            $result = $conn->query($sql);

            if ($result->num_rows > 0) {
                while ($row = $result->fetch_assoc()) {
                    echo "<option value='" . $row["couponid"] . "'>" . $row["couponid"] . "</option>";
                }
            }
            ?>
        </select>

        <input type="submit" value="Submit">
    </form>
</body>
</html>
