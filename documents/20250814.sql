CREATE DATABASE  IF NOT EXISTS `fitlink_db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `fitlink_db`;
-- MySQL dump 10.13  Distrib 8.0.42, for Win64 (x86_64)
--
-- Host: localhost    Database: fitlink_db
-- ------------------------------------------------------
-- Server version	8.0.42

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `availability`
--

DROP TABLE IF EXISTS `availability`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `availability` (
  `availability_id` int NOT NULL AUTO_INCREMENT,
  `available_datetime` datetime DEFAULT NULL,
  PRIMARY KEY (`availability_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `availability`
--

LOCK TABLES `availability` WRITE;
/*!40000 ALTER TABLE `availability` DISABLE KEYS */;
/*!40000 ALTER TABLE `availability` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `booking_status`
--

DROP TABLE IF EXISTS `booking_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `booking_status` (
  `booking_id` int NOT NULL AUTO_INCREMENT,
  `status` enum('scheduled','completed','canceled') COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`booking_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `booking_status`
--

LOCK TABLES `booking_status` WRITE;
/*!40000 ALTER TABLE `booking_status` DISABLE KEYS */;
/*!40000 ALTER TABLE `booking_status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exercise`
--

DROP TABLE IF EXISTS `exercise`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `exercise` (
  `exercise_id` int NOT NULL AUTO_INCREMENT,
  `body_part` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `exercise_name` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`exercise_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exercise`
--

LOCK TABLES `exercise` WRITE;
/*!40000 ALTER TABLE `exercise` DISABLE KEYS */;
/*!40000 ALTER TABLE `exercise` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inbody`
--

DROP TABLE IF EXISTS `inbody`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inbody` (
  `inbody_id` int NOT NULL AUTO_INCREMENT,
  `record_date` date DEFAULT NULL,
  `image_url` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `weight_kg` decimal(5,2) DEFAULT NULL,
  `muscle_mass_kg` decimal(5,2) DEFAULT NULL,
  `fat_mass_kg` decimal(5,2) DEFAULT NULL,
  `bmi` decimal(4,2) DEFAULT NULL,
  `percent_body_fat` decimal(4,2) DEFAULT NULL,
  `cid_type` enum('C','I','D') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `visceral_fat_level` int DEFAULT NULL,
  `fat_control_kg` decimal(4,1) DEFAULT NULL,
  `muscle_control_kg` decimal(4,1) DEFAULT NULL,
  `upper_lower_balance` enum('BALANCED','UPPER_DEVELOPED','LOWER_DEVELOPED') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `left_right_balance` enum('BALANCED','LEFT_DOMINANT','RIGHT_DOMINANT') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `target_calories` decimal(7,2) DEFAULT NULL,
  `required_protein_g` decimal(7,2) DEFAULT NULL,
  `carb_ratio` decimal(5,2) DEFAULT NULL,
  `protein_ratio` decimal(5,2) DEFAULT NULL,
  `fat_ratio` decimal(5,2) DEFAULT NULL,
  `target_carb_kcal` decimal(7,2) DEFAULT NULL,
  `target_protein_kcal` decimal(7,2) DEFAULT NULL,
  `target_fat_kcal` decimal(7,2) DEFAULT NULL,
  `target_carb_g` decimal(7,2) DEFAULT NULL,
  `target_protein_g` decimal(7,2) DEFAULT NULL,
  `target_fat_g` decimal(7,2) DEFAULT NULL,
  `breakfast_kcal` decimal(7,2) DEFAULT NULL,
  `breakfast_carb_g` decimal(7,2) DEFAULT NULL,
  `breakfast_protein_g` decimal(7,2) DEFAULT NULL,
  `breakfast_fat_g` decimal(7,2) DEFAULT NULL,
  `lunch_kcal` decimal(7,2) DEFAULT NULL,
  `lunch_carb_g` decimal(7,2) DEFAULT NULL,
  `lunch_protein_g` decimal(7,2) DEFAULT NULL,
  `lunch_fat_g` decimal(7,2) DEFAULT NULL,
  `dinner_kcal` decimal(7,2) DEFAULT NULL,
  `dinner_carb_g` decimal(7,2) DEFAULT NULL,
  `dinner_protein_g` decimal(7,2) DEFAULT NULL,
  `dinner_fat_g` decimal(7,2) DEFAULT NULL,
  PRIMARY KEY (`inbody_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inbody`
--

LOCK TABLES `inbody` WRITE;
/*!40000 ALTER TABLE `inbody` DISABLE KEYS */;
/*!40000 ALTER TABLE `inbody` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pt_members`
--

DROP TABLE IF EXISTS `pt_members`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pt_members` (
  `contract_id` int NOT NULL AUTO_INCREMENT,
  `total_sessions` int NOT NULL DEFAULT '0',
  `job` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `consultation_date` date NOT NULL,
  `fitness_goal` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`contract_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pt_members`
--

LOCK TABLES `pt_members` WRITE;
/*!40000 ALTER TABLE `pt_members` DISABLE KEYS */;
/*!40000 ALTER TABLE `pt_members` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `selected_exercises`
--

DROP TABLE IF EXISTS `selected_exercises`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `selected_exercises` (
  `user_exercise_id` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`user_exercise_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `selected_exercises`
--

LOCK TABLES `selected_exercises` WRITE;
/*!40000 ALTER TABLE `selected_exercises` DISABLE KEYS */;
/*!40000 ALTER TABLE `selected_exercises` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_photo`
--

DROP TABLE IF EXISTS `user_photo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_photo` (
  `photo_id` int NOT NULL AUTO_INCREMENT,
  `upload_date` datetime DEFAULT NULL,
  `photo_type` enum('body','meal') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `photo_url` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`photo_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_photo`
--

LOCK TABLES `user_photo` WRITE;
/*!40000 ALTER TABLE `user_photo` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_photo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `login_id` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `password` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
  `user_name` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `phone_number` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `birthdate` date DEFAULT NULL,
  `gender` enum('male','female') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `role` enum('member','trainer') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `login_id` (`login_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `workout_log`
--

DROP TABLE IF EXISTS `workout_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `workout_log` (
  `log_id` int NOT NULL AUTO_INCREMENT,
  `log_date` date DEFAULT NULL,
  `weight` decimal(5,2) DEFAULT NULL,
  `reps` int DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `log_type` enum('NORMAL','1RM') COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`log_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `workout_log`
--

LOCK TABLES `workout_log` WRITE;
/*!40000 ALTER TABLE `workout_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `workout_log` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-08-14 10:29:03
