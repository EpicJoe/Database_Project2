-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 11, 2023 at 09:16 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `project`
--

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `customerid` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `created_at`, `customerid`) VALUES
(3, 'zc2958', '$2y$10$EG7yntQEaRWEYfGeat.Mhe5S0Kre/khZC/ZUcFByuPH5IoSIJU9fa', '2023-12-09 20:25:32', 36),
(4, 'gh123', '$2y$10$hNW3F1bR5ZM2kqdAnXE.V.9yM1z9U6Qtgfb8hhlEJMXA7N7ql8qtq', '2023-12-10 19:32:09', 37);

-- --------------------------------------------------------

--
-- Table structure for table `zc_corpcust`
--

CREATE TABLE `zc_corpcust` (
  `customerid` int(11) NOT NULL COMMENT 'THE ID OF A CUSTOMER',
  `empid` int(11) NOT NULL COMMENT 'EMPLOYEE ID OF CORPRATION',
  `corpid` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Triggers `zc_corpcust`
--
DELIMITER $$
CREATE TRIGGER `arc_fkarc_1_zc_corpcust` BEFORE INSERT ON `zc_corpcust` FOR EACH ROW BEGIN
    DECLARE d CHAR(1);

    SELECT
        a.type
    INTO d
    FROM
        zc_customer a
    WHERE
        a.customerid = NEW.customerid;

    IF (d IS NULL OR d <> 'C') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'FK ZC_CORPCUST_ZC_CUSTOMER_FK in Table ZC_CORPCUST violates Arc constraint on Table ZC_CUSTOMER - discriminator column TYPE doesn''t have value ''C''';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `zc_corporation`
--

CREATE TABLE `zc_corporation` (
  `corpname` varchar(20) NOT NULL COMMENT 'COPORATION NAME',
  `regnum` varchar(10) NOT NULL COMMENT 'CORPORATION REGISTRATION NUMBER ',
  `corpid` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `zc_coupons`
--

CREATE TABLE `zc_coupons` (
  `couponid` int(11) NOT NULL COMMENT 'THE ID OF A COUPON',
  `discount` tinyint(4) NOT NULL COMMENT 'THE DISCOUNT OF PRODUCT',
  `startdate` datetime NOT NULL COMMENT 'THE START DATE OF COUPON',
  `enddate` datetime NOT NULL COMMENT 'THE END DATE OF COUPON'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `zc_coupons`
--

INSERT INTO `zc_coupons` (`couponid`, `discount`, `startdate`, `enddate`) VALUES
(36, 50, '2023-08-01 00:00:00', '2023-05-31 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `zc_customer`
--

CREATE TABLE `zc_customer` (
  `customerid` int(11) NOT NULL COMMENT 'THE ID OF A CUSTOMER',
  `street` varchar(20) NOT NULL COMMENT 'STREET ADDRESS',
  `city` varchar(20) NOT NULL COMMENT 'CITY OF ADDRESS',
  `state` varchar(2) NOT NULL COMMENT 'STATE OF ADDRESS LIKE NY',
  `zipcode` varchar(5) NOT NULL,
  `email` varchar(30) NOT NULL COMMENT 'THE EMAIL OF A CUSTOMER',
  `phonenum` varchar(10) NOT NULL COMMENT 'PHONE NUMBER OF A CUSTOMER',
  `type` varchar(1) NOT NULL COMMENT 'I FOR INDIVIDUAL, C FOR CORPORATION CUSTOMER'
) ;

--
-- Dumping data for table `zc_customer`
--

INSERT INTO `zc_customer` (`customerid`, `street`, `city`, `state`, `zipcode`, `email`, `phonenum`, `type`) VALUES
(36, '17 mcq', 'new york', 'NY', '12301', 'zc2957@nyu.edu', '3477683265', 'I'),
(37, '23 mic', 'brooklyn', 'NY', '11201', 'gh123@nyu.edu', '3477683260', 'I');

-- --------------------------------------------------------

--
-- Table structure for table `zc_customer_coupon`
--

CREATE TABLE `zc_customer_coupon` (
  `coupontype` varchar(1) NOT NULL COMMENT 'TYPE OF COUPON',
  `couponid` int(11) NOT NULL,
  `customerid` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `zc_customer_coupon`
--

INSERT INTO `zc_customer_coupon` (`coupontype`, `couponid`, `customerid`) VALUES
('I', 36, 36);

-- --------------------------------------------------------

--
-- Table structure for table `zc_individual`
--

CREATE TABLE `zc_individual` (
  `customerid` int(11) NOT NULL COMMENT 'THE ID OF A CUSTOMER',
  `fname` varchar(20) NOT NULL COMMENT 'FIRST NAME OF INDIVIDUAL',
  `lname` varchar(20) NOT NULL COMMENT 'LAST NAME OF INDIVIDUAL',
  `dlnum` varchar(9) NOT NULL COMMENT 'DRIVER LICENSE OF INDIVIDUAL',
  `insurance` varchar(20) NOT NULL COMMENT 'INSURANCE COMPANY NAME',
  `policynum` varchar(11) NOT NULL COMMENT 'INSURANCE POLICY NUMBER'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `zc_individual`
--

INSERT INTO `zc_individual` (`customerid`, `fname`, `lname`, `dlnum`, `insurance`, `policynum`) VALUES
(37, 'George', 'He', '414141414', 'zc ', 'zc123134');

--
-- Triggers `zc_individual`
--
DELIMITER $$
CREATE TRIGGER `arc_fkarc_1_zc_individual` BEFORE INSERT ON `zc_individual` FOR EACH ROW BEGIN
    DECLARE d CHAR(1);

    SELECT
        a.type
    INTO d
    FROM
        zc_customer a
    WHERE
        a.customerid = NEW.customerid;

    IF (d IS NULL OR d <> 'I') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'FK ZC_INDIVIDUAL_ZC_CUSTOMER_FK in Table ZC_INDIVIDUAL violates Arc constraint on Table ZC_CUSTOMER - discriminator column TYPE doesn''t have value ''I''';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `zc_invoice`
--

CREATE TABLE `zc_invoice` (
  `invoiceid` int(11) NOT NULL,
  `invoicedate` datetime NOT NULL,
  `rentalid` int(11) NOT NULL,
  `amount` decimal(7,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `zc_invoice`
--

INSERT INTO `zc_invoice` (`invoiceid`, `invoicedate`, `rentalid`, `amount`) VALUES
(1, '2023-12-10 00:00:00', 1, 275.00),
(2, '2023-12-10 00:00:00', 2, 180.00),
(3, '2023-12-10 00:00:00', 3, 180.00),
(4, '2023-12-10 00:00:00', 4, 840.00),
(5, '2023-12-10 00:00:00', 5, 540.00),
(6, '2023-12-10 00:00:00', 6, 540.00),
(7, '2023-12-10 00:00:00', 7, 245.00),
(8, '2023-12-10 00:00:00', 8, 245.00),
(9, '2023-12-10 00:00:00', 9, 210.00);

--
-- Triggers `zc_invoice`
--
DELIMITER $$
CREATE TRIGGER `calculate_invoice_amount_on_insert` BEFORE INSERT ON `zc_invoice` FOR EACH ROW BEGIN
    SET @v_rental_duration := 0;
    SET @v_used_mileage := 0;
    SET @v_daily_rate := 0;
    SET @v_over_mileage_fee := 0;
    SET @v_total_amount := 0;
    SET @v_discount := 0;
    SET @v_dailylimit := 0;
    SET @v_typeid := '';
    SET @v_couponid := 0;

    SELECT r.dailylimit, v.typeid, r.couponid
    INTO @v_dailylimit, @v_typeid, @v_couponid
    FROM zc_rental r
    INNER JOIN zc_vehicle v ON v.vin = r.vin
    WHERE r.rentalid = NEW.rentalid;

    SELECT DATEDIFF(dropoffdate, pickupdate), (endodo - startodo)
    INTO @v_rental_duration, @v_used_mileage
    FROM zc_rental
    WHERE rentalid = NEW.rentalid;

    SELECT rentalcharge, extracharge
    INTO @v_daily_rate, @v_over_mileage_fee
    FROM zc_vehicleclass
    WHERE typeid = @v_typeid;

    SELECT COALESCE(discount, 0) INTO @v_discount FROM zc_coupons WHERE couponid = @v_couponid;

    IF @v_used_mileage > (@v_dailylimit * @v_rental_duration) THEN
        SET @v_total_amount := (@v_daily_rate * @v_rental_duration) +   
                            ((@v_used_mileage - (@v_dailylimit * @v_rental_duration)) * @v_over_mileage_fee);
    ELSE
        SET @v_total_amount := @v_daily_rate * @v_rental_duration;
    END IF;

    SET NEW.amount := @v_total_amount;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `generate_invoiceid` BEFORE INSERT ON `zc_invoice` FOR EACH ROW BEGIN
  DECLARE max_invoiceid INT;
  SET max_invoiceid = (SELECT MAX(invoiceid) FROM zc_invoice);
  IF max_invoiceid IS NULL THEN
    SET NEW.invoiceid = 1;
  ELSE
    SET NEW.invoiceid = max_invoiceid + 1;
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `zc_office`
--

CREATE TABLE `zc_office` (
  `officeid` int(11) NOT NULL COMMENT 'THE ID OF OFFICE',
  `street` varchar(20) NOT NULL,
  `city` varchar(20) NOT NULL,
  `state` varchar(2) NOT NULL,
  `zipcode` varchar(5) NOT NULL,
  `officenum` varchar(10) NOT NULL COMMENT 'THE NUMBER OF OFFICE'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `zc_office`
--

INSERT INTO `zc_office` (`officeid`, `street`, `city`, `state`, `zipcode`, `officenum`) VALUES
(33, '400 Pine St', 'Seattle', 'WA', '98101', 'Office202'),
(34, 'Some Address', 'Some City', 'SC', '98102', 'Office103'),
(35, '293 Maple Ave', 'Seattle', 'WA', '98104', 'Office202'),
(36, '149 Oak St', 'New York', 'NY', '92342', 'Office103'),
(37, '4112 W 37th St', 'Los Angeles', 'CA', '90001', 'Office104'),
(38, '230 Pine Ave', 'Chicago', 'IL', '60007', 'Office108'),
(39, '489 Nick St', 'Boston', 'MA', '02835', 'Office109');

-- --------------------------------------------------------

--
-- Table structure for table `zc_payment`
--

CREATE TABLE `zc_payment` (
  `paymentid` int(11) NOT NULL,
  `method` varchar(10) NOT NULL COMMENT 'CREDIT,DEBIT,GIFTCARD',
  `DATE` datetime NOT NULL COMMENT 'THE DATE OF PAYMENT',
  `cardnum` varchar(16) NOT NULL COMMENT 'THE NUMBER OF A CARD',
  `cvv` varchar(4) NOT NULL COMMENT 'cvv of the card',
  `expdate` datetime NOT NULL COMMENT 'THE EXPIRATION DATE OF THE CARD',
  `paymentfname` varchar(20) NOT NULL COMMENT 'PAYMENT FIRST NAME ',
  `paymentlname` varchar(20) NOT NULL COMMENT 'PAYMENT LAST NAME',
  `invoiceid` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `zc_payment`
--

INSERT INTO `zc_payment` (`paymentid`, `method`, `DATE`, `cardnum`, `cvv`, `expdate`, `paymentfname`, `paymentlname`, `invoiceid`) VALUES
(1, 'credit', '2023-12-10 00:00:00', '221314', '123', '0000-00-00 00:00:00', 'George', 'He', 1),
(2, 'credit', '2023-12-10 00:00:00', '21312414', '123', '0000-00-00 00:00:00', 'zhuo', 'chen', 3),
(3, 'credit', '2023-12-10 00:00:00', '3414124124', '213', '0000-00-00 00:00:00', 'zhuo', 'chen', 4),
(4, 'credit', '2023-12-10 00:00:00', '123141', '322', '0000-00-00 00:00:00', 'zhuo', 'chen', 5),
(5, 'credit', '2023-12-10 00:00:00', '12313412421', '123', '0000-00-00 00:00:00', 'zhuo', 'chen', 7),
(6, 'credit', '2023-12-10 00:00:00', '21414124', '212', '0000-00-00 00:00:00', 'zhuo', 'chen', 9);

--
-- Triggers `zc_payment`
--
DELIMITER $$
CREATE TRIGGER `generate_paymentid` BEFORE INSERT ON `zc_payment` FOR EACH ROW BEGIN
  DECLARE max_paymentid INT;
  SET max_paymentid = (SELECT MAX(paymentid) FROM zc_payment);
  IF max_paymentid IS NULL THEN
    SET NEW.paymentid = 1;
  ELSE
    SET NEW.paymentid = max_paymentid + 1;
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `zc_rental`
--

CREATE TABLE `zc_rental` (
  `rentalid` int(11) NOT NULL,
  `pickupdate` datetime NOT NULL COMMENT 'THE DATE OF PICKUP',
  `dropoffdate` datetime NOT NULL,
  `startodo` int(11) NOT NULL COMMENT 'THE START MILES OF ODOMETER',
  `endodo` int(11) NOT NULL COMMENT 'THE END MILES OF ODOMETER',
  `pickuploc` int(11) NOT NULL,
  `customerid` int(11) NOT NULL,
  `vin` varchar(18) NOT NULL,
  `dropoffloc` int(11) NOT NULL,
  `couponid` int(11) DEFAULT NULL,
  `dailylimit` smallint(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `zc_rental`
--

INSERT INTO `zc_rental` (`rentalid`, `pickupdate`, `dropoffdate`, `startodo`, `endodo`, `pickuploc`, `customerid`, `vin`, `dropoffloc`, `couponid`, `dailylimit`) VALUES
(1, '2023-12-13 00:00:00', '2023-12-18 00:00:00', 0, 750, 33, 37, 'VIN12345678901234', 33, 36, 150),
(2, '2023-12-24 00:00:00', '2023-12-27 00:00:00', 0, 0, 39, 36, 'VIN67890123456789', 39, 36, 0),
(3, '2023-12-24 00:00:00', '2023-12-27 00:00:00', 0, 0, 39, 36, 'VIN67890123456789', 39, 36, 0),
(4, '2024-02-14 00:00:00', '2024-02-28 00:00:00', 0, 0, 39, 36, 'VIN67890123456789', 39, 36, 0),
(5, '2024-02-01 00:00:00', '2024-02-10 00:00:00', 0, 0, 37, 36, 'VIN67890123456789', 37, 36, 0),
(6, '2024-02-01 00:00:00', '2024-02-10 00:00:00', 0, 0, 37, 36, 'VIN67890123456789', 37, 36, 0),
(7, '2023-12-14 00:00:00', '2023-12-21 00:00:00', 982, 2382, 33, 36, 'VIN78976234567890', 33, 36, 200),
(8, '2023-12-14 00:00:00', '2023-12-21 00:00:00', 982, 2382, 33, 36, 'VIN78976234567890', 33, 36, 200),
(9, '2023-12-23 00:00:00', '2023-12-29 00:00:00', 1200, 2100, 33, 36, 'VIN56789012345679', 33, 36, 150);

--
-- Triggers `zc_rental`
--
DELIMITER $$
CREATE TRIGGER `generate_rentalid` BEFORE INSERT ON `zc_rental` FOR EACH ROW BEGIN
  DECLARE max_rentalid INT;
  SET max_rentalid = (SELECT MAX(rentalid) FROM zc_rental);
  IF max_rentalid IS NULL THEN
    SET NEW.rentalid = 1;
  ELSE
    SET NEW.rentalid = max_rentalid + 1;
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `zc_vehicle`
--

CREATE TABLE `zc_vehicle` (
  `vin` varchar(18) NOT NULL COMMENT 'VIN number of a car',
  `make` varchar(20) NOT NULL COMMENT 'brand of a car',
  `model` varchar(20) NOT NULL COMMENT 'MODEL OF VEHICLE ',
  `year` smallint(6) NOT NULL COMMENT 'the year of a car',
  `plate` varchar(10) NOT NULL COMMENT 'license plate of a car',
  `officeid` int(11) NOT NULL,
  `typeid` smallint(6) NOT NULL,
  `dailylimit` smallint(6) DEFAULT NULL,
  `odometer` smallint(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `zc_vehicle`
--

INSERT INTO `zc_vehicle` (`vin`, `make`, `model`, `year`, `plate`, `officeid`, `typeid`, `dailylimit`, `odometer`) VALUES
('VIN01234567890124', 'Honda', 'Accord', 2023, 'JKL345', 37, 64, 150, 4500),
('VIN12345678901234', 'Honda', 'Odyssey', 2023, 'XYZ789', 39, 68, 150, 0),
('VIN12345678901235', 'Ford', 'Explorer', 2023, 'MNO678', 37, 65, 200, 7890),
('VIN23456789012345', 'Chevrolet', 'Camaro', 2023, 'ABC456', 39, 69, 100, 1500),
('VIN23456789012346', 'Chevrolet', 'Equinox', 2023, 'PQR901', 37, 66, 120, 2300),
('VIN34567890123456', 'Ford', 'F-150', 2023, 'DEF789', 39, 70, 300, 0),
('VIN34567890123457', 'Toyota', 'Camry', 2023, 'STU234', 38, 62, 180, 3450),
('VIN45678901234567', 'Mercedes-Benz', 'S-Class', 2023, 'GHI012', 39, 71, NULL, 0),
('VIN45678901234568', 'Nissan', 'Rogue', 2023, 'ABC567', 38, 63, 200, 6780),
('VIN56789012345678', 'Toyota', 'Sienna', 2023, 'GHI789', 38, 62, 150, 0),
('VIN56789012345679', 'Tesla', 'Model 3', 2023, 'DEF890', 38, 64, 150, 1200),
('VIN67890123456780', 'BMW', 'X5', 2023, 'GHI123', 39, 67, 250, 5600),
('VIN67890123456789', 'BMW', 'Z4', 2023, 'JKL012', 38, 63, NULL, 0),
('VIN78901234567890', 'Nissan', 'Sentra', 2023, 'MNO345', 38, 64, 120, 0),
('VIN78901234567891', 'Mercedes-Benz', 'A-Class', 2023, 'UVW567', 39, 68, NULL, 0),
('VIN78976234567890', 'Tesla', 'Model Y', 2023, 'MNO345', 38, 64, 200, 982),
('VIN78976234567892', 'Honda', 'Pilot', 2023, 'STU012', 37, 63, 180, 6700),
('VIN89012345678901', 'Mercedes-Benz', 'GLE', 2023, 'PQR678', 38, 65, NULL, 0),
('VIN89012345678902', 'Toyota', 'Highlander', 2023, 'XYZ890', 39, 69, 200, 8900),
('VIN89018755678901', 'Mercedes-Benz', 'C300', 2021, 'PQR878', 38, 65, 200, 5980),
('VIN89018755678903', 'Nissan', 'Altima', 2023, 'PQR789', 37, 62, 150, 4567),
('VIN90123456789012', 'Toyota', 'Prius', 2023, 'STU901', 39, 66, 120, 0),
('VIN90123456789013', 'Ford', 'Mustang', 2023, 'JKL123', 39, 70, 100, 3400),
('VIN99423423789014', 'Chevrolet', 'Malibu', 2023, 'MNO456', 39, 71, NULL, 0);

-- --------------------------------------------------------

--
-- Table structure for table `zc_vehicleclass`
--

CREATE TABLE `zc_vehicleclass` (
  `typeid` smallint(6) NOT NULL COMMENT 'THE TYPE ID OF VEHICLE',
  `vehicletype` varchar(10) NOT NULL COMMENT 'SUV, SC(small car), MC(median car),LUX,PSUV(premier suv),MINI VAN, SW(station wagon), EV(electric vehicle), OTHER\r\n',
  `rentalcharge` decimal(6,2) NOT NULL,
  `extracharge` decimal(6,2) NOT NULL COMMENT 'EXTRA CHARGE OUT OF THE LIMITATION'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `zc_vehicleclass`
--

INSERT INTO `zc_vehicleclass` (`typeid`, `vehicletype`, `rentalcharge`, `extracharge`) VALUES
(33, 'SUV', 40.00, 8.00),
(35, 'SUV', 40.00, 8.00),
(36, 'Sedan', 35.00, 7.00),
(37, 'Truck', 50.00, 10.00),
(38, 'Conv', 55.00, 12.00),
(39, 'Compact', 30.00, 5.00),
(40, 'Luxury SUV', 70.00, 15.00),
(41, 'Sedan', 35.00, 7.00),
(42, 'Truck', 50.00, 10.00),
(43, 'Electric', 45.00, 9.00),
(44, 'Conv', 55.00, 12.00),
(45, 'Lux', 60.00, 15.00),
(46, 'Hybrid', 50.00, 10.00),
(47, 'Sedan', 45.00, 9.00),
(48, 'Sports Car', 55.00, 11.00),
(49, 'Compact', 40.00, 8.00),
(50, 'SUV', 50.00, 10.00),
(51, 'Hybrid', 55.00, 12.00),
(52, 'Conv', 60.00, 15.00),
(60, 'Sedan', 45.00, 9.00),
(61, 'Truck', 55.00, 12.00),
(62, 'Minivan', 50.00, 10.00),
(63, 'Conv', 60.00, 15.00),
(64, 'Compact', 35.00, 7.00),
(65, 'Luxury SUV', 70.00, 18.00),
(66, 'Hybrid', 45.00, 10.00),
(67, 'Sedan', 35.00, 7.00),
(68, 'Minivan', 55.00, 12.00),
(69, 'Conv', 50.00, 15.00),
(70, 'Truck', 60.00, 18.00),
(71, 'Luxury', 70.00, 20.00);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD KEY `fk_customerid` (`customerid`);

--
-- Indexes for table `zc_corpcust`
--
ALTER TABLE `zc_corpcust`
  ADD PRIMARY KEY (`customerid`),
  ADD UNIQUE KEY `zc_corpcust_pkv1` (`empid`),
  ADD KEY `zc_corpcust_zc_corporation_fk` (`corpid`);

--
-- Indexes for table `zc_corporation`
--
ALTER TABLE `zc_corporation`
  ADD PRIMARY KEY (`corpid`);

--
-- Indexes for table `zc_coupons`
--
ALTER TABLE `zc_coupons`
  ADD PRIMARY KEY (`couponid`);

--
-- Indexes for table `zc_customer`
--
ALTER TABLE `zc_customer`
  ADD PRIMARY KEY (`customerid`);

--
-- Indexes for table `zc_customer_coupon`
--
ALTER TABLE `zc_customer_coupon`
  ADD PRIMARY KEY (`couponid`),
  ADD KEY `zc_customer_coupon_zc_fk` (`customerid`);

--
-- Indexes for table `zc_individual`
--
ALTER TABLE `zc_individual`
  ADD PRIMARY KEY (`customerid`);

--
-- Indexes for table `zc_invoice`
--
ALTER TABLE `zc_invoice`
  ADD PRIMARY KEY (`invoiceid`),
  ADD UNIQUE KEY `zc_invoice__idxv1` (`rentalid`);

--
-- Indexes for table `zc_office`
--
ALTER TABLE `zc_office`
  ADD PRIMARY KEY (`officeid`);

--
-- Indexes for table `zc_payment`
--
ALTER TABLE `zc_payment`
  ADD PRIMARY KEY (`paymentid`),
  ADD UNIQUE KEY `zc_payment__idx` (`invoiceid`);

--
-- Indexes for table `zc_rental`
--
ALTER TABLE `zc_rental`
  ADD PRIMARY KEY (`rentalid`),
  ADD KEY `zc_rental_zc_coupons_fk` (`couponid`),
  ADD KEY `zc_rental_zc_customer_fk` (`customerid`),
  ADD KEY `zc_rental_zc_office_fk` (`pickuploc`),
  ADD KEY `zc_rental_zc_office_fkv2` (`dropoffloc`),
  ADD KEY `zc_rental_zc_vehicle_fk` (`vin`);

--
-- Indexes for table `zc_vehicle`
--
ALTER TABLE `zc_vehicle`
  ADD PRIMARY KEY (`vin`),
  ADD KEY `zc_vehicle_zc_office_fk` (`officeid`),
  ADD KEY `zc_vehicle_zc_vehicleclass_fk` (`typeid`);

--
-- Indexes for table `zc_vehicleclass`
--
ALTER TABLE `zc_vehicleclass`
  ADD PRIMARY KEY (`typeid`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `zc_corporation`
--
ALTER TABLE `zc_corporation`
  MODIFY `corpid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT for table `zc_customer`
--
ALTER TABLE `zc_customer`
  MODIFY `customerid` int(11) NOT NULL AUTO_INCREMENT COMMENT 'THE ID OF A CUSTOMER';

--
-- Constraints for dumped tables
--

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `fk_customerid` FOREIGN KEY (`customerid`) REFERENCES `zc_customer` (`customerid`);

--
-- Constraints for table `zc_corpcust`
--
ALTER TABLE `zc_corpcust`
  ADD CONSTRAINT `zc_corpcust_zc_corporation_fk` FOREIGN KEY (`corpid`) REFERENCES `zc_corporation` (`corpid`),
  ADD CONSTRAINT `zc_corpcust_zc_customer_fk` FOREIGN KEY (`customerid`) REFERENCES `zc_customer` (`customerid`);

--
-- Constraints for table `zc_customer_coupon`
--
ALTER TABLE `zc_customer_coupon`
  ADD CONSTRAINT `zc_customer_coupon_fk` FOREIGN KEY (`couponid`) REFERENCES `zc_coupons` (`couponid`),
  ADD CONSTRAINT `zc_customer_coupon_zc_fk` FOREIGN KEY (`customerid`) REFERENCES `zc_customer` (`customerid`);

--
-- Constraints for table `zc_individual`
--
ALTER TABLE `zc_individual`
  ADD CONSTRAINT `zc_individual_zc_customer_fk` FOREIGN KEY (`customerid`) REFERENCES `zc_customer` (`customerid`);

--
-- Constraints for table `zc_invoice`
--
ALTER TABLE `zc_invoice`
  ADD CONSTRAINT `zc_invoice_zc_rental_fk` FOREIGN KEY (`rentalid`) REFERENCES `zc_rental` (`rentalid`);

--
-- Constraints for table `zc_payment`
--
ALTER TABLE `zc_payment`
  ADD CONSTRAINT `zc_payment_zc_invoice_fk` FOREIGN KEY (`invoiceid`) REFERENCES `zc_invoice` (`invoiceid`);

--
-- Constraints for table `zc_rental`
--
ALTER TABLE `zc_rental`
  ADD CONSTRAINT `zc_rental_zc_coupons_fk` FOREIGN KEY (`couponid`) REFERENCES `zc_coupons` (`couponid`),
  ADD CONSTRAINT `zc_rental_zc_customer_fk` FOREIGN KEY (`customerid`) REFERENCES `zc_customer` (`customerid`),
  ADD CONSTRAINT `zc_rental_zc_office_fk` FOREIGN KEY (`pickuploc`) REFERENCES `zc_office` (`officeid`),
  ADD CONSTRAINT `zc_rental_zc_office_fkv2` FOREIGN KEY (`dropoffloc`) REFERENCES `zc_office` (`officeid`),
  ADD CONSTRAINT `zc_rental_zc_vehicle_fk` FOREIGN KEY (`vin`) REFERENCES `zc_vehicle` (`vin`);

--
-- Constraints for table `zc_vehicle`
--
ALTER TABLE `zc_vehicle`
  ADD CONSTRAINT `zc_vehicle_zc_office_fk` FOREIGN KEY (`officeid`) REFERENCES `zc_office` (`officeid`),
  ADD CONSTRAINT `zc_vehicle_zc_vehicleclass_fk` FOREIGN KEY (`typeid`) REFERENCES `zc_vehicleclass` (`typeid`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
