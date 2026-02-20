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
-- Table structure for table `t_banner`
--

DROP TABLE IF EXISTS `t_banner`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_banner` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(100) DEFAULT NULL,
  `image` varchar(255) NOT NULL,
  `link` varchar(255) DEFAULT NULL,
  `position` varchar(20) DEFAULT 'home',
  `sort_order` int DEFAULT '0',
  `status` tinyint DEFAULT '1',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_banner`
--

LOCK TABLES `t_banner` WRITE;
/*!40000 ALTER TABLE `t_banner` DISABLE KEYS */;
INSERT INTO `t_banner` VALUES (1,'新人专享','https://via.placeholder.com/750x300/11998e/fff?text=新人立减10元','/coupons.html','home',1,1,'2026-02-20 04:25:53'),(2,'限时优惠','https://via.placeholder.com/750x300/ff6b6b/fff?text=搬家8折','/master/apply.html','home',2,1,'2026-02-20 04:25:53');
/*!40000 ALTER TABLE `t_banner` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_coupon`
--

DROP TABLE IF EXISTS `t_coupon`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_coupon` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `code` varchar(50) NOT NULL,
  `type` varchar(20) DEFAULT 'cash' COMMENT 'cash代金券 discount折扣券',
  `value` decimal(10,2) DEFAULT '0.00',
  `min_amount` decimal(10,2) DEFAULT '0.00',
  `valid_from` date DEFAULT NULL,
  `valid_to` date DEFAULT NULL,
  `status` tinyint DEFAULT '1',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `discount` decimal(5,2) DEFAULT '0.00' COMMENT '折扣力度，如0.9表示9折',
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_coupon`
--

LOCK TABLES `t_coupon` WRITE;
/*!40000 ALTER TABLE `t_coupon` DISABLE KEYS */;
INSERT INTO `t_coupon` VALUES (1,'NEW10','cash',10.00,50.00,'2026-01-01','2027-12-31',1,'2026-02-20 04:53:54',0.00),(2,'CLEAN20','cash',20.00,100.00,'2026-01-01','2027-12-31',1,'2026-02-20 04:53:54',0.00),(3,'SAVE10','discount',0.00,0.00,'2026-01-01','2027-12-31',1,'2026-02-20 04:53:54',0.90);
/*!40000 ALTER TABLE `t_coupon` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_favorite`
--

DROP TABLE IF EXISTS `t_favorite`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_favorite` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `type` tinyint NOT NULL COMMENT '1师傅 2商品',
  `target_id` bigint NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_user_type_target` (`user_id`,`type`,`target_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_favorite`
--

LOCK TABLES `t_favorite` WRITE;
/*!40000 ALTER TABLE `t_favorite` DISABLE KEYS */;
INSERT INTO `t_favorite` VALUES (1,14,1,2,'2026-02-20 10:28:46');
/*!40000 ALTER TABLE `t_favorite` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_feedback`
--

DROP TABLE IF EXISTS `t_feedback`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_feedback` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint DEFAULT NULL,
  `type` varchar(20) DEFAULT NULL COMMENT 'suggest/bug/complaint',
  `content` text NOT NULL,
  `contact` varchar(100) DEFAULT NULL,
  `status` tinyint DEFAULT '0' COMMENT '0待处理 1已处理',
  `reply` text,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_feedback`
--

LOCK TABLES `t_feedback` WRITE;
/*!40000 ALTER TABLE `t_feedback` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_feedback` ENABLE KEYS */;
UNLOCK TABLES;

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
  `phone` varchar(20) DEFAULT NULL,
  `is_top` tinyint DEFAULT '0' COMMENT '是否置顶',
  `top_expire_date` datetime DEFAULT NULL,
  `verify_status` tinyint DEFAULT '0' COMMENT '0未认证 1已认证',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `t_master_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `t_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_master`
--

LOCK TABLES `t_master` WRITE;
/*!40000 ALTER TABLE `t_master` DISABLE KEYS */;
INSERT INTO `t_master` VALUES (1,2,'测试师傅',NULL,NULL,NULL,NULL,'cleaning','测试',NULL,'$50起',5.00,0,0.00,NULL,NULL,NULL,1,NULL,'2026-02-19 11:55:54','2026-02-19 11:57:09','testwx',NULL,0,NULL,0),(2,3,'JINGAN',NULL,NULL,NULL,NULL,'gardening','景观园林。带证作业，IT服务',NULL,'100起',5.00,4,0.00,NULL,NULL,NULL,1,NULL,'2026-02-19 11:56:29','2026-02-20 11:08:55','tido521',NULL,1,'2026-02-27 20:43:14',0),(3,4,'雪狼',NULL,NULL,NULL,NULL,'it','电脑维修，数据恢复，网站制作等',NULL,'60起',5.00,0,0.00,NULL,NULL,NULL,1,NULL,'2026-02-19 11:59:52','2026-02-20 11:13:44','tido521',NULL,0,NULL,0),(7,8,'王师傅',NULL,NULL,NULL,NULL,'moving','专业搬家货运，十年经验',NULL,'$80起',5.00,0,0.00,NULL,NULL,NULL,1,NULL,'2026-02-20 06:20:24','2026-02-20 06:20:24','wang123',NULL,0,NULL,0),(8,9,'李师傅',NULL,NULL,NULL,NULL,'painting','专业刷漆，旧墙翻新',NULL,'$100起',5.00,0,0.00,NULL,NULL,NULL,1,NULL,'2026-02-20 06:20:24','2026-02-20 06:20:24','li123',NULL,0,NULL,0),(9,10,'张师傅',NULL,NULL,NULL,NULL,'pet','专业宠物美容寄养',NULL,'$50起',5.00,0,0.00,NULL,NULL,NULL,1,NULL,'2026-02-20 06:20:24','2026-02-20 06:20:24','zhang123',NULL,0,NULL,0),(10,11,'赵师傅',NULL,NULL,NULL,NULL,'appliance','家电维修冰箱空调',NULL,'$60起',5.00,0,0.00,NULL,NULL,NULL,1,NULL,'2026-02-20 06:20:44','2026-02-20 06:20:44','zhao123',NULL,0,NULL,0),(11,12,'孙师傅',NULL,NULL,NULL,NULL,'plumbing','水电维修安装',NULL,'$50起',5.00,0,0.00,NULL,NULL,NULL,1,NULL,'2026-02-20 06:20:44','2026-02-20 06:20:44','sun123',NULL,0,NULL,0),(12,13,'周师傅',NULL,NULL,NULL,NULL,'auto','汽车维修保养',NULL,'$80起',5.00,0,0.00,NULL,NULL,NULL,1,NULL,'2026-02-20 06:20:44','2026-02-20 06:20:44','zhou123',NULL,0,NULL,0);
/*!40000 ALTER TABLE `t_master` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_master_area`
--

DROP TABLE IF EXISTS `t_master_area`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_master_area` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `master_id` bigint NOT NULL,
  `area` varchar(100) NOT NULL,
  `extra_fee` decimal(10,2) DEFAULT '0.00',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_master_area`
--

LOCK TABLES `t_master_area` WRITE;
/*!40000 ALTER TABLE `t_master_area` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_master_area` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_master_case`
--

DROP TABLE IF EXISTS `t_master_case`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_master_case` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `master_id` bigint NOT NULL,
  `title` varchar(100) NOT NULL,
  `description` text,
  `images` varchar(2000) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_master_case`
--

LOCK TABLES `t_master_case` WRITE;
/*!40000 ALTER TABLE `t_master_case` DISABLE KEYS */;
INSERT INTO `t_master_case` VALUES (1,2,'花园翻新','完成了一个200平米的后花园翻新工程，包括草坪铺设、花坛种植、灌溉系统安装。',NULL,'2026-02-20 05:16:04'),(2,2,'草坪修剪','为客户定期修剪草坪，保持花园整洁美观。已服务半年。',NULL,'2026-02-20 05:16:04'),(3,1,'日常清洁','为一套3居室公寓提供日常清洁服务，客户非常满意。',NULL,'2026-02-20 05:16:04');
/*!40000 ALTER TABLE `t_master_case` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_master_schedule`
--

DROP TABLE IF EXISTS `t_master_schedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_master_schedule` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `master_id` bigint NOT NULL,
  `date` date NOT NULL,
  `time_slots` varchar(255) DEFAULT NULL COMMENT 'JSON: ["09:00","10:00"]',
  `is_off` tinyint DEFAULT '0' COMMENT '0上班 1休息',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_master_date` (`master_id`,`date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_master_schedule`
--

LOCK TABLES `t_master_schedule` WRITE;
/*!40000 ALTER TABLE `t_master_schedule` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_master_schedule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_master_top`
--

DROP TABLE IF EXISTS `t_master_top`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_master_top` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `master_id` bigint NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `amount` decimal(10,2) DEFAULT '0.00',
  `status` tinyint DEFAULT '1' COMMENT '1生效中 0已过期',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_master_top`
--

LOCK TABLES `t_master_top` WRITE;
/*!40000 ALTER TABLE `t_master_top` DISABLE KEYS */;
INSERT INTO `t_master_top` VALUES (1,2,'2026-02-20','2026-02-27',0.00,1,'2026-02-20 09:43:02'),(2,2,'2026-02-20','2026-02-27',0.00,1,'2026-02-20 09:43:05'),(3,2,'2026-02-20','2026-02-27',0.00,1,'2026-02-20 09:43:10'),(4,2,'2026-02-20','2026-02-27',0.00,1,'2026-02-20 09:43:14');
/*!40000 ALTER TABLE `t_master_top` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_master_verify`
--

DROP TABLE IF EXISTS `t_master_verify`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_master_verify` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `master_id` bigint NOT NULL,
  `id_type` varchar(20) DEFAULT NULL,
  `id_number` varchar(50) DEFAULT NULL,
  `id_images` varchar(500) DEFAULT NULL,
  `status` tinyint DEFAULT '0' COMMENT '0待审核 1已认证 2未通过',
  `verify_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_master_verify`
--

LOCK TABLES `t_master_verify` WRITE;
/*!40000 ALTER TABLE `t_master_verify` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_master_verify` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_notification`
--

DROP TABLE IF EXISTS `t_notification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_notification` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `type` varchar(50) DEFAULT 'order',
  `title` varchar(100) NOT NULL,
  `content` text,
  `data` json DEFAULT NULL,
  `is_read` tinyint DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_created_at` (`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_notification`
--

LOCK TABLES `t_notification` WRITE;
/*!40000 ALTER TABLE `t_notification` DISABLE KEYS */;
INSERT INTO `t_notification` VALUES (1,10,'order','新订单通知','您有一个新订单，请及时查看','{\"orderNo\": \"CN17715830131577VU9\"}',0,'2026-02-20 10:23:33'),(2,3,'order','新订单通知','您有一个新订单，请及时查看','{\"orderNo\": \"CN1771583029612L8XO\"}',0,'2026-02-20 10:23:49'),(3,14,'order','订单已接单','师傅已接单，请等待服务','{\"orderId\": 9}',0,'2026-02-20 10:27:20'),(4,14,'order','订单已接单','师傅已接单，请等待服务','{\"orderId\": 5}',0,'2026-02-20 10:27:22'),(5,10,'order','新订单通知','您有一个新订单，请及时查看','{\"orderNo\": \"CN17715853330537FTR\"}',0,'2026-02-20 11:02:13'),(6,10,'order','新订单通知','您有一个新订单，请及时查看','{\"orderNo\": \"CN1771585642943E1O3\"}',0,'2026-02-20 11:07:22'),(7,8,'order','新订单通知','您有一个新订单，请及时查看','{\"orderNo\": \"CN1771585667503DUPG\"}',0,'2026-02-20 11:07:47'),(8,4,'master','审核通知','您的师傅申请已通过审核','{\"status\": 1, \"masterId\": 3}',0,'2026-02-20 11:13:44'),(9,3,'review','新评价','用户给了5星评价','{\"rating\": 5, \"orderId\": 9}',0,'2026-02-20 11:14:13');
/*!40000 ALTER TABLE `t_notification` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_order`
--

LOCK TABLES `t_order` WRITE;
/*!40000 ALTER TABLE `t_order` DISABLE KEYS */;
INSERT INTO `t_order` VALUES (1,'CN1771503057401JEHX',6,2,'gardening','割草','','0403333678','2026-02-20 23:10:00',0.00,4,NULL,'2026-02-19 12:10:57','2026-02-20 09:42:47'),(2,'CN1771503352286YD71',6,2,'gardening','修剪草坪','Sydney','0403333678','2026-02-20 00:00:00',100.00,3,NULL,'2026-02-19 12:15:52','2026-02-20 11:08:55'),(3,'CN1771505168741DH6X',7,2,'gardening','电脑进水了，想找你修电脑','36 Howard ave mount waverley','0400000000','2026-02-20 08:30:00',0.00,3,NULL,'2026-02-19 12:46:08','2026-02-20 11:08:53'),(4,'CN1771582510916B50Q',14,2,'gardening','你买了','','040000000','2026-02-25 21:15:00',0.00,4,NULL,'2026-02-20 10:15:10','2026-02-20 10:27:34'),(5,'CN1771582548075RIG5',14,2,'gardening','你买了','','040000000','2026-02-25 21:15:00',0.00,3,NULL,'2026-02-20 10:15:48','2026-02-20 11:08:48'),(6,'CN177158285651390NW',14,9,'pet','来了来了来了','','040000000',NULL,0.00,0,NULL,'2026-02-20 10:20:56','2026-02-20 10:20:56'),(7,'CN1771582897312V7BJ',14,9,'pet','QQ','','040000000',NULL,0.00,0,NULL,'2026-02-20 10:21:37','2026-02-20 10:21:37'),(8,'CN17715830131577VU9',14,9,'pet','QQ','','040000000',NULL,0.00,0,NULL,'2026-02-20 10:23:33','2026-02-20 10:23:33'),(9,'CN1771583029612L8XO',14,2,'gardening','14','','040000000',NULL,0.00,3,NULL,'2026-02-20 10:23:49','2026-02-20 11:08:39'),(10,'CN17715853330537FTR',14,9,'pet','模块','','040000000',NULL,0.00,0,NULL,'2026-02-20 11:02:13','2026-02-20 11:02:13'),(11,'CN1771585642943E1O3',14,9,'pet','模块','','040000000',NULL,0.00,0,NULL,'2026-02-20 11:07:22','2026-02-20 11:07:22'),(12,'CN1771585667503DUPG',14,7,'moving','太','','040000000',NULL,0.00,0,NULL,'2026-02-20 11:07:47','2026-02-20 11:07:47');
/*!40000 ALTER TABLE `t_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_partnership`
--

DROP TABLE IF EXISTS `t_partnership`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_partnership` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `partner_name` varchar(50) NOT NULL,
  `partner_type` varchar(20) NOT NULL COMMENT 'founder/tech/other',
  `phone` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `share_ratio` decimal(5,2) DEFAULT '0.00',
  `status` tinyint DEFAULT '0' COMMENT '0待签署 1已签署',
  `signed_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_partnership`
--

LOCK TABLES `t_partnership` WRITE;
/*!40000 ALTER TABLE `t_partnership` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_partnership` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_ranking`
--

DROP TABLE IF EXISTS `t_ranking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_ranking` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `master_id` bigint NOT NULL,
  `month` varchar(7) DEFAULT NULL,
  `order_count` int DEFAULT '0',
  `rating` decimal(3,2) DEFAULT '5.00',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_ranking`
--

LOCK TABLES `t_ranking` WRITE;
/*!40000 ALTER TABLE `t_ranking` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_ranking` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_review`
--

LOCK TABLES `t_review` WRITE;
/*!40000 ALTER TABLE `t_review` DISABLE KEYS */;
INSERT INTO `t_review` VALUES (1,9,14,2,5,5,5,5,'值得推荐 价格合理 专业可靠 准时到达 服务态度好',NULL,'谢谢',1,'2026-02-20 11:14:13');
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
-- Table structure for table `t_seo`
--

DROP TABLE IF EXISTS `t_seo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_seo` (
  `id` int NOT NULL,
  `site_title` varchar(200) DEFAULT NULL,
  `site_description` text,
  `site_keywords` varchar(500) DEFAULT NULL,
  `logo` varchar(255) DEFAULT NULL,
  `master_title` varchar(200) DEFAULT NULL,
  `master_description` text,
  `og_title` varchar(200) DEFAULT NULL,
  `og_image` varchar(255) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_seo`
--

LOCK TABLES `t_seo` WRITE;
/*!40000 ALTER TABLE `t_seo` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_seo` ENABLE KEYS */;
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
  `max_master` int DEFAULT '0' COMMENT '最大师傅数，0不限',
  `current_count` int DEFAULT '0' COMMENT '当前师傅数',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_service_category`
--

LOCK TABLES `t_service_category` WRITE;
/*!40000 ALTER TABLE `t_service_category` DISABLE KEYS */;
INSERT INTO `t_service_category` VALUES (1,'搬家货运','Moving','🚚','家庭搬家、货运服务',1,1,'2026-02-19 11:42:50',0,0),(2,'家政清洁','Cleaning','🧹','日常清洁、开荒清洁、深度清洁',2,1,'2026-02-19 11:42:50',0,0),(3,'园林景观','Gardening','🌳','草坪修剪、花园维护',3,1,'2026-02-19 11:42:50',0,0),(4,'刷漆修补','Painting','🎨','刷漆、补墙、小修小补',4,1,'2026-02-19 11:42:50',0,0),(5,'IT服务','IT Services','💻','电脑维修、网络安装',5,1,'2026-02-19 11:42:50',0,0),(6,'二手交易','Secondhand','🔄','二手物品交易',6,1,'2026-02-19 11:42:50',0,0),(7,'搬家货运','Moving','🚚',NULL,1,1,'2026-02-20 04:17:06',0,0),(8,'家政清洁','Cleaning','🧹',NULL,2,1,'2026-02-20 04:17:06',0,0),(9,'园林景观','Gardening','🌳',NULL,3,1,'2026-02-20 04:17:06',0,0),(10,'刷漆修补','Painting','🎨',NULL,4,1,'2026-02-20 04:17:06',0,0),(11,'IT服务','IT Services','💻',NULL,5,1,'2026-02-20 04:17:06',0,0),(12,'维修安装','Repair','🔧',NULL,6,1,'2026-02-20 04:17:06',0,0),(13,'接送服务','Transport','🚗',NULL,7,1,'2026-02-20 04:17:06',0,0),(14,'宠物服务','Pet Services','🐾',NULL,8,1,'2026-02-20 05:33:48',10,0),(15,'家电维修','Appliance Repair','🔌',NULL,9,1,'2026-02-20 05:33:48',15,0),(16,'水电维修','Plumbing & Electrical','💧',NULL,10,1,'2026-02-20 05:33:48',15,0),(17,'汽车维修','Auto Repair','🚗',NULL,11,1,'2026-02-20 05:33:48',20,0),(18,'会计服务','Accounting','📊',NULL,12,1,'2026-02-20 05:33:48',10,0),(19,'留学移民','Immigration','🎓',NULL,13,1,'2026-02-20 05:33:48',10,0);
/*!40000 ALTER TABLE `t_service_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_service_package`
--

DROP TABLE IF EXISTS `t_service_package`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_service_package` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `master_id` bigint NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text,
  `price` decimal(10,2) NOT NULL,
  `duration` int DEFAULT NULL COMMENT '分钟',
  `status` tinyint DEFAULT '1',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_service_package`
--

LOCK TABLES `t_service_package` WRITE;
/*!40000 ALTER TABLE `t_service_package` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_service_package` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_service_seo`
--

DROP TABLE IF EXISTS `t_service_seo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_service_seo` (
  `service_id` int NOT NULL,
  `title` varchar(200) DEFAULT NULL,
  `description` text,
  `keywords` varchar(500) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`service_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_service_seo`
--

LOCK TABLES `t_service_seo` WRITE;
/*!40000 ALTER TABLE `t_service_seo` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_service_seo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_service_type`
--

DROP TABLE IF EXISTS `t_service_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_service_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `icon` varchar(20) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_service_type`
--

LOCK TABLES `t_service_type` WRITE;
/*!40000 ALTER TABLE `t_service_type` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_service_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_settings`
--

DROP TABLE IF EXISTS `t_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_settings` (
  `id` int NOT NULL,
  `commission` decimal(5,2) DEFAULT '10.00',
  `phone` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `new_user_coupon` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_settings`
--

LOCK TABLES `t_settings` WRITE;
/*!40000 ALTER TABLE `t_settings` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_sms_log`
--

DROP TABLE IF EXISTS `t_sms_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_sms_log` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `phone` varchar(20) NOT NULL,
  `content` text,
  `type` varchar(20) DEFAULT NULL COMMENT 'order_accept/order_reject/order_complete',
  `status` tinyint DEFAULT '0' COMMENT '0待发送 1已发送 2失败',
  `sent_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_sms_log`
--

LOCK TABLES `t_sms_log` WRITE;
/*!40000 ALTER TABLE `t_sms_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_sms_log` ENABLE KEYS */;
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
  `address` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_user`
--

LOCK TABLES `t_user` WRITE;
/*!40000 ALTER TABLE `t_user` DISABLE KEYS */;
INSERT INTO `t_user` VALUES (1,'测试','0421000000',NULL,'$2a$10$lMoyueDb8wuksB.50XIfZO2YB41QsxUhCX24KV/V1b7FaChQB/IgK',NULL,NULL,1,'2026-02-19 11:54:36','2026-02-19 12:17:34',NULL),(2,'测试师傅','0421111222',NULL,'$2a$10$lMoyueDb8wuksB.50XIfZO2YB41QsxUhCX24KV/V1b7FaChQB/IgK',NULL,NULL,1,'2026-02-19 11:55:48','2026-02-19 12:17:34',NULL),(3,'JINGAN','0401976555',NULL,'$2a$10$lMoyueDb8wuksB.50XIfZO2YB41QsxUhCX24KV/V1b7FaChQB/IgK',NULL,NULL,1,'2026-02-19 11:56:29','2026-02-19 12:17:34',NULL),(4,'雪狼','040333678',NULL,'$2a$10$lMoyueDb8wuksB.50XIfZO2YB41QsxUhCX24KV/V1b7FaChQB/IgK',NULL,NULL,1,'2026-02-19 11:59:52','2026-02-19 12:17:34',NULL),(5,'测试用户','0400000001',NULL,'$2a$10$lMoyueDb8wuksB.50XIfZO2YB41QsxUhCX24KV/V1b7FaChQB/IgK',NULL,NULL,1,'2026-02-19 12:07:07','2026-02-19 12:17:34',NULL),(6,'用户B','0403333678',NULL,'$2a$10$lMoyueDb8wuksB.50XIfZO2YB41QsxUhCX24KV/V1b7FaChQB/IgK',NULL,NULL,1,'2026-02-19 12:08:32','2026-02-19 12:17:34',NULL),(7,'0400000000','0400000000',NULL,'$2a$10$17MLVvQm5mXnnukKD1Mzae0tbL/mg4hrHJZ1Erewny0Tx.EXYeZLa',NULL,NULL,1,'2026-02-19 12:44:35','2026-02-19 12:44:35',NULL),(8,'王师傅','0401111111',NULL,'$2a$10$xxxx',NULL,NULL,1,'2026-02-20 06:20:06','2026-02-20 06:20:06',NULL),(9,'李师傅','0402222222',NULL,'$2a$10$xxxx',NULL,NULL,1,'2026-02-20 06:20:06','2026-02-20 06:20:06',NULL),(10,'张师傅','0403333333',NULL,'$2a$10$xxxx',NULL,NULL,1,'2026-02-20 06:20:06','2026-02-20 06:20:06',NULL),(11,'赵师傅','0404444444',NULL,'$2a$10$xxxx',NULL,NULL,1,'2026-02-20 06:20:44','2026-02-20 06:20:44',NULL),(12,'孙师傅','0405555555',NULL,'$2a$10$xxxx',NULL,NULL,1,'2026-02-20 06:20:44','2026-02-20 06:20:44',NULL),(13,'周师傅','0406666666',NULL,'$2a$10$xxxx',NULL,NULL,1,'2026-02-20 06:20:44','2026-02-20 06:20:44',NULL),(14,'040000000','040000000',NULL,'$2a$10$nTXKaZz.NcViUiNQn8ln.OcX/WawulZ7NpJz6wiLWGG/3145lS8eq',NULL,NULL,1,'2026-02-20 09:44:39','2026-02-20 09:44:39',NULL);
/*!40000 ALTER TABLE `t_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_user_coupon`
--

DROP TABLE IF EXISTS `t_user_coupon`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_user_coupon` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `coupon_id` bigint NOT NULL,
  `status` tinyint DEFAULT '0' COMMENT '0未使用 1已使用',
  `used_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_user_coupon`
--

LOCK TABLES `t_user_coupon` WRITE;
/*!40000 ALTER TABLE `t_user_coupon` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_user_coupon` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-02-21  3:00:01
