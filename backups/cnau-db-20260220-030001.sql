-- MySQL dump 10.13  Distrib 8.0.45, for Linux (x86_64)
--
-- Host: localhost    Database: cnau
-- ------------------------------------------------------
-- Server version	8.0.45-0ubuntu0.22.04.1

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
-- Table structure for table `t_master`
--

DROP TABLE IF EXISTS `t_master`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_master` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `real_name` varchar(50) NOT NULL,
  `id_type` varchar(20) DEFAULT NULL COMMENT 'license/passport/birth',
  `id_number` varchar(50) DEFAULT NULL,
  `id_card_front` varchar(255) DEFAULT NULL,
  `id_card_back` varchar(255) DEFAULT NULL,
  `service_types` varchar(255) DEFAULT NULL COMMENT '服务类型,逗号分隔',
  `description` text,
  `experience` varchar(500) DEFAULT NULL,
  `price_range` varchar(50) DEFAULT NULL,
  `rating` decimal(3,2) DEFAULT '5.00',
  `order_count` int DEFAULT '0',
  `deposit` decimal(10,2) DEFAULT '0.00',
  `bank_name` varchar(50) DEFAULT NULL,
  `bsb` varchar(10) DEFAULT NULL,
  `account_number` varchar(20) DEFAULT NULL,
  `status` tinyint DEFAULT '0' COMMENT '0待审核 1通过 2拒绝',
  `reject_reason` varchar(500) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `wechat` varchar(50) DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `t_master_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `t_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_master`
--

LOCK TABLES `t_master` WRITE;
/*!40000 ALTER TABLE `t_master` DISABLE KEYS */;
INSERT INTO `t_master` VALUES (1,2,'测试师傅',NULL,NULL,NULL,NULL,'cleaning','测试',NULL,'$50起',5.00,0,0.00,NULL,NULL,NULL,1,NULL,'2026-02-19 11:55:54','2026-02-19 11:57:09','testwx'),(2,3,'JINGAN',NULL,NULL,NULL,NULL,'gardening','景观园林。带证作业，IT服务',NULL,'100起',5.00,0,0.00,NULL,NULL,NULL,1,NULL,'2026-02-19 11:56:29','2026-02-19 11:57:09','tido521'),(3,4,'雪狼',NULL,NULL,NULL,NULL,'it','电脑维修，数据恢复，网站制作等',NULL,'60起',5.00,0,0.00,NULL,NULL,NULL,0,NULL,'2026-02-19 11:59:52','2026-02-19 11:59:52','tido521');
/*!40000 ALTER TABLE `t_master` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_order`
--

DROP TABLE IF EXISTS `t_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_order` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_no` varchar(50) NOT NULL,
  `user_id` bigint NOT NULL,
  `master_id` bigint NOT NULL,
  `service_type` varchar(50) NOT NULL,
  `service_content` text NOT NULL,
  `address` varchar(255) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `appointment_time` datetime DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `status` tinyint DEFAULT '0' COMMENT '0待接单 1已接单 2进行中 3已完成 4已取消',
  `remark` varchar(500) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `order_no` (`order_no`),
  KEY `user_id` (`user_id`),
  KEY `master_id` (`master_id`),
  CONSTRAINT `t_order_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `t_user` (`id`),
  CONSTRAINT `t_order_ibfk_2` FOREIGN KEY (`master_id`) REFERENCES `t_master` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_order`
--

LOCK TABLES `t_order` WRITE;
/*!40000 ALTER TABLE `t_order` DISABLE KEYS */;
INSERT INTO `t_order` VALUES (1,'CN1771503057401JEHX',6,2,'gardening','割草','','0403333678','2026-02-20 23:10:00',0.00,0,NULL,'2026-02-19 12:10:57','2026-02-19 12:10:57'),(2,'CN1771503352286YD71',6,2,'gardening','修剪草坪','Sydney','0403333678','2026-02-20 00:00:00',100.00,0,NULL,'2026-02-19 12:15:52','2026-02-19 12:15:52'),(3,'CN1771505168741DH6X',7,2,'gardening','电脑进水了，想找你修电脑','36 Howard ave mount waverley','0400000000','2026-02-20 08:30:00',0.00,0,NULL,'2026-02-19 12:46:08','2026-02-19 12:46:08');
/*!40000 ALTER TABLE `t_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_review`
--

DROP TABLE IF EXISTS `t_review`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_review` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  `master_id` bigint NOT NULL,
  `rating` int NOT NULL COMMENT '1-5星',
  `service_attitude` int DEFAULT NULL,
  `professional_level` int DEFAULT NULL,
  `punctuality` int DEFAULT NULL,
  `content` varchar(500) DEFAULT NULL,
  `images` varchar(1000) DEFAULT NULL,
  `reply` varchar(500) DEFAULT NULL,
  `status` tinyint DEFAULT '1',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `order_id` (`order_id`),
  KEY `user_id` (`user_id`),
  KEY `master_id` (`master_id`),
  CONSTRAINT `t_review_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `t_order` (`id`),
  CONSTRAINT `t_review_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `t_user` (`id`),
  CONSTRAINT `t_review_ibfk_3` FOREIGN KEY (`master_id`) REFERENCES `t_master` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_review`
--

LOCK TABLES `t_review` WRITE;
/*!40000 ALTER TABLE `t_review` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_review` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_secondhand`
--

DROP TABLE IF EXISTS `t_secondhand`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_secondhand` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `title` varchar(100) NOT NULL,
  `description` text,
  `category` varchar(50) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `images` varchar(2000) DEFAULT NULL,
  `contact_wechat` varchar(50) DEFAULT NULL,
  `contact_phone` varchar(20) DEFAULT NULL,
  `status` tinyint DEFAULT '1' COMMENT '1上架 0下架',
  `view_count` int DEFAULT '0',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `t_secondhand_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `t_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_secondhand`
--

LOCK TABLES `t_secondhand` WRITE;
/*!40000 ALTER TABLE `t_secondhand` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_secondhand` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_service_category`
--

DROP TABLE IF EXISTS `t_service_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_service_category` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `name_en` varchar(50) DEFAULT NULL,
  `icon` varchar(100) DEFAULT NULL,
  `description` varchar(500) DEFAULT NULL,
  `sort_order` int DEFAULT '0',
  `status` tinyint DEFAULT '1',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_service_category`
--

LOCK TABLES `t_service_category` WRITE;
/*!40000 ALTER TABLE `t_service_category` DISABLE KEYS */;
INSERT INTO `t_service_category` VALUES (1,'搬家货运','Moving','🚚','家庭搬家、货运服务',1,1,'2026-02-19 11:42:50'),(2,'家政清洁','Cleaning','🧹','日常清洁、开荒清洁、深度清洁',2,1,'2026-02-19 11:42:50'),(3,'园林景观','Gardening','🌳','草坪修剪、花园维护',3,1,'2026-02-19 11:42:50'),(4,'刷漆修补','Painting','🎨','刷漆、补墙、小修小补',4,1,'2026-02-19 11:42:50'),(5,'IT服务','IT Services','💻','电脑维修、网络安装',5,1,'2026-02-19 11:42:50'),(6,'二手交易','Secondhand','🔄','二手物品交易',6,1,'2026-02-19 11:42:50');
/*!40000 ALTER TABLE `t_service_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_user`
--

DROP TABLE IF EXISTS `t_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_user` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `avatar` varchar(255) DEFAULT NULL,
  `wechat` varchar(50) DEFAULT NULL,
  `status` tinyint DEFAULT '1' COMMENT '1正常 0禁用',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_user`
--

LOCK TABLES `t_user` WRITE;
/*!40000 ALTER TABLE `t_user` DISABLE KEYS */;
INSERT INTO `t_user` VALUES (1,'测试','0421000000',NULL,'$2a$10$lMoyueDb8wuksB.50XIfZO2YB41QsxUhCX24KV/V1b7FaChQB/IgK',NULL,NULL,1,'2026-02-19 11:54:36','2026-02-19 12:17:34'),(2,'测试师傅','0421111222',NULL,'$2a$10$lMoyueDb8wuksB.50XIfZO2YB41QsxUhCX24KV/V1b7FaChQB/IgK',NULL,NULL,1,'2026-02-19 11:55:48','2026-02-19 12:17:34'),(3,'JINGAN','0401976555',NULL,'$2a$10$lMoyueDb8wuksB.50XIfZO2YB41QsxUhCX24KV/V1b7FaChQB/IgK',NULL,NULL,1,'2026-02-19 11:56:29','2026-02-19 12:17:34'),(4,'雪狼','040333678',NULL,'$2a$10$lMoyueDb8wuksB.50XIfZO2YB41QsxUhCX24KV/V1b7FaChQB/IgK',NULL,NULL,1,'2026-02-19 11:59:52','2026-02-19 12:17:34'),(5,'测试用户','0400000001',NULL,'$2a$10$lMoyueDb8wuksB.50XIfZO2YB41QsxUhCX24KV/V1b7FaChQB/IgK',NULL,NULL,1,'2026-02-19 12:07:07','2026-02-19 12:17:34'),(6,'用户B','0403333678',NULL,'$2a$10$lMoyueDb8wuksB.50XIfZO2YB41QsxUhCX24KV/V1b7FaChQB/IgK',NULL,NULL,1,'2026-02-19 12:08:32','2026-02-19 12:17:34'),(7,'0400000000','0400000000',NULL,'$2a$10$17MLVvQm5mXnnukKD1Mzae0tbL/mg4hrHJZ1Erewny0Tx.EXYeZLa',NULL,NULL,1,'2026-02-19 12:44:35','2026-02-19 12:44:35');
/*!40000 ALTER TABLE `t_user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-02-20  3:00:01
