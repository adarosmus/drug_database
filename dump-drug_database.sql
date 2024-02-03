-- MySQL dump 10.13  Distrib 8.0.19, for Win64 (x86_64)
--
-- Host: localhost    Database: drug_database
-- ------------------------------------------------------
-- Server version	11.3.0-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `doctor`
--

DROP TABLE IF EXISTS `doctor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `doctor` (
  `DoctorID` int(11) NOT NULL,
  `FirstName` varchar(255) DEFAULT NULL,
  `LastName` varchar(255) DEFAULT NULL,
  `Specialization` varchar(255) DEFAULT NULL,
  `ContactNumber` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`DoctorID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `doctor`
--

LOCK TABLES `doctor` WRITE;
/*!40000 ALTER TABLE `doctor` DISABLE KEYS */;
INSERT INTO `doctor` VALUES (1,'John','Doe','Cardiologist','111-222-333'),(2,'Jane','Smith','Pediatrician','444-555-666'),(3,'Eva','Brown','Dermatologist','333-555-888');
/*!40000 ALTER TABLE `doctor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `drug`
--

DROP TABLE IF EXISTS `drug`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `drug` (
  `DrugID` int(11) NOT NULL,
  `CompanyID` int(11) DEFAULT NULL,
  `Stock` int(11) DEFAULT NULL,
  `ExpirationDate` date DEFAULT NULL,
  `Name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`DrugID`),
  KEY `CompanyID` (`CompanyID`),
  CONSTRAINT `drug_ibfk_1` FOREIGN KEY (`CompanyID`) REFERENCES `drugmanufacturer` (`CompanyID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `drug`
--

LOCK TABLES `drug` WRITE;
/*!40000 ALTER TABLE `drug` DISABLE KEYS */;
INSERT INTO `drug` VALUES (1,1,100,'2023-01-01','Aspirin'),(2,2,50,'2024-02-01','Cough Syrup'),(3,2,40,'2024-05-01','Antibiotic X');
/*!40000 ALTER TABLE `drug` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `drugavailability`
--

DROP TABLE IF EXISTS `drugavailability`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `drugavailability` (
  `DrugAvailabilityID` int(11) NOT NULL,
  `DrugID` int(11) DEFAULT NULL,
  `PharmacyID` int(11) DEFAULT NULL,
  `Stock` int(11) DEFAULT NULL,
  `AvailabilityDate` date DEFAULT NULL,
  PRIMARY KEY (`DrugAvailabilityID`),
  KEY `idx_DrugAvailability_DrugID` (`DrugID`),
  KEY `idx_DrugAvailability_PharmacyID` (`PharmacyID`),
  KEY `idx_DrugAvailability_AvailabilityDate` (`AvailabilityDate`),
  CONSTRAINT `drugavailability_ibfk_1` FOREIGN KEY (`DrugID`) REFERENCES `drug` (`DrugID`),
  CONSTRAINT `drugavailability_ibfk_2` FOREIGN KEY (`PharmacyID`) REFERENCES `pharmacy` (`PharmacyID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `drugavailability`
--

LOCK TABLES `drugavailability` WRITE;
/*!40000 ALTER TABLE `drugavailability` DISABLE KEYS */;
INSERT INTO `drugavailability` VALUES (1,1,1,72,'2023-01-01'),(2,2,2,75,'2024-02-01'),(3,3,3,75,'2023-03-01');
/*!40000 ALTER TABLE `drugavailability` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER NotifyOutOfStock
BEFORE UPDATE ON DrugAvailability
FOR EACH ROW
BEGIN
    IF NEW.Stock < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Out of stock for the drug in the pharmacy';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Temporary view structure for view `drugavailabilityinfo`
--

DROP TABLE IF EXISTS `drugavailabilityinfo`;
/*!50001 DROP VIEW IF EXISTS `drugavailabilityinfo`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `drugavailabilityinfo` AS SELECT 
 1 AS `DrugName`,
 1 AS `PharmacyName`,
 1 AS `Stock`,
 1 AS `AvailabilityDate`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `druginfo`
--

DROP TABLE IF EXISTS `druginfo`;
/*!50001 DROP VIEW IF EXISTS `druginfo`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `druginfo` AS SELECT 
 1 AS `DrugID`,
 1 AS `DrugName`,
 1 AS `Stock`,
 1 AS `ExpirationDate`,
 1 AS `CostPrice`,
 1 AS `ManufacturerName`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `drugmanufacturer`
--

DROP TABLE IF EXISTS `drugmanufacturer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `drugmanufacturer` (
  `CompanyID` int(11) NOT NULL,
  `Name` varchar(255) DEFAULT NULL,
  `ContactNumber` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`CompanyID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `drugmanufacturer`
--

LOCK TABLES `drugmanufacturer` WRITE;
/*!40000 ALTER TABLE `drugmanufacturer` DISABLE KEYS */;
INSERT INTO `drugmanufacturer` VALUES (1,'PharmaCorp','123-456-789'),(2,'MediLab','987-654-321'),(3,'InnoMed Solutions','555-123-456');
/*!40000 ALTER TABLE `drugmanufacturer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `drugstatus`
--

DROP TABLE IF EXISTS `drugstatus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `drugstatus` (
  `PrescribeID` int(11) NOT NULL,
  `PharmacyID` int(11) DEFAULT NULL,
  `Availability` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`PrescribeID`),
  KEY `PharmacyID` (`PharmacyID`),
  CONSTRAINT `drugstatus_ibfk_1` FOREIGN KEY (`PharmacyID`) REFERENCES `pharmacy` (`PharmacyID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `drugstatus`
--

LOCK TABLES `drugstatus` WRITE;
/*!40000 ALTER TABLE `drugstatus` DISABLE KEYS */;
INSERT INTO `drugstatus` VALUES (1,1,'Available'),(2,2,'Out of stock'),(3,3,'Available');
/*!40000 ALTER TABLE `drugstatus` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `patient`
--

DROP TABLE IF EXISTS `patient`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `patient` (
  `PatientID` int(11) NOT NULL,
  `FirstName` varchar(255) DEFAULT NULL,
  `LastName` varchar(255) DEFAULT NULL,
  `Address` varchar(255) DEFAULT NULL,
  `ContactNumber` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`PatientID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patient`
--

LOCK TABLES `patient` WRITE;
/*!40000 ALTER TABLE `patient` DISABLE KEYS */;
INSERT INTO `patient` VALUES (1,'Alice','Johnson','123 Main St','777-888-999'),(2,'Bob','Miller','456 Oak St','111-222-333'),(3,'Charlie','Brown','789 Pine St','555-777-888'),(4,'Eva','Anderson','101 Elm St','999-888-777'),(5,'Sophie','Lee','123 Oak St','555-666-777');
/*!40000 ALTER TABLE `patient` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `patientprescriptiondrugavailability`
--

DROP TABLE IF EXISTS `patientprescriptiondrugavailability`;
/*!50001 DROP VIEW IF EXISTS `patientprescriptiondrugavailability`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `patientprescriptiondrugavailability` AS SELECT 
 1 AS `PatientID`,
 1 AS `PatientFullName`,
 1 AS `DoctorFullName`,
 1 AS `DrugNames`,
 1 AS `TotalCost`,
 1 AS `DrugStock`,
 1 AS `AvailabilityDate`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `patientprescriptioninfo`
--

DROP TABLE IF EXISTS `patientprescriptioninfo`;
/*!50001 DROP VIEW IF EXISTS `patientprescriptioninfo`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `patientprescriptioninfo` AS SELECT 
 1 AS `PatientID`,
 1 AS `PatientFullName`,
 1 AS `DoctorFullName`,
 1 AS `DrugNames`,
 1 AS `TotalCost`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `pharmacy`
--

DROP TABLE IF EXISTS `pharmacy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pharmacy` (
  `PharmacyID` int(11) NOT NULL,
  `Name` varchar(255) DEFAULT NULL,
  `ContactNumber` varchar(20) DEFAULT NULL,
  `CityName` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`PharmacyID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pharmacy`
--

LOCK TABLES `pharmacy` WRITE;
/*!40000 ALTER TABLE `pharmacy` DISABLE KEYS */;
INSERT INTO `pharmacy` VALUES (1,'City Pharmacy','555-111-222','Metropolis'),(2,'Suburb Drugstore','333-444-555','Suburbia'),(3,'PharmCity','777-999-111','MediTown');
/*!40000 ALTER TABLE `pharmacy` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `prescription`
--

DROP TABLE IF EXISTS `prescription`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prescription` (
  `PrescriptionID` int(11) NOT NULL,
  `PatientID` int(11) DEFAULT NULL,
  `DoctorID` int(11) DEFAULT NULL,
  `PrescriptionDate` date DEFAULT NULL,
  `IsFulfilled` tinyint(4) DEFAULT 0,
  PRIMARY KEY (`PrescriptionID`),
  KEY `PatientID` (`PatientID`),
  KEY `DoctorID` (`DoctorID`),
  CONSTRAINT `prescription_ibfk_1` FOREIGN KEY (`PatientID`) REFERENCES `patient` (`PatientID`),
  CONSTRAINT `prescription_ibfk_2` FOREIGN KEY (`DoctorID`) REFERENCES `doctor` (`DoctorID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prescription`
--

LOCK TABLES `prescription` WRITE;
/*!40000 ALTER TABLE `prescription` DISABLE KEYS */;
INSERT INTO `prescription` VALUES (1,1,1,'2023-01-15',1),(2,2,2,'2024-02-15',1),(3,3,1,'2023-03-20',1),(4,4,1,'2023-04-05',1),(5,4,2,'2023-04-07',1),(6,2,1,'2021-05-15',1),(7,1,1,'2024-01-25',1);
/*!40000 ALTER TABLE `prescription` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `prescriptiondetails`
--

DROP TABLE IF EXISTS `prescriptiondetails`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prescriptiondetails` (
  `PrescriptionDetailID` int(11) NOT NULL,
  `PrescriptionID` int(11) DEFAULT NULL,
  `DrugID` int(11) DEFAULT NULL,
  `Quantity` int(11) DEFAULT NULL,
  PRIMARY KEY (`PrescriptionDetailID`),
  KEY `PrescriptionID` (`PrescriptionID`),
  KEY `DrugID` (`DrugID`),
  CONSTRAINT `prescriptiondetails_ibfk_1` FOREIGN KEY (`PrescriptionID`) REFERENCES `prescription` (`PrescriptionID`),
  CONSTRAINT `prescriptiondetails_ibfk_2` FOREIGN KEY (`DrugID`) REFERENCES `drug` (`DrugID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prescriptiondetails`
--

LOCK TABLES `prescriptiondetails` WRITE;
/*!40000 ALTER TABLE `prescriptiondetails` DISABLE KEYS */;
INSERT INTO `prescriptiondetails` VALUES (1,1,1,2),(2,2,2,1),(3,3,1,1),(4,3,2,1),(5,4,1,2),(6,5,2,1),(7,2,1,5),(8,7,1,3);
/*!40000 ALTER TABLE `prescriptiondetails` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER UpdateDrugAvailabilityOnPrescriptionFulfillment
AFTER INSERT ON PrescriptionDetails
FOR EACH ROW
BEGIN
    DECLARE fulfilled INT;

    -- Check if the prescription is fulfilled
    SELECT IsFulfilled INTO fulfilled
    FROM Prescription
    WHERE PrescriptionID = NEW.PrescriptionID;

    -- If the prescription is fulfilled, update drug availability
    IF fulfilled = 1 THEN
        UPDATE DrugAvailability
        SET Stock = Stock - NEW.Quantity
        WHERE DrugID = NEW.DrugID;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `price`
--

DROP TABLE IF EXISTS `price`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `price` (
  `CostPrice` decimal(10,2) NOT NULL,
  `PreviousPrice` decimal(10,2) DEFAULT NULL,
  `DrugID` int(11) DEFAULT NULL,
  PRIMARY KEY (`CostPrice`),
  KEY `DrugID` (`DrugID`),
  CONSTRAINT `price_ibfk_1` FOREIGN KEY (`DrugID`) REFERENCES `drug` (`DrugID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `price`
--

LOCK TABLES `price` WRITE;
/*!40000 ALTER TABLE `price` DISABLE KEYS */;
INSERT INTO `price` VALUES (8.50,10.00,3),(10.00,12.00,2),(11.50,6.00,1);
/*!40000 ALTER TABLE `price` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER TrackDrugPriceChanges
AFTER UPDATE ON Price
FOR EACH ROW
BEGIN
    IF OLD.CostPrice <> NEW.CostPrice THEN
        INSERT INTO PriceChangeHistory (DrugID, NewPrice, ChangeDate)
        SELECT NEW.DrugID, MAX(NEW.CostPrice), NOW()
        FROM Price
        WHERE DrugID = NEW.DrugID
        GROUP BY DrugID;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `pricechangehistory`
--

DROP TABLE IF EXISTS `pricechangehistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pricechangehistory` (
  `ChangeID` int(11) NOT NULL AUTO_INCREMENT,
  `DrugID` int(11) DEFAULT NULL,
  `NewPrice` decimal(10,2) DEFAULT NULL,
  `ChangeDate` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`ChangeID`),
  UNIQUE KEY `unique_price_change` (`DrugID`,`NewPrice`),
  CONSTRAINT `pricechangehistory_ibfk_1` FOREIGN KEY (`DrugID`) REFERENCES `drug` (`DrugID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pricechangehistory`
--

LOCK TABLES `pricechangehistory` WRITE;
/*!40000 ALTER TABLE `pricechangehistory` DISABLE KEYS */;
INSERT INTO `pricechangehistory` VALUES (1,1,8.50,'2024-02-03 16:25:01'),(2,1,9.00,'2024-02-03 16:31:10'),(3,1,11.50,'2024-02-03 16:36:56');
/*!40000 ALTER TABLE `pricechangehistory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'drug_database'
--
/*!50003 DROP FUNCTION IF EXISTS `GetAverageDrugsPerPatient` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `GetAverageDrugsPerPatient`() RETURNS decimal(10,2)
BEGIN
    DECLARE averageDrugs DECIMAL(10, 2);
    SELECT AVG(drugCount) INTO averageDrugs
    FROM (
        SELECT COUNT(PD.DrugID) AS drugCount
        FROM PrescriptionDetails PD
        JOIN Prescription Pr ON PD.PrescriptionID = Pr.PrescriptionID
        GROUP BY PD.PrescriptionID, Pr.PatientID
    ) AS DrugCounts;
    RETURN averageDrugs;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `GetDrugsInPharmacy` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `GetDrugsInPharmacy`(pharmacyID INT) RETURNS varchar(255) CHARSET latin1 COLLATE latin1_swedish_ci
BEGIN
    DECLARE drugList VARCHAR(255);
    SELECT GROUP_CONCAT(D.Name) INTO drugList
    FROM DrugAvailability DA
    JOIN Drug D ON DA.DrugID = D.DrugID
    WHERE DA.PharmacyID = pharmacyID;
    RETURN drugList;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `GetPrescriptionCountForDoctor` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `GetPrescriptionCountForDoctor`(doctorID INT) RETURNS int(11)
BEGIN
    DECLARE prescriptionCount INT;
    SELECT COUNT(*) INTO prescriptionCount
    FROM Prescription
    WHERE DoctorID = doctorID;
    RETURN prescriptionCount;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `GetTotalCostForPatient` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `GetTotalCostForPatient`(patientID INT) RETURNS decimal(10,2)
BEGIN
    DECLARE totalCost DECIMAL(10, 2);
    SELECT SUM(Drg.CostPrice * PD.Quantity) INTO totalCost
    FROM Prescription Pr
    JOIN PrescriptionDetails PD ON PD.PrescriptionID = Pr.PrescriptionID
    JOIN Drug D ON PD.DrugID = D.DrugID
    JOIN Price Drg ON D.DrugID = Drg.DrugID
    WHERE Pr.PatientID = patientID;
    RETURN totalCost;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `MarkPrescriptionAsFulfilled` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `MarkPrescriptionAsFulfilled`(
    IN prescriptionID INT
)
BEGIN
    UPDATE Prescription
    SET IsFulfilled = 1
    WHERE PrescriptionID = prescriptionID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `UpdateDrugAvailability` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateDrugAvailability`(
    IN drugID INT,
    IN pharmacyID INT,
    IN newStock INT
)
BEGIN
    UPDATE DrugAvailability
    SET Stock = newStock
    WHERE DrugID = drugID AND PharmacyID = pharmacyID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `UpdateDrugPrice` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateDrugPrice`(
    IN drugID INT,
    IN newCostPrice DECIMAL(10, 2)
)
BEGIN
    DECLARE existingRecordCount INT;

    -- Check if a record with the given DrugID already exists
    SELECT COUNT(*) INTO existingRecordCount
    FROM PriceChangeHistory
    WHERE DrugID = drugID;

    -- If a record exists, update it; otherwise, insert a new one
    IF existingRecordCount > 0 THEN
        UPDATE PriceChangeHistory
        SET NewPrice = newCostPrice, ChangeDate = CURRENT_TIMESTAMP
        WHERE DrugID = drugID;
    ELSE
        INSERT INTO PriceChangeHistory (DrugID, NewPrice)
        VALUES (drugID, newCostPrice);
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `drugavailabilityinfo`
--

/*!50001 DROP VIEW IF EXISTS `drugavailabilityinfo`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `drugavailabilityinfo` AS select `d`.`Name` AS `DrugName`,`p`.`Name` AS `PharmacyName`,`da`.`Stock` AS `Stock`,`da`.`AvailabilityDate` AS `AvailabilityDate` from ((`drugavailability` `da` join `drug` `d` on(`da`.`DrugID` = `d`.`DrugID`)) join `pharmacy` `p` on(`da`.`PharmacyID` = `p`.`PharmacyID`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `druginfo`
--

/*!50001 DROP VIEW IF EXISTS `druginfo`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `druginfo` AS select `d`.`DrugID` AS `DrugID`,`d`.`Name` AS `DrugName`,`d`.`Stock` AS `Stock`,`d`.`ExpirationDate` AS `ExpirationDate`,`drg`.`CostPrice` AS `CostPrice`,`dm`.`Name` AS `ManufacturerName` from ((`drug` `d` join `price` `drg` on(`d`.`DrugID` = `drg`.`DrugID`)) join `drugmanufacturer` `dm` on(`d`.`CompanyID` = `dm`.`CompanyID`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `patientprescriptiondrugavailability`
--

/*!50001 DROP VIEW IF EXISTS `patientprescriptiondrugavailability`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `patientprescriptiondrugavailability` AS select `pr`.`PatientID` AS `PatientID`,concat(`p`.`FirstName`,' ',`p`.`LastName`) AS `PatientFullName`,concat(`doc`.`FirstName`,' ',`doc`.`LastName`) AS `DoctorFullName`,group_concat(`d`.`Name` separator ',') AS `DrugNames`,sum(`drg`.`CostPrice` * `pd`.`Quantity`) AS `TotalCost`,`da`.`Stock` AS `DrugStock`,`da`.`AvailabilityDate` AS `AvailabilityDate` from ((((((`prescription` `pr` join `prescriptiondetails` `pd` on(`pd`.`PrescriptionID` = `pr`.`PrescriptionID`)) join `patient` `p` on(`pr`.`PatientID` = `p`.`PatientID`)) join `doctor` `doc` on(`pr`.`DoctorID` = `doc`.`DoctorID`)) join `drug` `d` on(`pd`.`DrugID` = `d`.`DrugID`)) join `price` `drg` on(`d`.`DrugID` = `drg`.`DrugID`)) join `drugavailability` `da` on(`d`.`DrugID` = `da`.`DrugID`)) group by `pr`.`PatientID`,`doc`.`DoctorID`,`pr`.`PrescriptionID`,`da`.`Stock`,`da`.`AvailabilityDate` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `patientprescriptioninfo`
--

/*!50001 DROP VIEW IF EXISTS `patientprescriptioninfo`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_unicode_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `patientprescriptioninfo` AS select `pr`.`PatientID` AS `PatientID`,concat(`p`.`FirstName`,' ',`p`.`LastName`) AS `PatientFullName`,concat(`doc`.`FirstName`,' ',`doc`.`LastName`) AS `DoctorFullName`,group_concat(`d`.`Name` separator ',') AS `DrugNames`,sum(`drg`.`CostPrice` * `pd`.`Quantity`) AS `TotalCost` from (((((`prescription` `pr` join `prescriptiondetails` `pd` on(`pd`.`PrescriptionID` = `pr`.`PrescriptionID`)) join `patient` `p` on(`pr`.`PatientID` = `p`.`PatientID`)) join `doctor` `doc` on(`pr`.`DoctorID` = `doc`.`DoctorID`)) join `drug` `d` on(`pd`.`DrugID` = `d`.`DrugID`)) join `price` `drg` on(`d`.`DrugID` = `drg`.`DrugID`)) group by `pr`.`PatientID`,`doc`.`DoctorID`,`pr`.`PrescriptionID` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-02-03 17:47:22
