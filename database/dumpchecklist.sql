-- MySQL dump 10.13  Distrib 8.0.26, for Win64 (x86_64)
--
-- Host: localhost    Database: puttsportal
-- ------------------------------------------------------
-- Server version	8.0.26

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
-- Table structure for table `assignment`
--

DROP TABLE IF EXISTS `assignment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `assignment` (
  `assignmentId` int NOT NULL AUTO_INCREMENT,
  `description` text,
  `userId` int DEFAULT NULL,
  `completed` tinyint DEFAULT NULL,
  `comments` text,
  `timeCompleted` timestamp NULL DEFAULT NULL,
  `deleted` tinyint DEFAULT NULL,
  PRIMARY KEY (`assignmentId`),
  KEY `userId` (`userId`),
  CONSTRAINT `assignment_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`userID`)
) ENGINE=InnoDB AUTO_INCREMENT=116 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assignment`
--

LOCK TABLES `assignment` WRITE;
/*!40000 ALTER TABLE `assignment` DISABLE KEYS */;
INSERT INTO `assignment` VALUES (89,'Issue in temp1 for item item33: lksjaglejsalgkjesglkjeglakjasegkjeslgkjeaslgkjaselkgjelskjgleskjglksejgleskjgleksjglaksegjlkegjlkesjagkljegljeslagkjelkgjelskgjelskagjlkesjglkeasgjlkejglkagjkejkgjeslkgjeklsgjleksgjleksgjlkesjglkejglksejlkgjsegkljeslgkjlkej',8,0,'comment','2012-02-21 02:00:00',9),(90,'Issue in temp1 for item item33: lksjaglejsalgkjesglkjeglakjasegkjeslgkjeaslgkjaselkgjelskjgleskjglksejgleskjgleksjglaksegjlkegjlkesjagkljegljeslagkjelkgjelskgjelskagjlkesjglkeasgjlkejglkagjkejkgjeslkgjeklsgjleksgjleksgjlkesjglkejglksejlkgjsegkljeslgkjlkej',8,1,'comment','2012-02-21 02:00:00',9),(91,'Issue in temp1 for item item33: lksjaglejsalgkjesglkjeglakjasegkjeslgkjeaslgkjaselkgjelskjgleskjglksejgleskjgleksjglaksegjlkegjlkesjagkljegljeslagkjelkgjelskgjelskagjlkesjglkeasgjlkejglkagjkejkgjeslkgjeklsgjleksgjleksgjlkesjglkejglksejlkgjsegkljeslgkjlkej',8,1,'comment','2012-02-21 02:00:00',NULL),(92,'Issue in temp1 for item item33: lksjaglejsalgkjesglkjeglakjasegkjeslgkjeaslgkjaselkgjelskjgleskjglksejgleskjgleksjglaksegjlkegjlkesjagkljegljeslagkjelkgjelskgjelskagjlkesjglkeasgjlkejglkagjkejkgjeslkgjeklsgjleksgjleksgjlkesjglkejglksejlkgjsegkljeslgkjlkej',8,0,'comment','2012-02-21 02:00:00',NULL),(93,'Issue in temp1 for item item33: lksjaglejsalgkjesglkjeglakjasegkjeslgkjeaslgkjaselkgjelskjgleskjglksejgleskjgleksjglaksegjlkegjlkesjagkljegljeslagkjelkgjelskgjelskagjlkesjglkeasgjlkejglkagjkejkgjeslkgjeklsgjleksgjleksgjlkesjglkejglksejlkgjsegkljeslgkjlkej',8,0,NULL,NULL,0),(94,'Issue in temp1 for item item33: lksjaglejsalgkjesglkjeglakjasegkjeslgkjeaslgkjaselkgjelskjgleskjglksejgleskjgleksjglaksegjlkegjlkesjagkljegljeslagkjelkgjelskgjelskagjlkesjglkeasgjlkejglkagjkejkgjeslkgjeklsgjleksgjleksgjlkesjglkejglksejlkgjsegkljeslgkjlkej',8,0,NULL,NULL,0),(95,'Issue in temp1 for item item33: lksjaglejsalgkjesglkjeglakjasegkjeslgkjeaslgkjaselkgjelskjgleskjglksejgleskjgleksjglaksegjlkegjlkesjagkljegljeslagkjelkgjelskgjelskagjlkesjglkeasgjlkejglkagjkejkgjeslkgjeklsgjleksgjleksgjlkesjglkejglksejlkgjsegkljeslgkjlkej',8,0,NULL,NULL,0),(96,'Issue in temp1 for item item33: lksjaglejsalgkjesglkjeglakjasegkjeslgkjeaslgkjaselkgjelskjgleskjglksejgleskjgleksjglaksegjlkegjlkesjagkljegljeslagkjelkgjelskgjelskagjlkesjglkeasgjlkejglkagjkejkgjeslkgjeklsgjleksgjleksgjlkesjglkejglksejlkgjsegkljeslgkjlkej',8,0,NULL,NULL,0),(97,'Issue in temp1 for item item33: lksjaglejsalgkjesglkjeglakjasegkjeslgkjeaslgkjaselkgjelskjgleskjglksejgleskjgleksjglaksegjlkegjlkesjagkljegljeslagkjelkgjelskgjelskagjlkesjglkeasgjlkejglkagjkejkgjeslkgjeklsgjleksgjleksgjlkesjglkejglksejlkgjsegkljeslgkjlkej',8,0,NULL,NULL,0),(98,'Issue in temp1 for item item33: lksjaglejsalgkjesglkjeglakjasegkjeslgkjeaslgkjaselkgjelskjgleskjglksejgleskjgleksjglaksegjlkegjlkesjagkljegljeslagkjelkgjelskgjelskagjlkesjglkeasgjlkejglkagjkejkgjeslkgjeklsgjleksgjleksgjlkesjglkejglksejlkgjsegkljeslgkjlkej',8,0,NULL,NULL,0),(99,'Issue in temp1 for item item33: lksjaglejsalgkjesglkjeglakjasegkjeslgkjeaslgkjaselkgjelskjgleskjglksejgleskjgleksjglaksegjlkegjlkesjagkljegljeslagkjelkgjelskgjelskagjlkesjglkeasgjlkejglkagjkejkgjeslkgjeklsgjleksgjleksgjlkesjglkejglksejlkgjsegkljeslgkjlkej',8,0,NULL,NULL,0),(100,'Issue in temp1 for item item33: lksjaglejsalgkjesglkjeglakjasegkjeslgkjeaslgkjaselkgjelskjgleskjglksejgleskjgleksjglaksegjlkegjlkesjagkljegljeslagkjelkgjelskgjelskagjlkesjglkeasgjlkejglkagjkejkgjeslkgjeklsgjleksgjleksgjlkesjglkejglksejlkgjsegkljeslgkjlkej',8,0,NULL,NULL,0),(101,'Issue in temp1 for item item33: lksjaglejsalgkjesglkjeglakjasegkjeslgkjeaslgkjaselkgjelskjgleskjglksejgleskjgleksjglaksegjlkegjlkesjagkljegljeslagkjelkgjelskgjelskagjlkesjglkeasgjlkejglkagjkejkgjeslkgjeklsgjleksgjleksgjlkesjglkejglksejlkgjsegkljeslgkjlkej',8,0,NULL,NULL,0),(102,'Issue in temp1 for item item33: lksjaglejsalgkjesglkjeglakjasegkjeslgkjeaslgkjaselkgjelskjgleskjglksejgleskjgleksjglaksegjlkegjlkesjagkljegljeslagkjelkgjelskgjelskagjlkesjglkeasgjlkejglkagjkejkgjeslkgjeklsgjleksgjleksgjlkesjglkejglksejlkgjsegkljeslgkjlkej',8,0,NULL,NULL,0),(103,'Issue in temp1 for item item33: lksjaglejsalgkjesglkjeglakjasegkjeslgkjeaslgkjaselkgjelskjgleskjglksejgleskjgleksjglaksegjlkegjlkesjagkljegljeslagkjelkgjelskgjelskagjlkesjglkeasgjlkejglkagjkejkgjeslkgjeklsgjleksgjleksgjlkesjglkejglksejlkgjsegkljeslgkjlkej',8,0,NULL,NULL,0),(104,'Issue in temp1 for item item33: lksjaglejsalgkjesglkjeglakjasegkjeslgkjeaslgkjaselkgjelskjgleskjglksejgleskjgleksjglaksegjlkegjlkesjagkljegljeslagkjelkgjelskgjelskagjlkesjglkeasgjlkejglkagjkejkgjeslkgjeklsgjleksgjleksgjlkesjglkejglksejlkgjsegkljeslgkjlkej',8,0,NULL,NULL,0),(105,'Issue in temp1 for item item33: lksjaglejsalgkjesglkjeglakjasegkjeslgkjeaslgkjaselkgjelskjgleskjglksejgleskjgleksjglaksegjlkegjlkesjagkljegljeslagkjelkgjelskgjelskagjlkesjglkeasgjlkejglkagjkejkgjeslkgjeklsgjleksgjleksgjlkesjglkejglksejlkgjsegkljeslgkjlkej',8,0,NULL,NULL,0),(106,'Issue in temp1 for item item33: lksjaglejsalgkjesglkjeglakjasegkjeslgkjeaslgkjaselkgjelskjgleskjglksejgleskjgleksjglaksegjlkegjlkesjagkljegljeslagkjelkgjelskgjelskagjlkesjglkeasgjlkejglkagjkejkgjeslkgjeklsgjleksgjleksgjlkesjglkejglksejlkgjsegkljeslgkjlkej',8,0,NULL,NULL,0),(107,'Issue in temp1 for item item33: lksjaglejsalgkjesglkjeglakjasegkjeslgkjeaslgkjaselkgjelskjgleskjglksejgleskjgleksjglaksegjlkegjlkesjagkljegljeslagkjelkgjelskgjelskagjlkesjglkeasgjlkejglkagjkejkgjeslkgjeklsgjleksgjleksgjlkesjglkejglksejlkgjsegkljeslgkjlkej',8,0,NULL,NULL,0),(108,'Issue in temp1 for item item33: lksjaglejsalgkjesglkjeglakjasegkjeslgkjeaslgkjaselkgjelskjgleskjglksejgleskjgleksjglaksegjlkegjlkesjagkljegljeslagkjelkgjelskgjelskagjlkesjglkeasgjlkejglkagjkejkgjeslkgjeklsgjleksgjleksgjlkesjglkejglksejlkgjsegkljeslgkjlkej',8,0,NULL,NULL,0),(109,'Issue in temp1 for item item33: lksjaglejsalgkjesglkjeglakjasegkjeslgkjeaslgkjaselkgjelskjgleskjglksejgleskjgleksjglaksegjlkegjlkesjagkljegljeslagkjelkgjelskgjelskagjlkesjglkeasgjlkejglkagjkejkgjeslkgjeklsgjleksgjleksgjlkesjglkejglksejlkgjsegkljeslgkjlkej',8,0,NULL,NULL,0),(110,'Issue in temp1 for item item33: lksjaglejsalgkjesglkjeglakjasegkjeslgkjeaslgkjaselkgjelskjgleskjglksejgleskjgleksjglaksegjlkegjlkesjagkljegljeslagkjelkgjelskgjelskagjlkesjglkeasgjlkejglkagjkejkgjeslkgjeklsgjleksgjleksgjlkesjglkejglksejlkgjsegkljeslgkjlkej',8,0,NULL,NULL,0),(111,'Issue in temp1 for item item33: lksjaglejsalgkjesglkjeglakjasegkjeslgkjeaslgkjaselkgjelskjgleskjglksejgleskjgleksjglaksegjlkegjlkesjagkljegljeslagkjelkgjelskgjelskagjlkesjglkeasgjlkejglkagjkejkgjeslkgjeklsgjleksgjleksgjlkesjglkejglksejlkgjsegkljeslgkjlkej',8,0,NULL,NULL,0),(112,'Issue in temp1 for item item33: lksjaglejsalgkjesglkjeglakjasegkjeslgkjeaslgkjaselkgjelskjgleskjglksejgleskjgleksjglaksegjlkegjlkesjagkljegljeslagkjelkgjelskgjelskagjlkesjglkeasgjlkejglkagjkejkgjeslkgjeklsgjleksgjleksgjlkesjglkejglksejlkgjsegkljeslgkjlkej',8,0,NULL,NULL,0),(113,'Issue in temp1 for item item33: lksjaglejsalgkjesglkjeglakjasegkjeslgkjeaslgkjaselkgjelskjgleskjglksejgleskjgleksjglaksegjlkegjlkesjagkljegljeslagkjelkgjelskgjelskagjlkesjglkeasgjlkejglkagjkejkgjeslkgjeklsgjleksgjleksgjlkesjglkejglksejlkgjsegkljeslgkjlkej',8,0,NULL,NULL,0),(114,'Issue in temp1 for item item33: lksjaglejsalgkjesglkjeglakjasegkjeslgkjeaslgkjaselkgjelskjgleskjglksejgleskjgleksjglaksegjlkegjlkesjagkljegljeslagkjelkgjelskgjelskagjlkesjglkeasgjlkejglkagjkejkgjeslkgjeklsgjleksgjleksgjlkesjglkejglksejlkgjsegkljeslgkjlkej',8,0,NULL,NULL,0),(115,'Issue in temp1 for item item33: lksjaglejsalgkjesglkjeglakjasegkjeslgkjeaslgkjaselkgjelskjgleskjglksejgleskjgleksjglaksegjlkegjlkesjagkljegljeslagkjelkgjelskgjelskagjlkesjglkeasgjlkejglkagjkejkgjeslkgjeklsgjleksgjleksgjlkesjglkejglksejlkgjsegkljeslgkjlkej',8,0,NULL,NULL,0);
/*!40000 ALTER TABLE `assignment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `barcode`
--

DROP TABLE IF EXISTS `barcode`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `barcode` (
  `barcodeId` int NOT NULL AUTO_INCREMENT,
  `barcodeValue` text,
  `location` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`barcodeId`)
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `barcode`
--

LOCK TABLES `barcode` WRITE;
/*!40000 ALTER TABLE `barcode` DISABLE KEYS */;
INSERT INTO `barcode` VALUES (25,'fafea','MESA'),(26,'hasehasehas','MESA'),(39,'caf','MESA'),(40,'brat','MESA'),(46,'ggeasgeag','MESA'),(48,'gfeasgea','MESA'),(50,'gaseggesag','MESA'),(51,'gagasegeas','MESA'),(52,'heaheashaes','MESA'),(53,'gesagase','MESA'),(54,'heaheashe','MESA'),(55,'geageas','MESA'),(56,'gesages','MESA'),(57,'gesagaes','MESA'),(58,'gasgeagaes','MESA'),(59,'gesagaesgea','MESA'),(60,'fesfe','MESA');
/*!40000 ALTER TABLE `barcode` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chatinstance`
--

DROP TABLE IF EXISTS `chatinstance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chatinstance` (
  `chatInstanceId` int NOT NULL AUTO_INCREMENT,
  `users` varchar(100) DEFAULT NULL,
  `delete` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`chatInstanceId`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chatinstance`
--

LOCK TABLES `chatinstance` WRITE;
/*!40000 ALTER TABLE `chatinstance` DISABLE KEYS */;
INSERT INTO `chatinstance` VALUES (24,'8, 9','NaN'),(25,'8, 11','none');
/*!40000 ALTER TABLE `chatinstance` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chatmessage`
--

DROP TABLE IF EXISTS `chatmessage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chatmessage` (
  `chatMessageId` int NOT NULL AUTO_INCREMENT,
  `chatMessage` text,
  `chatInstanceId` int DEFAULT NULL,
  `senderId` int DEFAULT NULL,
  `receiverId` int DEFAULT NULL,
  PRIMARY KEY (`chatMessageId`),
  KEY `chatInstanceId` (`chatInstanceId`),
  KEY `senderId` (`senderId`),
  KEY `receiverId` (`receiverId`),
  CONSTRAINT `chatmessage_ibfk_1` FOREIGN KEY (`chatInstanceId`) REFERENCES `chatinstance` (`chatInstanceId`),
  CONSTRAINT `chatmessage_ibfk_2` FOREIGN KEY (`senderId`) REFERENCES `users` (`userID`),
  CONSTRAINT `chatmessage_ibfk_3` FOREIGN KEY (`receiverId`) REFERENCES `users` (`userID`)
) ENGINE=InnoDB AUTO_INCREMENT=357 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chatmessage`
--

LOCK TABLES `chatmessage` WRITE;
/*!40000 ALTER TABLE `chatmessage` DISABLE KEYS */;
INSERT INTO `chatmessage` VALUES (236,'tes',24,9,8),(237,'tes',24,8,9),(238,'tes',24,9,8),(239,'te',24,8,9),(240,'best',24,8,9),(241,'rest',24,9,8),(242,'tes',24,9,8),(243,'bestie i need you',24,9,8),(244,'okay',24,9,8),(245,'duh',24,8,9),(246,'so whats the deal',24,8,9),(247,'geagea',24,8,9),(248,'geage',24,8,9),(249,'heashea',24,8,9),(250,'i need you right now ',24,8,9),(251,'if you don\'t show up im going to pass out and we will never be able to do this agian',24,8,9),(252,'if you don\'t show up im goin to pass out and we will never be able to do this again for sure in the wold of huner',24,8,9),(253,'geasge',24,8,9),(254,'tesatea',24,9,8),(255,'tesa',24,9,8),(256,'ygeae',24,9,8),(257,'geasgeas',24,9,8),(258,'beagesaha',24,9,8),(259,'test',24,9,8),(260,'bam',24,9,8),(261,'tes',24,9,8),(262,'tesat',24,9,8),(263,'tes',24,8,9),(264,'repeat',24,8,9),(265,'tes',24,9,8),(266,'wait thats weired',24,9,8),(267,'what is going on',24,9,8),(268,'test',24,9,8),(269,'yo',24,9,8),(270,'best',24,9,8),(271,'esba',24,9,8),(272,'trying',24,9,8),(273,'br',24,9,8),(274,'test',24,9,8),(275,'test',24,9,8),(276,'i need',24,8,9),(277,'the thing',24,8,9),(278,'but',24,8,9),(279,'tes',24,8,9),(280,'gea',24,8,9),(281,'tet',24,8,9),(282,'hea',24,8,9),(283,'tes',24,8,9),(284,'hesa',24,8,9),(285,'heah',24,8,9),(286,'heasheasa',24,8,9),(287,'tes',24,8,9),(288,'byt',24,8,9),(289,'briliant',24,8,9),(290,'geae',24,8,9),(291,'tst',24,8,9),(292,'hesah',24,8,9),(293,'geageas',24,8,9),(294,'hea',24,8,9),(295,'heahj',24,8,9),(296,'test',24,8,9),(297,'baya',24,8,9),(298,'besag',24,8,9),(299,'heahes',24,8,9),(300,'he',24,8,9),(301,'h',24,8,9),(302,'gese',24,8,9),(303,'gesa',24,8,9),(304,'hfhfd',24,8,9),(305,'hesae',24,8,9),(306,'hesa',24,8,9),(307,'hdhrd',24,8,9),(308,'hrd',24,8,9),(309,'gesges',24,8,9),(310,'ghg',24,8,9),(311,'hesa',24,8,9),(312,'tete',24,8,9),(313,'teasteastaes',24,8,9),(314,'hhrsrhds',24,8,9),(315,'hdhrdshrdshr',24,8,9),(316,'hrdshrsd',24,8,9),(317,'jfjfgjyf',24,8,9),(318,'gesageas',24,8,9),(319,'but theshark whale',24,8,9),(320,'test',24,8,9),(321,'heas',24,8,9),(322,'test',24,8,9),(323,'hesa',24,8,9),(324,'bes',24,8,9),(325,'rest',24,9,8),(326,'test',24,9,8),(327,'best',24,9,8),(328,'test',24,9,8),(329,'test',24,9,8),(330,'beaheshase',24,9,8),(331,'teast',24,9,8),(332,'bes',24,9,8),(333,'test',24,9,8),(334,'esaeg',24,9,8),(335,'hesa',24,9,8),(336,'tes',24,9,8),(337,'test',24,9,8),(338,'eage',24,9,8),(339,'tes',24,9,8),(340,'test',24,9,8),(341,'test',24,9,8),(342,'test',24,9,8),(343,'test',24,9,8),(344,'gae',24,9,8),(345,'test',24,9,8),(346,'ga',24,9,8),(347,'test',24,9,8),(348,'ga',24,9,8),(349,'test',24,9,8),(350,'rest',24,9,8),(351,'june',24,8,9),(352,'besag',24,8,9),(353,'gesag',24,8,9),(354,'hey',25,8,11),(355,'test',24,9,8),(356,'fesaglekjglseakgjeaslgkjaselgkjsealgjselakgjaselgjlesajglesaglasjlgjelgjlagjlkejlgjklesageasgesgasegea',24,9,8);
/*!40000 ALTER TABLE `chatmessage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `checklistinstance`
--

DROP TABLE IF EXISTS `checklistinstance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `checklistinstance` (
  `instanceId` int NOT NULL AUTO_INCREMENT,
  `templateId` int DEFAULT NULL,
  `userId` int DEFAULT NULL,
  `completed` bit(1) DEFAULT NULL,
  `startTime` timestamp NULL DEFAULT NULL,
  `endTime` timestamp NULL DEFAULT NULL,
  `deadline` timestamp NULL DEFAULT NULL,
  `signed` bit(1) DEFAULT NULL,
  `assignedTo` int DEFAULT NULL,
  `timeCreated` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`instanceId`),
  KEY `templateId` (`templateId`),
  KEY `userId` (`userId`),
  KEY `assignedTo` (`assignedTo`),
  CONSTRAINT `checklistinstance_ibfk_1` FOREIGN KEY (`templateId`) REFERENCES `checklisttemplate` (`templateId`) ON DELETE CASCADE,
  CONSTRAINT `checklistinstance_ibfk_2` FOREIGN KEY (`userId`) REFERENCES `users` (`userID`) ON DELETE CASCADE,
  CONSTRAINT `checklistinstance_ibfk_3` FOREIGN KEY (`assignedTo`) REFERENCES `users` (`userID`)
) ENGINE=InnoDB AUTO_INCREMENT=615 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `checklistinstance`
--

LOCK TABLES `checklistinstance` WRITE;
/*!40000 ALTER TABLE `checklistinstance` DISABLE KEYS */;
INSERT INTO `checklistinstance` VALUES (604,223,9,_binary '','2022-03-24 02:15:05','2022-03-31 00:21:33','2022-03-24 02:13:00',_binary '',9,'2022-03-24 02:13:11'),(605,224,9,_binary '\0','2022-03-31 21:08:15',NULL,'2022-03-24 02:13:00',NULL,9,'2022-03-24 02:13:34'),(606,225,9,_binary '\0','2022-03-31 00:22:56',NULL,'2022-03-24 02:13:00',NULL,9,'2022-03-24 02:13:42'),(607,226,9,_binary '\0',NULL,NULL,'2022-03-24 02:13:00',NULL,NULL,'2022-03-24 02:13:49'),(608,227,9,_binary '\0',NULL,NULL,'2022-03-24 02:13:00',NULL,NULL,'2022-03-24 02:13:58'),(609,228,9,_binary '\0',NULL,NULL,'2022-03-24 02:14:00',NULL,NULL,'2022-03-24 02:14:06'),(610,229,9,_binary '\0',NULL,NULL,'2022-03-24 02:14:00',NULL,NULL,'2022-03-24 02:14:15'),(611,230,9,_binary '\0',NULL,NULL,'2022-03-24 02:14:00',NULL,NULL,'2022-03-24 02:14:23'),(612,231,9,_binary '\0',NULL,NULL,'2022-03-24 02:14:00',NULL,NULL,'2022-03-24 02:14:31'),(613,232,9,_binary '\0',NULL,NULL,'2022-03-24 02:14:00',NULL,NULL,'2022-03-24 02:14:39'),(614,233,9,_binary '\0','2022-03-31 21:09:47',NULL,'2022-03-31 21:09:00',NULL,9,'2022-03-31 21:09:31');
/*!40000 ALTER TABLE `checklistinstance` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `checklistinstanceitem`
--

DROP TABLE IF EXISTS `checklistinstanceitem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `checklistinstanceitem` (
  `instanceItemId` int NOT NULL AUTO_INCREMENT,
  `instanceId` int DEFAULT NULL,
  `itemId` int DEFAULT NULL,
  `startTime` datetime DEFAULT NULL,
  `endTime` datetime DEFAULT NULL,
  `shortResponse` text,
  `longResponse` text,
  `scanned` bit(1) DEFAULT NULL,
  `timeCompleted` timestamp NULL DEFAULT NULL,
  `yes/no` tinyint(1) DEFAULT NULL,
  `completed` bit(1) DEFAULT NULL,
  `issue` text,
  PRIMARY KEY (`instanceItemId`),
  KEY `instanceId` (`instanceId`),
  KEY `itemId` (`itemId`),
  CONSTRAINT `checklistinstanceitem_ibfk_1` FOREIGN KEY (`instanceId`) REFERENCES `checklistinstance` (`instanceId`),
  CONSTRAINT `checklistinstanceitem_ibfk_2` FOREIGN KEY (`itemId`) REFERENCES `checklistitem` (`itemId`)
) ENGINE=InnoDB AUTO_INCREMENT=1272 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `checklistinstanceitem`
--

LOCK TABLES `checklistinstanceitem` WRITE;
/*!40000 ALTER TABLE `checklistinstanceitem` DISABLE KEYS */;
INSERT INTO `checklistinstanceitem` VALUES (1071,604,407,NULL,NULL,NULL,NULL,_binary '\0',NULL,0,_binary '','tes'),(1072,604,406,NULL,NULL,NULL,NULL,_binary '\0',NULL,1,_binary '','tes'),(1073,604,412,NULL,NULL,NULL,NULL,_binary '\0',NULL,1,_binary '','tes'),(1074,604,413,NULL,NULL,NULL,NULL,_binary '\0',NULL,0,_binary '','tes'),(1075,604,414,NULL,NULL,NULL,NULL,_binary '\0',NULL,1,_binary '','tes'),(1076,604,418,NULL,NULL,NULL,NULL,_binary '\0',NULL,1,_binary '','tes'),(1077,604,415,NULL,NULL,NULL,NULL,_binary '\0',NULL,0,_binary '','tes'),(1078,604,417,NULL,NULL,NULL,NULL,_binary '\0',NULL,0,_binary '','tes'),(1079,604,419,NULL,NULL,NULL,NULL,_binary '\0',NULL,0,_binary '',NULL),(1080,604,416,NULL,NULL,NULL,NULL,_binary '\0',NULL,1,_binary '','tes'),(1081,604,420,NULL,NULL,NULL,NULL,_binary '\0',NULL,1,_binary '','tes'),(1082,604,421,NULL,NULL,NULL,NULL,_binary '\0',NULL,0,_binary '','tes'),(1083,604,422,NULL,NULL,NULL,NULL,_binary '\0',NULL,1,_binary '','tes'),(1084,604,423,NULL,NULL,NULL,NULL,_binary '\0',NULL,0,_binary '','tes'),(1085,604,424,NULL,NULL,NULL,NULL,_binary '\0',NULL,1,_binary '','feflkasejflsejflsekjfselakfjelaskfjlseakfjselkfjelskfjlsejflksejflsekjflkejflkejflksejflkejflksejflksejfleskjfleksjflsekjflkejgfaesgesgaegegaegeagegeseflkasejflsejflsekjfselakfjelaskfjlseakfjselkfjelskfjlsejflksejflsekjflkejflkejflksejflkejflksejflksejfleskjfleksjflsekjflkejgfaesgesgaegegaegeagegeeflkasejflsejflsekjfselakfjelaskfjlseakfjselkfjelskfjlsejflksejflsekjflkejflkejflksejflkejflksejflksejfleskjfleksjflsekjflkejgfaesgesgaegegaegeagegeeflkasejflsejflsekjfselakfjelaskfjlseakfjselkfjelskfjlsejflksejflsekjflkejflkejflksejflkejflksejflksejfleskjfleksjflsekjflkejgfaesgesgaegegaegeagegeeflkasejflsejflsekjfselakfjelaskfjlseakfjselkfjelskfjlsejflksejflsekjflkejflkejflksejflkejflksejflksejfleskjfleksjflsekjflkejgfaesgesgaegegaegeagege'),(1086,604,425,NULL,NULL,NULL,NULL,_binary '\0',NULL,1,_binary '','fesafasef;easjkfe;aslkg;elaskg;ljas;elkt;lkase;lk;lhkeaeflkasejflsejflsekjfselakfjelaskfjlseakfjselkfjelskfjlsejflksejflsekjflkejflkejflksejflkejflksejflksejfleskjfleksjflsekjflkejgfaesgesgaegegaegeagegeeflkasejflsejflsekjfselakfjelaskfjlseakfjselkfjelskfjlsejflksejflsekjflkejflkejflksejflkejflksejflksejfleskjfleksjflsekjflkejgfaesgesgaegegaegeagegeeflkasejflsejflsekjfselakfjelaskfjlseakfjselkfjelskfjlsejflksejflsekjflkejflkejflksejflkejflksejflksejfleskjfleksjflsekjflkejgfaesgesgaegegaegeagegeeflkasejflsejflsekjfselakfjelaskfjlseakfjselkfjelskfjlsejflksejflsekjflkejflkejflksejflkejflksejflksejfleskjfleksjflsekjflkejgfaesgesgaegegaegeagegeeflkasejflsejflsekjfselakfjelaskfjlseakfjselkfjelskfjlsejflksejflsekjflkejflkejflksejflkejflksejflksejfleskjfleksjflsekjflkejgfaesgesgaegegaegeagegeeflkasejflsejflsekjfselakfjelaskfjlseakfjselkfjelskfjlsejflksejflsekjflkejflkejflksejflkejflksejflksejfleskjfleksjflsekjflkejgfaesgesgaegegaegeagegeeflkasejflsejflsekjfselakfjelaskfjlseakfjselkfjelskfjlsejflksejflsekjflkejflkejflksejflkejflksejflksejfleskjfleksjflsekjflkejgfaesgesgaegegaegeagege'),(1087,604,408,NULL,NULL,NULL,NULL,_binary '\0',NULL,1,_binary '','tes'),(1088,604,409,NULL,NULL,NULL,NULL,_binary '\0',NULL,0,_binary '','tes'),(1089,604,410,NULL,NULL,NULL,NULL,_binary '\0',NULL,1,_binary '','tes'),(1090,604,411,NULL,NULL,NULL,NULL,_binary '\0',NULL,0,_binary '','tes'),(1091,605,434,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1092,605,435,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1093,605,426,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1094,605,427,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1095,605,428,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1096,605,429,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1097,605,430,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1098,605,431,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1099,605,432,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1100,605,433,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1101,605,436,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1102,605,437,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1103,605,438,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1104,605,439,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1105,605,440,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1106,605,441,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1107,605,442,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1108,605,443,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1109,605,444,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1110,605,445,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1111,606,452,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1112,606,453,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1113,606,454,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1114,606,446,NULL,NULL,NULL,NULL,_binary '\0',NULL,1,_binary '','eflkasejflsejflsekjfselakfjelaskfjlseakfjselkfjelskfjlsejflksejflsekjflkejflkejflksejflkejflksejflksejfleskjfleksjflsekjflkejgfaesgesgaegegaegeagegeeflkasejflsejflsekjfselakfjelaskfjlseakfjselkfjelskfjlsejflksejflsekjflkejflkejflksejflkejflksejflksejfleskjfleksjflsekjflkejgfaesgesgaegegaegeagegeeflkasejflsejflsekjfselakfjelaskfjlseakfjselkfjelskfjlsejflksejflsekjflkejflkejflksejflkejflksejflksejfleskjfleksjflsekjflkejgfaesgesgaegegaegeagegeeflkasejflsejflsekjfselakfjelaskfjlseakfjselkfjelskfjlsejflksejflsekjflkejflkejflksejflkejflksejflksejfleskjfleksjflsekjflkejgfaesgesgaegegaegeagegeeflkasejflsejflsekjfselakfjelaskfjlseakfjselkfjelskfjlsejflksejflsekjflkejflkejflksejflkejflksejflksejfleskjfleksjflsekjflkejgfaesgesgaegegaegeagegeeflkasejflsejflsekjfselakfjelaskfjlseakfjselkfjelskfjlsejflksejflsekjflkejflkejflksejflkejflksejflksejfleskjfleksjflsekjflkejgfaesgesgaegegaegeagege'),(1115,606,447,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1116,606,448,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1117,606,449,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1118,606,450,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1119,606,451,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1120,606,455,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1121,606,456,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1122,606,457,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1123,606,458,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1124,606,459,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1125,606,460,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1126,606,461,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1127,606,462,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1128,606,463,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1129,606,464,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1130,606,465,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1131,607,473,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1132,607,474,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1133,607,475,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1134,607,466,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1135,607,467,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1136,607,468,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1137,607,469,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1138,607,470,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1139,607,471,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1140,607,472,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1141,607,476,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1142,607,477,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1143,607,478,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1144,607,479,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1145,607,480,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1146,607,481,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1147,607,482,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1148,607,483,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1149,607,484,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1150,607,485,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1151,608,494,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1152,608,486,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1153,608,487,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1154,608,488,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1155,608,489,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1156,608,490,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1157,608,491,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1158,608,492,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1159,608,493,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1160,608,495,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1161,608,496,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1162,608,497,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1163,608,498,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1164,608,499,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1165,608,500,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1166,608,501,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1167,608,502,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1168,608,503,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1169,608,504,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1170,608,505,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1171,609,512,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1172,609,513,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1173,609,506,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1174,609,507,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1175,609,508,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1176,609,509,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1177,609,510,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1178,609,511,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1179,609,514,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1180,609,515,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1181,609,516,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1182,609,517,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1183,609,518,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1184,609,519,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1185,609,520,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1186,609,521,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1187,609,522,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1188,609,523,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1189,609,524,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1190,609,525,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1191,610,534,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1192,610,526,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1193,610,527,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1194,610,528,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1195,610,529,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1196,610,530,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1197,610,531,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1198,610,532,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1199,610,533,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1200,610,535,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1201,610,536,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1202,610,537,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1203,610,538,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1204,610,539,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1205,610,540,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1206,610,541,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1207,610,542,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1208,610,543,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1209,610,544,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1210,610,545,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1211,611,552,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1212,611,553,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1213,611,546,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1214,611,547,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1215,611,548,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1216,611,549,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1217,611,550,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1218,611,551,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1219,611,554,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1220,611,555,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1221,611,556,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1222,611,557,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1223,611,558,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1224,611,559,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1225,611,560,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1226,611,561,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1227,611,562,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1228,611,563,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1229,611,564,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1230,611,565,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1231,612,572,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1232,612,573,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1233,612,574,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1234,612,575,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1235,612,566,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1236,612,567,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1237,612,568,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1238,612,569,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1239,612,570,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1240,612,571,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1241,612,576,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1242,612,577,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1243,612,578,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1244,612,579,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1245,612,580,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1246,612,581,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1247,612,582,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1248,612,583,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1249,612,584,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1250,612,585,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1251,613,595,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1252,613,586,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1253,613,587,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1254,613,588,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1255,613,589,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1256,613,590,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1257,613,591,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1258,613,592,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1259,613,593,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1260,613,594,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1261,613,596,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1262,613,597,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1263,613,598,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1264,613,599,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1265,613,600,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1266,613,601,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1267,613,602,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1268,613,603,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1269,613,604,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1270,613,605,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL),(1271,614,606,NULL,NULL,NULL,NULL,_binary '\0',NULL,NULL,_binary '\0',NULL);
/*!40000 ALTER TABLE `checklistinstanceitem` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `checklistitem`
--

DROP TABLE IF EXISTS `checklistitem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `checklistitem` (
  `itemId` int NOT NULL AUTO_INCREMENT,
  `itemName` varchar(255) DEFAULT NULL,
  `templateId` int DEFAULT NULL,
  `itemType` varchar(50) DEFAULT NULL,
  `barcodeId` int DEFAULT NULL,
  `triggerIds` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`itemId`),
  KEY `templateId` (`templateId`),
  KEY `barcodeId` (`barcodeId`),
  CONSTRAINT `checklistitem_ibfk_1` FOREIGN KEY (`templateId`) REFERENCES `checklisttemplate` (`templateId`),
  CONSTRAINT `checklistitem_ibfk_2` FOREIGN KEY (`barcodeId`) REFERENCES `barcode` (`barcodeId`)
) ENGINE=InnoDB AUTO_INCREMENT=607 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `checklistitem`
--

LOCK TABLES `checklistitem` WRITE;
/*!40000 ALTER TABLE `checklistitem` DISABLE KEYS */;
INSERT INTO `checklistitem` VALUES (406,'item1',223,'yes/no',NULL,'8, 9'),(407,'item2',223,'yes/no',NULL,'8, 9'),(408,'item3',223,'yes/no',NULL,'8, 9'),(409,'item4',223,'yes/no',NULL,'8, 9'),(410,'item5',223,'yes/no',NULL,'8, 9'),(411,'item6',223,'yes/no',NULL,'8, 9'),(412,'item7',223,'yes/no',NULL,'8, 9'),(413,'item8',223,'yes/no',NULL,'8, 9'),(414,'item9',223,'yes/no',NULL,'8, 9'),(415,'item10',223,'yes/no',NULL,'8, 9'),(416,'item11',223,'yes/no',NULL,'8, 9'),(417,'item12',223,'yes/no',NULL,'8, 9'),(418,'item13',223,'yes/no',NULL,'8, 9'),(419,'item14',223,'yes/no',NULL,'8, 9'),(420,'item15',223,'yes/no',NULL,'8, 9'),(421,'item16',223,'yes/no',NULL,'8, 9'),(422,'item17',223,'yes/no',NULL,'8, 9'),(423,'item18',223,'yes/no',NULL,'8, 9'),(424,'item19',223,'yes/no',NULL,'8, 9'),(425,'item20',223,'yes/no',NULL,'8, 9'),(426,'item1',224,'yes/no',NULL,'8, 9'),(427,'item2',224,'yes/no',NULL,'8, 9'),(428,'item3',224,'yes/no',NULL,'8, 9'),(429,'item4',224,'yes/no',NULL,'8, 9'),(430,'item5',224,'yes/no',NULL,'8, 9'),(431,'item6',224,'yes/no',NULL,'8, 9'),(432,'item7',224,'yes/no',NULL,'8, 9'),(433,'item8',224,'yes/no',NULL,'8, 9'),(434,'item9',224,'yes/no',NULL,'8, 9'),(435,'item10',224,'yes/no',NULL,'8, 9'),(436,'item11',224,'yes/no',NULL,'8, 9'),(437,'item12',224,'yes/no',NULL,'8, 9'),(438,'item13',224,'yes/no',NULL,'8, 9'),(439,'item14',224,'yes/no',NULL,'8, 9'),(440,'item15',224,'yes/no',NULL,'8, 9'),(441,'item16',224,'yes/no',NULL,'8, 9'),(442,'item17',224,'yes/no',NULL,'8, 9'),(443,'item18',224,'yes/no',NULL,'8, 9'),(444,'item19',224,'yes/no',NULL,'8, 9'),(445,'item20',224,'yes/no',NULL,'8, 9'),(446,'item1',225,'yes/no',NULL,'8, 9'),(447,'item2',225,'yes/no',NULL,'8, 9'),(448,'item3',225,'yes/no',NULL,'8, 9'),(449,'item4',225,'yes/no',NULL,'8, 9'),(450,'item5',225,'yes/no',NULL,'8, 9'),(451,'item6',225,'yes/no',NULL,'8, 9'),(452,'item7',225,'yes/no',NULL,'8, 9'),(453,'item8',225,'yes/no',NULL,'8, 9'),(454,'item9',225,'yes/no',NULL,'8, 9'),(455,'item10',225,'yes/no',NULL,'8, 9'),(456,'item11',225,'yes/no',NULL,'8, 9'),(457,'item12',225,'yes/no',NULL,'8, 9'),(458,'item13',225,'yes/no',NULL,'8, 9'),(459,'item14',225,'yes/no',NULL,'8, 9'),(460,'item15',225,'yes/no',NULL,'8, 9'),(461,'item16',225,'yes/no',NULL,'8, 9'),(462,'item17',225,'yes/no',NULL,'8, 9'),(463,'item18',225,'yes/no',NULL,'8, 9'),(464,'item19',225,'yes/no',NULL,'8, 9'),(465,'item20',225,'yes/no',NULL,'8, 9'),(466,'item1',226,'yes/no',NULL,'8, 9'),(467,'item2',226,'yes/no',NULL,'8, 9'),(468,'item3',226,'yes/no',NULL,'8, 9'),(469,'item4',226,'yes/no',NULL,'8, 9'),(470,'item5',226,'yes/no',NULL,'8, 9'),(471,'item6',226,'yes/no',NULL,'8, 9'),(472,'item7',226,'yes/no',NULL,'8, 9'),(473,'item8',226,'yes/no',NULL,'8, 9'),(474,'item9',226,'yes/no',NULL,'8, 9'),(475,'item10',226,'yes/no',NULL,'8, 9'),(476,'item11',226,'yes/no',NULL,'8, 9'),(477,'item12',226,'yes/no',NULL,'8, 9'),(478,'item13',226,'yes/no',NULL,'8, 9'),(479,'item14',226,'yes/no',NULL,'8, 9'),(480,'item15',226,'yes/no',NULL,'8, 9'),(481,'item16',226,'yes/no',NULL,'8, 9'),(482,'item17',226,'yes/no',NULL,'8, 9'),(483,'item18',226,'yes/no',NULL,'8, 9'),(484,'item19',226,'yes/no',NULL,'8, 9'),(485,'item20',226,'yes/no',NULL,'8, 9'),(486,'item1',227,'yes/no',NULL,'8, 9'),(487,'item2',227,'yes/no',NULL,'8, 9'),(488,'item3',227,'yes/no',NULL,'8, 9'),(489,'item4',227,'yes/no',NULL,'8, 9'),(490,'item5',227,'yes/no',NULL,'8, 9'),(491,'item6',227,'yes/no',NULL,'8, 9'),(492,'item7',227,'yes/no',NULL,'8, 9'),(493,'item8',227,'yes/no',NULL,'8, 9'),(494,'item9',227,'yes/no',NULL,'8, 9'),(495,'item10',227,'yes/no',NULL,'8, 9'),(496,'item11',227,'yes/no',NULL,'8, 9'),(497,'item12',227,'yes/no',NULL,'8, 9'),(498,'item13',227,'yes/no',NULL,'8, 9'),(499,'item14',227,'yes/no',NULL,'8, 9'),(500,'item15',227,'yes/no',NULL,'8, 9'),(501,'item16',227,'yes/no',NULL,'8, 9'),(502,'item17',227,'yes/no',NULL,'8, 9'),(503,'item18',227,'yes/no',NULL,'8, 9'),(504,'item19',227,'yes/no',NULL,'8, 9'),(505,'item20',227,'yes/no',NULL,'8, 9'),(506,'item1',228,'yes/no',NULL,'8, 9'),(507,'item2',228,'yes/no',NULL,'8, 9'),(508,'item3',228,'yes/no',NULL,'8, 9'),(509,'item4',228,'yes/no',NULL,'8, 9'),(510,'item5',228,'yes/no',NULL,'8, 9'),(511,'item6',228,'yes/no',NULL,'8, 9'),(512,'item7',228,'yes/no',NULL,'8, 9'),(513,'item8',228,'yes/no',NULL,'8, 9'),(514,'item9',228,'yes/no',NULL,'8, 9'),(515,'item10',228,'yes/no',NULL,'8, 9'),(516,'item11',228,'yes/no',NULL,'8, 9'),(517,'item12',228,'yes/no',NULL,'8, 9'),(518,'item13',228,'yes/no',NULL,'8, 9'),(519,'item14',228,'yes/no',NULL,'8, 9'),(520,'item15',228,'yes/no',NULL,'8, 9'),(521,'item16',228,'yes/no',NULL,'8, 9'),(522,'item17',228,'yes/no',NULL,'8, 9'),(523,'item18',228,'yes/no',NULL,'8, 9'),(524,'item19',228,'yes/no',NULL,'8, 9'),(525,'item20',228,'yes/no',NULL,'8, 9'),(526,'item1',229,'yes/no',NULL,'8, 9'),(527,'item2',229,'yes/no',NULL,'8, 9'),(528,'item3',229,'yes/no',NULL,'8, 9'),(529,'item4',229,'yes/no',NULL,'8, 9'),(530,'item5',229,'yes/no',NULL,'8, 9'),(531,'item6',229,'yes/no',NULL,'8, 9'),(532,'item7',229,'yes/no',NULL,'8, 9'),(533,'item8',229,'yes/no',NULL,'8, 9'),(534,'item9',229,'yes/no',NULL,'8, 9'),(535,'item10',229,'yes/no',NULL,'8, 9'),(536,'item11',229,'yes/no',NULL,'8, 9'),(537,'item12',229,'yes/no',NULL,'8, 9'),(538,'item13',229,'yes/no',NULL,'8, 9'),(539,'item14',229,'yes/no',NULL,'8, 9'),(540,'item15',229,'yes/no',NULL,'8, 9'),(541,'item16',229,'yes/no',NULL,'8, 9'),(542,'item17',229,'yes/no',NULL,'8, 9'),(543,'item18',229,'yes/no',NULL,'8, 9'),(544,'item19',229,'yes/no',NULL,'8, 9'),(545,'item20',229,'yes/no',NULL,'8, 9'),(546,'item1',230,'yes/no',NULL,'8, 9'),(547,'item2',230,'yes/no',NULL,'8, 9'),(548,'item3',230,'yes/no',NULL,'8, 9'),(549,'item4',230,'yes/no',NULL,'8, 9'),(550,'item5',230,'yes/no',NULL,'8, 9'),(551,'item6',230,'yes/no',NULL,'8, 9'),(552,'item7',230,'yes/no',NULL,'8, 9'),(553,'item8',230,'yes/no',NULL,'8, 9'),(554,'item9',230,'yes/no',NULL,'8, 9'),(555,'item10',230,'yes/no',NULL,'8, 9'),(556,'item11',230,'yes/no',NULL,'8, 9'),(557,'item12',230,'yes/no',NULL,'8, 9'),(558,'item13',230,'yes/no',NULL,'8, 9'),(559,'item14',230,'yes/no',NULL,'8, 9'),(560,'item15',230,'yes/no',NULL,'8, 9'),(561,'item16',230,'yes/no',NULL,'8, 9'),(562,'item17',230,'yes/no',NULL,'8, 9'),(563,'item18',230,'yes/no',NULL,'8, 9'),(564,'item19',230,'yes/no',NULL,'8, 9'),(565,'item20',230,'yes/no',NULL,'8, 9'),(566,'item1',231,'yes/no',NULL,'8, 9'),(567,'item2',231,'yes/no',NULL,'8, 9'),(568,'item3',231,'yes/no',NULL,'8, 9'),(569,'item4',231,'yes/no',NULL,'8, 9'),(570,'item5',231,'yes/no',NULL,'8, 9'),(571,'item6',231,'yes/no',NULL,'8, 9'),(572,'item7',231,'yes/no',NULL,'8, 9'),(573,'item8',231,'yes/no',NULL,'8, 9'),(574,'item9',231,'yes/no',NULL,'8, 9'),(575,'item10',231,'yes/no',NULL,'8, 9'),(576,'item11',231,'yes/no',NULL,'8, 9'),(577,'item12',231,'yes/no',NULL,'8, 9'),(578,'item13',231,'yes/no',NULL,'8, 9'),(579,'item14',231,'yes/no',NULL,'8, 9'),(580,'item15',231,'yes/no',NULL,'8, 9'),(581,'item16',231,'yes/no',NULL,'8, 9'),(582,'item17',231,'yes/no',NULL,'8, 9'),(583,'item18',231,'yes/no',NULL,'8, 9'),(584,'item19',231,'yes/no',NULL,'8, 9'),(585,'item20',231,'yes/no',NULL,'8, 9'),(586,'item1',232,'yes/no',NULL,'8, 9'),(587,'item2',232,'yes/no',NULL,'8, 9'),(588,'item3',232,'yes/no',NULL,'8, 9'),(589,'item4',232,'yes/no',NULL,'8, 9'),(590,'item5',232,'yes/no',NULL,'8, 9'),(591,'item6',232,'yes/no',NULL,'8, 9'),(592,'item7',232,'yes/no',NULL,'8, 9'),(593,'item8',232,'yes/no',NULL,'8, 9'),(594,'item9',232,'yes/no',NULL,'8, 9'),(595,'item10',232,'yes/no',NULL,'8, 9'),(596,'item11',232,'yes/no',NULL,'8, 9'),(597,'item12',232,'yes/no',NULL,'8, 9'),(598,'item13',232,'yes/no',NULL,'8, 9'),(599,'item14',232,'yes/no',NULL,'8, 9'),(600,'item15',232,'yes/no',NULL,'8, 9'),(601,'item16',232,'yes/no',NULL,'8, 9'),(602,'item17',232,'yes/no',NULL,'8, 9'),(603,'item18',232,'yes/no',NULL,'8, 9'),(604,'item19',232,'yes/no',NULL,'8, 9'),(605,'item20',232,'yes/no',NULL,'8, 9'),(606,'gfeafseafesfaesfesfasefes;fjeaslkfjselkfjaselfjeslkfjelsfjlasekjflasekjflsefjlksejflkasejfljseklfjklasefjesafeasfeasfeasfasefeasfesafeasfeasffaesfasef',233,'yes/no',NULL,'8');
/*!40000 ALTER TABLE `checklistitem` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `checklistschedule`
--

DROP TABLE IF EXISTS `checklistschedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `checklistschedule` (
  `scheduleId` int NOT NULL AUTO_INCREMENT,
  `scheduleName` varchar(255) DEFAULT NULL,
  `recurring` varchar(100) DEFAULT NULL,
  `dateRangeStart` datetime DEFAULT NULL,
  `dateRangeEnd` datetime DEFAULT NULL,
  `startTime` time DEFAULT NULL,
  `endTime` time DEFAULT NULL,
  `templateIds` varchar(255) DEFAULT NULL,
  `dayOfWeek` int DEFAULT NULL,
  `dayOfMonth` int DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`scheduleId`)
) ENGINE=InnoDB AUTO_INCREMENT=104 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `checklistschedule`
--

LOCK TABLES `checklistschedule` WRITE;
/*!40000 ALTER TABLE `checklistschedule` DISABLE KEYS */;
INSERT INTO `checklistschedule` VALUES (102,'testing purposes','daily','2022-03-23 00:00:00','2022-03-31 00:00:00','12:00:00',NULL,'224',NULL,NULL,'MESA'),(103,'feasfesfjasefljeasfljeflkaejslfjaseklfjelfjelfkjalfjleskafjlkasefjlsekjflasekjflesjflasekjfalsekfjlaekfjleajflaekjfesafeasfeasfeasfeasfeasfesafefesafesafeasfesa','daily','2022-03-30 00:00:00','2022-03-31 00:00:00','12:00:00',NULL,'224',NULL,NULL,'MESA');
/*!40000 ALTER TABLE `checklistschedule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `checklisttemplate`
--

DROP TABLE IF EXISTS `checklisttemplate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `checklisttemplate` (
  `templateId` int NOT NULL AUTO_INCREMENT,
  `templateName` varchar(255) DEFAULT NULL,
  `departmentId` int DEFAULT NULL,
  `location` varchar(50) DEFAULT NULL,
  `mandatory` tinyint DEFAULT NULL,
  PRIMARY KEY (`templateId`),
  KEY `departmentId` (`departmentId`),
  CONSTRAINT `checklisttemplate_ibfk_1` FOREIGN KEY (`departmentId`) REFERENCES `department` (`departmentId`)
) ENGINE=InnoDB AUTO_INCREMENT=234 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `checklisttemplate`
--

LOCK TABLES `checklisttemplate` WRITE;
/*!40000 ALTER TABLE `checklisttemplate` DISABLE KEYS */;
INSERT INTO `checklisttemplate` VALUES (223,'faaeskgjselagjaselgjsealgkjselagjeaslgjselgkjeslkagjlkgjselkgjelaskjglsekagjlsekajglkasejgklsejagklasejgkljaseklgjeaslgjklseagseagasegeasgsea',14,'MESA',0),(224,'temp2',1,'MESA',0),(225,'temp3',1,'MESA',0),(226,'temp4',1,'MESA',0),(227,'temp5',1,'MESA',0),(228,'temp6',1,'MESA',0),(229,'temp7',1,'MESA',0),(230,'temp8',1,'MESA',0),(231,'temp9',1,'MESA',0),(232,'temp10',1,'MESA',0),(233,'trail',1,'MESA',0);
/*!40000 ALTER TABLE `checklisttemplate` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `department`
--

DROP TABLE IF EXISTS `department`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `department` (
  `departmentId` int NOT NULL AUTO_INCREMENT,
  `departmentName` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`departmentId`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `department`
--

LOCK TABLES `department` WRITE;
/*!40000 ALTER TABLE `department` DISABLE KEYS */;
INSERT INTO `department` VALUES (1,'golf'),(14,'aefeaf'),(15,'fasfe'),(17,'geagaesgeasgea'),(20,'fefes');
/*!40000 ALTER TABLE `department` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `jobhistory`
--

DROP TABLE IF EXISTS `jobhistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `jobhistory` (
  `jobHistoryId` int NOT NULL AUTO_INCREMENT,
  `userId` int DEFAULT NULL,
  `positionId` int DEFAULT NULL,
  `primaryJob` tinyint(1) DEFAULT NULL,
  `startDate` timestamp NULL DEFAULT NULL,
  `endDate` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`jobHistoryId`),
  KEY `jobhistory_ibfk_1_idx` (`positionId`),
  KEY `userId` (`userId`),
  CONSTRAINT `jobhistory_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`userID`),
  CONSTRAINT `jobhistory_ibfk_2` FOREIGN KEY (`positionId`) REFERENCES `position` (`positionID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jobhistory`
--

LOCK TABLES `jobhistory` WRITE;
/*!40000 ALTER TABLE `jobhistory` DISABLE KEYS */;
INSERT INTO `jobhistory` VALUES (3,8,3,1,NULL,NULL),(4,8,4,0,NULL,NULL),(5,9,3,1,NULL,NULL),(6,9,4,0,NULL,NULL);
/*!40000 ALTER TABLE `jobhistory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `location`
--

DROP TABLE IF EXISTS `location`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `location` (
  `locationId` int NOT NULL AUTO_INCREMENT,
  `locationName` varchar(50) DEFAULT NULL,
  `locationIpSet` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`locationId`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `location`
--

LOCK TABLES `location` WRITE;
/*!40000 ALTER TABLE `location` DISABLE KEYS */;
INSERT INTO `location` VALUES (1,'MESA','65.141.6.250, 98.191.121.99'),(2,'EME','45.24.222.49, 108.233.8.57'),(3,'GOL','75.36.0.121, 107.204.239.97'),(4,'GUS','108.95.58.59, 50.242.97.81'),(5,'CAM','32.141.63.222'),(6,'MIL','32.141.70.134'),(7,'FGL','32.141.65.14'),(8,'ROS','69.62.250.118, 207.231.65.30');
/*!40000 ALTER TABLE `location` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `login`
--

DROP TABLE IF EXISTS `login`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `login` (
  `username` varchar(200) DEFAULT NULL,
  `password` varchar(200) DEFAULT NULL,
  `userId` int DEFAULT (1),
  `loggedIn` tinyint DEFAULT NULL,
  KEY `userId` (`userId`),
  CONSTRAINT `login_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`userID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login`
--

LOCK TABLES `login` WRITE;
/*!40000 ALTER TABLE `login` DISABLE KEYS */;
INSERT INTO `login` VALUES ('at@gmail.com','$2b$10$bPkz5hC1O4WCuYIKVinLl.SF8dDioxaUC63bJKOp79b34DYD7j7Lu',8,0),('at2@gmail.com','$2b$10$kJAJ5MmklONNP1DNMbcxaOMDc.0kbzWIu7HNcNidmBf23rXrLqX0G',9,0);
/*!40000 ALTER TABLE `login` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notification`
--

DROP TABLE IF EXISTS `notification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notification` (
  `notificationId` int NOT NULL AUTO_INCREMENT,
  `notificationType` varchar(100) DEFAULT NULL,
  `notificationMessage` varchar(255) DEFAULT NULL,
  `userIds` varchar(255) DEFAULT NULL,
  `deletedUserIds` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`notificationId`)
) ENGINE=InnoDB AUTO_INCREMENT=550 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notification`
--

LOCK TABLES `notification` WRITE;
/*!40000 ALTER TABLE `notification` DISABLE KEYS */;
INSERT INTO `notification` VALUES (515,'instance','instance temp1 has just been created','8, 9','9'),(516,'instance','instance temp2 has just been created','8, 9','9'),(517,'instance','instance temp3 has just been created','8, 9','9'),(518,'instance','instance temp4 has just been created','8, 9','9'),(519,'instance','instance temp5 has just been created','8, 9','9'),(520,'instance','instance temp6 has just been created','8, 9','9'),(521,'instance','instance temp7 has just been created','8, 9','9'),(522,'instance','instance temp8 has just been created','8, 9','9'),(523,'instance','instance temp9 has just been created','8, 9','9'),(524,'instance','instance temp10 has just been created','8, 9','9'),(525,'issue','Issue in temp1 for item item1: tes','8, 9, 18, 19, 20, 21, 22, 23, 24','9'),(526,'issue','Issue in temp1 for item item2: tes','8, 9, 18, 19, 20, 21, 22, 23, 24','9'),(527,'issue','Issue in temp1 for item item3: tes','8, 9, 18, 19, 20, 21, 22, 23, 24','9'),(528,'issue','Issue in temp1 for item item4: tes','8, 9, 18, 19, 20, 21, 22, 23, 24','9'),(529,'issue','Issue in temp1 for item item5: tes','8, 9, 18, 19, 20, 21, 22, 23, 24','9'),(530,'issue','Issue in temp1 for item item6: tes','8, 9, 18, 19, 20, 21, 22, 23, 24','9'),(531,'issue','Issue in temp1 for item item7: tes','8, 9, 18, 19, 20, 21, 22, 23, 24','9'),(532,'issue','Issue in temp1 for item item8: tes','8, 9, 18, 19, 20, 21, 22, 23, 24','9'),(533,'issue','Issue in temp1 for item item1: tes','8, 9, 18, 19, 20, 21, 22, 23, 24','9'),(534,'issue','Issue in temp1 for item item9: tes','8, 9, 18, 19, 20, 21, 22, 23, 24','9'),(535,'issue','Issue in temp1 for item item2: tes','8, 9, 18, 19, 20, 21, 22, 23, 24','9'),(536,'issue','Issue in temp1 for item item10: tes','8, 9, 18, 19, 20, 21, 22, 23, 24','9'),(537,'issue','Issue in temp1 for item item3: tes','8, 9, 18, 19, 20, 21, 22, 23, 24','9'),(538,'issue','Issue in temp1 for item item11: tes','8, 9, 18, 19, 20, 21, 22, 23, 24','9'),(539,'issue','Issue in temp1 for item item4: tes','8, 9, 18, 19, 20, 21, 22, 23, 24','9'),(540,'issue','Issue in temp1 for item item12: tes','8, 9, 18, 19, 20, 21, 22, 23, 24','9'),(541,'issue','Issue in temp1 for item item5: tes','8, 9, 18, 19, 20, 21, 22, 23, 24','9'),(542,'issue','Issue in temp1 for item item13: tes','8, 9, 18, 19, 20, 21, 22, 23, 24','9'),(543,'issue','Issue in temp1 for item item6: tes','8, 9, 18, 19, 20, 21, 22, 23, 24','9'),(544,'issue','Issue in temp1 for item item7: tes','8, 9, 18, 19, 20, 21, 22, 23, 24','9'),(545,'issue','Issue in temp1 for item item15: tes','8, 9, 18, 19, 20, 21, 22, 23, 24','9'),(546,'issue','Issue in temp1 for item item8: tes','8, 9, 18, 19, 20, 21, 22, 23, 24','9'),(547,'issue','Issue in temp1 for item item16: tes','8, 9, 18, 19, 20, 21, 22, 23, 24','9'),(548,'issue','Issue in temp1 for item item9: tes','8, 9, 18, 19, 20, 21, 22, 23, 24','9'),(549,'instance','instance trail has just been created','8, 9','9');
/*!40000 ALTER TABLE `notification` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permission`
--

DROP TABLE IF EXISTS `permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `permission` (
  `permissionID` int NOT NULL,
  `permissionDescription` varchar(255) DEFAULT NULL,
  `deletePermission` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`permissionID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permission`
--

LOCK TABLES `permission` WRITE;
/*!40000 ALTER TABLE `permission` DISABLE KEYS */;
INSERT INTO `permission` VALUES (0,'add template',0),(1,'edit template',0),(2,'add barcode',0),(3,'add department',0),(4,'add roles',0);
/*!40000 ALTER TABLE `permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `position`
--

DROP TABLE IF EXISTS `position`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `position` (
  `positionID` int NOT NULL AUTO_INCREMENT,
  `positionName` varchar(100) DEFAULT NULL,
  `permissions` varchar(50) DEFAULT NULL,
  `departmentId` int DEFAULT NULL,
  PRIMARY KEY (`positionID`),
  KEY `departmentId` (`departmentId`),
  CONSTRAINT `position_ibfk_1` FOREIGN KEY (`departmentId`) REFERENCES `department` (`departmentId`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `position`
--

LOCK TABLES `position` WRITE;
/*!40000 ALTER TABLE `position` DISABLE KEYS */;
INSERT INTO `position` VALUES (1,'test','0, 1, 2',NULL),(2,'test2','0, 1, 2',NULL),(3,'yes','0, 1, 2',1),(4,'adwdaw','2, 3, 4',1),(30,'gesgaaes','0',14),(31,'geagaesgeaga','2',1),(32,'geasgegeag','0',1),(33,'gasgeasgae','0',1),(34,'fesfes','0',1);
/*!40000 ALTER TABLE `position` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sessions` (
  `sessionId` varchar(200) DEFAULT NULL,
  `timeCreated` datetime DEFAULT NULL,
  `userId` int DEFAULT (1),
  KEY `userId` (`userId`),
  CONSTRAINT `sessions_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`userID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sessions`
--

LOCK TABLES `sessions` WRITE;
/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `userID` int NOT NULL AUTO_INCREMENT,
  `firstName` varchar(255) NOT NULL,
  `lastName` varchar(255) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `phone` varchar(10) DEFAULT NULL,
  `permissions` varchar(50) DEFAULT NULL,
  `adminView` tinyint(1) DEFAULT NULL,
  `fcmToken` text,
  `locations` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`userID`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (8,'adrian','tesoro','adriantesoro@gmail.com','none','0, 1, 2, 3',0,'dOiXw30xyRBFLz9MDVMCB7:APA91bHfPBazp4WaeJbuxGth90X5rDY0i_YI_THgSIG5vF3R2cOaDj2kiSnKHT6X_yJ2TLUdjpv4UilvFTvxzvBMOMl1eq0gp5CSyVEF7I9LQT_KdsCswbwXbH5M7nOlETGv57FGEwwt','1'),(9,'adrian2','tesoro2','adriantesoro2@gmail.com','8888888888','0, 1, 2',1,'dOiXw30xyRBFLz9MDVMCB7:APA91bHfPBazp4WaeJbuxGth90X5rDY0i_YI_THgSIG5vF3R2cOaDj2kiSnKHT6X_yJ2TLUdjpv4UilvFTvxzvBMOMl1eq0gp5CSyVEF7I9LQT_KdsCswbwXbH5M7nOlETGv57FGEwwt','1, 2, 3'),(11,'adrian3','tesoro3','email','phone','0, 1, 2, 3',0,NULL,'1, 2'),(14,'adrian4','tesoro4','email','phone','0, 1, 2, 3',0,NULL,'1, 2'),(15,'adrian5','tesoro5','email','phone','0, 1, 2, 3',0,NULL,'1, 2, 3'),(16,'adrian6','tesoro6','email','phone','0, 1, 2, 3',0,NULL,'1, 2, 3'),(17,'adrian7','tesoro7','email','phone','0, 1, 2, 3',0,NULL,'1, 2'),(18,'adrian8','tesoro8','email','phone','0, 1, 2, 3',1,NULL,'1, 2'),(19,'adrian9','tesoro9','email','phone','0, 1, 2, 3',1,NULL,'1, 2'),(20,'adrian10','tesoro10','email','phone','0, 1, 2, 3',1,NULL,'1, 2'),(21,'adrian11','tesoro11','email','phone','0, 1, 2, 3',1,NULL,'1, 2'),(22,'adrian12','tesoro12','email','phone','0, 1, 2, 3',1,NULL,'1, 2'),(23,'adrian13','tesoro13','email','phone','0, 1, 2, 3',1,NULL,'1, 2'),(24,'adrian14','tesoro14','email','phone','0, 1, 2, 3',1,NULL,'1, 2');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'puttsportal'
--
/*!50106 SET @save_time_zone= @@TIME_ZONE */ ;
/*!50106 DROP EVENT IF EXISTS `8cef4474-d727-4d96-9e8c-d28319bde79c` */;
DELIMITER ;;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;;
/*!50003 SET character_set_client  = utf8mb3 */ ;;
/*!50003 SET character_set_results = utf8mb3 */ ;;
/*!50003 SET collation_connection  = utf8_general_ci */ ;;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;;
/*!50003 SET @saved_time_zone      = @@time_zone */ ;;
/*!50003 SET time_zone             = 'SYSTEM' */ ;;
/*!50106 CREATE*/ /*!50117 DEFINER=`root`@`localhost`*/ /*!50106 EVENT `8cef4474-d727-4d96-9e8c-d28319bde79c` ON SCHEDULE AT '2021-09-27 19:10:13' ON COMPLETION PRESERVE DISABLE DO INSERT INTO `sessions` VALUES('8cef4474-d727-4d96-9e8c-d28319bde79c') */ ;;
/*!50003 SET time_zone             = @saved_time_zone */ ;;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;;
/*!50003 SET character_set_client  = @saved_cs_client */ ;;
/*!50003 SET character_set_results = @saved_cs_results */ ;;
/*!50003 SET collation_connection  = @saved_col_connection */ ;;
DELIMITER ;
/*!50106 SET TIME_ZONE= @save_time_zone */ ;

--
-- Dumping routines for database 'puttsportal'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-03-31 15:56:46
