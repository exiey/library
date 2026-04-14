-- MySQL dump 10.13  Distrib 5.7.26, for Win64 (x86_64)
--
-- Host: localhost    Database: zanzuoyuyueui3jifenqiandao3_up_ssm2
-- ------------------------------------------------------
-- Server version	5.7.26

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `wct_address`
--

DROP TABLE IF EXISTS `wct_address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wct_address` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `uid` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wct_address`
--

LOCK TABLES `wct_address` WRITE;
/*!40000 ALTER TABLE `wct_address` DISABLE KEYS */;
INSERT INTO `wct_address` VALUES (41,'小米 15123385885 某某地址',76),(42,'小王 15123385885 某某地址',54),(44,'小王 15123375775 3232453452345345',71),(45,'小王 15123385885 6-120',70);
/*!40000 ALTER TABLE `wct_address` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wct_bill`
--

DROP TABLE IF EXISTS `wct_bill`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wct_bill` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `gids` varchar(100) DEFAULT NULL,
  `user` varchar(100) DEFAULT NULL,
  `uid` varchar(100) DEFAULT NULL,
  `ndate` varchar(255) DEFAULT NULL,
  `total` varchar(255) DEFAULT NULL,
  `gnames` varchar(500) DEFAULT NULL,
  `address` varchar(50) DEFAULT NULL,
  `note` varchar(200) DEFAULT NULL,
  `statecn` varchar(50) DEFAULT NULL,
  `gcounts` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wct_bill`
--

LOCK TABLES `wct_bill` WRITE;
/*!40000 ALTER TABLE `wct_bill` DISABLE KEYS */;
INSERT INTO `wct_bill` VALUES (17,'7','user1','71','2026-04-13 14:09:52','10','螃蟹*1','小王 15123375775 3232453452345345','','已付款','1'),(18,'8','user1','71','2026-04-14 14:51:55','10','豹子*1','小王 15123375775 3232453452345345','','已付款','1'),(19,'6','user1','71','2026-04-14 14:51:49','10','小牛*1','小王 15123375775 3232453452345345','','已付款','1'),(20,'11','user2','70','2026-04-14 09:06:50','10','台灯*1','小王 15123385885 6-120','','已付款','1'),(21,'10','user2','70','2026-04-13 09:07:00','10','电脑*1','小王 15123385885 6-120','','已付款','1'),(22,'9','user2','70','2026-04-13 09:07:10','10','书籍*1','小王 15123385885 6-120','111111','已付款','1');
/*!40000 ALTER TABLE `wct_bill` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wct_blog`
--

DROP TABLE IF EXISTS `wct_blog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wct_blog` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `title` varchar(50) DEFAULT NULL COMMENT '标题',
  `note` varchar(5000) DEFAULT NULL COMMENT '内容',
  `ndate` varchar(50) DEFAULT NULL COMMENT '日期',
  `img` varchar(200) DEFAULT NULL COMMENT '图片',
  `uid` int(11) DEFAULT NULL COMMENT '发布者id',
  `username` varchar(255) DEFAULT NULL COMMENT '发布者姓名',
  `favcount` int(11) DEFAULT NULL COMMENT '收藏次数',
  `zan` int(10) DEFAULT '1' COMMENT '点赞次数',
  `address` varchar(255) DEFAULT NULL COMMENT '地址',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8 COMMENT='分享交流表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wct_blog`
--

LOCK TABLES `wct_blog` WRITE;
/*!40000 ALTER TABLE `wct_blog` DISABLE KEYS */;
INSERT INTO `wct_blog` VALUES (10,'测试发帖','<p>详细的交流发帖</p>','2026-04-14 11:44:44','bf1b7476-a973-4779-b93e-7d3ceb5c66fc.jpeg',70,'小走',1,2,''),(11,'测试发帖哈哈','<p>撒旦发射点发</p>','2026-04-14 14:21:21','1deb7617-80ce-43db-9ba1-20c8f427914e.jpg',68,'ideabobo',2,6,''),(12,'一起来聊聊学习','<p>这里是详细的发忒内容哈哈</p>','2026-04-15 13:51:02','171ad5e3-a9db-4334-b223-8846cabbf9c7.jpg',68,'ideabobo',1,2,''),(13,'测试交流','<p>自己可以图文编辑帖子发帖交流互动</p>','2026-04-14 09:38:19','',68,'ideabobo',NULL,1,''),(14,'测试发帖','<p>这里自己可以图文发帖,大家一起交流讨论</p>','2026-04-15 14:54:18','',70,'user2',NULL,1,''),(15,'可以发帖相互交流','<p>详细的交流内容</p><p><img src=\"http://localhost:8088/upload/eeedd897-2767-4339-aa0d-3ce1a129551f.jpg\" alt=\"图片\"></p><p><br></p>','2026-04-15 14:59:46','',71,'user1',1,2,''),(16,'分享一个考研技巧','<p>这里自己图文编辑帖子,这些都是丰富功能</p>','2026-04-13 22:48:50','',71,'user1',NULL,1,''),(17,'测试交流发帖','<p>这里图文编辑帖子内容</p><p><img src=\"http://localhost:8088/upload/1934a866-7421-476a-9b31-6c245fd06b4e.jpg\" alt=\"图片\"></p><p><br></p>','2026-04-15 14:09:57','3abb5df7-0a16-443c-aad0-8782d8c296c0.jpg',71,'user1',NULL,1,''),(18,'一起去自习区自习吧','<p>图文编辑详情内容</p>','2026-04-14 11:45:29','7c0f19f2-578c-4127-a662-bb25ae49e623.jpg',71,'user1',NULL,1,''),(19,'一起来分享学习经验','<p>这里自己图文编辑帖子,<img src=\"http://localhost:8088/upload/8a56254a-ea4c-41f9-a19e-e4ac65fdb54c.jpg\" alt=\"图片\"></p>','2026-04-13 14:21:51','',71,'user1',NULL,1,'');
/*!40000 ALTER TABLE `wct_blog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wct_good`
--

DROP TABLE IF EXISTS `wct_good`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wct_good` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `gname` varchar(100) DEFAULT NULL,
  `price` varchar(10) DEFAULT NULL,
  `note` varchar(2000) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `img` varchar(500) DEFAULT NULL,
  `typeid` varchar(10) DEFAULT NULL,
  `btype` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wct_good`
--

LOCK TABLES `wct_good` WRITE;
/*!40000 ALTER TABLE `wct_good` DISABLE KEYS */;
INSERT INTO `wct_good` VALUES (5,'小章鱼','10','','小动物','b1f87783-c3ff-43f0-9832-4b9434282662.png','24','1'),(6,'小牛','10','','小动物','ab9a0fc3-ab4b-4c2a-90c8-e6d91ae46beb.png','24','1'),(7,'螃蟹','10','','精美','122bb107-5c37-42b9-af51-da5eb36f789b.png','27','1'),(8,'豹子','10','','精美','57d1ee0f-1ac7-40da-86df-6029418093c7.png','27','1'),(9,'书籍','10','','桌面用品','e247f30a-bf63-456a-9889-32787936d059.png','28','1'),(10,'电脑','10','','桌面用品','2b1ab696-d940-4839-8c52-f0c7b1eaec70.png','28','1'),(11,'台灯','10','','桌面用品','97056ade-2a22-4572-86cb-b6fb90e18a2b.png','28','1');
/*!40000 ALTER TABLE `wct_good` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wct_notice`
--

DROP TABLE IF EXISTS `wct_notice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wct_notice` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(50) DEFAULT NULL COMMENT '标题',
  `note` varchar(500) DEFAULT NULL COMMENT '内容',
  `ndate` varchar(50) DEFAULT NULL COMMENT '日期',
  `type` varchar(50) DEFAULT NULL COMMENT '类型',
  `img` varchar(200) DEFAULT NULL COMMENT '配图',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='资讯公告表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wct_notice`
--

LOCK TABLES `wct_notice` WRITE;
/*!40000 ALTER TABLE `wct_notice` DISABLE KEYS */;
INSERT INTO `wct_notice` VALUES (19,'测试资讯','<p>发布一些通知公告啥的</p><p><img src=\"upload/82aad65a-ca40-4a26-b6ac-325f951a9952.jpg\" style=\"max-width:100%;\"/><br/></p>','2026-04-15 14:45:36','1','0aea145e-00e1-4e92-8b8e-066a0d92f29e.jpg'),(20,'测试公告','<p>同样的自己详细编辑</p>','2026-04-15 14:45:52','1','627a6cd1-5da7-4506-adb8-7afab905679c.jpg'),(21,'信息知识活动','<p>详细的介绍信息</p><p><img src=\"upload/aa1e33bb-6a87-4e7b-904f-4bc41696a9f1.jpg\" style=\"max-width:100%;\"/><br/></p><p><img src=\"upload/707adedc-b351-4c59-999b-73aec8abe02a.jpg\" style=\"max-width:100%;\"/><br/></p>','2026-04-15 10:03:04','2','975a319f-06c6-44a8-941e-2e6b37c4e5f4.jpg'),(22,'信誉手册','<p>这里自己编辑预约规则,信誉手册指南等,同样的可以多图可以视频都是可以的</p><p><img src=\"upload/2c5309ca-ec11-4755-b51b-e9a7eb820849.jpg\" style=\"max-width:100%;\"/><br/></p>','2026-04-13 10:26:18','3','e76c1b46-96c2-4492-9728-66734c8a59d1.jpg');
/*!40000 ALTER TABLE `wct_notice` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wct_posts`
--

DROP TABLE IF EXISTS `wct_posts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wct_posts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(50) DEFAULT NULL COMMENT '标题',
  `note` varchar(500) DEFAULT NULL COMMENT '内容',
  `uid` varchar(10) DEFAULT NULL COMMENT '用户id',
  `username` varchar(200) DEFAULT NULL COMMENT '用户名',
  `ndate` varchar(50) DEFAULT NULL COMMENT '日期',
  `img` varchar(255) DEFAULT NULL COMMENT '配图',
  `type` varchar(255) DEFAULT NULL COMMENT '类型',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8 COMMENT='留言反馈表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wct_posts`
--

LOCK TABLES `wct_posts` WRITE;
/*!40000 ALTER TABLE `wct_posts` DISABLE KEYS */;
INSERT INTO `wct_posts` VALUES (40,'发帖交流','<p>详细的反馈交流内容</p>','70','小走','2026-04-13 08:44:26','','1'),(42,'发帖反馈交流','<p>啊大是大非</p>','68','ideabobo','2026-04-14 08:32:18','','1'),(43,'还可以相互交流发帖','<p>详细的交流发帖内容呵呵</p>','71','user1','2026-04-13 09:46:28','','1');
/*!40000 ALTER TABLE `wct_posts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wct_replay`
--

DROP TABLE IF EXISTS `wct_replay`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wct_replay` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pid` varchar(10) DEFAULT NULL COMMENT '父id',
  `note` varchar(500) DEFAULT NULL COMMENT '内容',
  `uid` varchar(10) DEFAULT NULL COMMENT '用户id',
  `username` varchar(200) DEFAULT NULL COMMENT '用户名',
  `ndate` varchar(50) DEFAULT NULL COMMENT '日期',
  `type` int(11) DEFAULT NULL COMMENT '类型',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=72 DEFAULT CHARSET=utf8 COMMENT='回复表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wct_replay`
--

LOCK TABLES `wct_replay` WRITE;
/*!40000 ALTER TABLE `wct_replay` DISABLE KEYS */;
INSERT INTO `wct_replay` VALUES (28,'7','士大夫','68','ideabobo','2026-04-13 11:05:10',1),(29,'39','回复用户反馈','','','2026-04-15 11:34:08',NULL),(30,'39','回复反馈交流','','','2026-04-13 08:34:54',NULL),(31,'39','回复用户方发布的反馈建议等','','','2026-04-14 10:26:51',NULL),(32,'40','大家都可以评论','68','ideabobo','2026-04-14 10:36:42',3),(33,'39','回复用户反馈','','','2026-04-14 08:30:25',NULL),(34,'39','回复用户反馈','','','2026-04-13 18:33:17',NULL),(35,'43','这儿交流','68','ideabobo','2026-04-13 19:48:08',3),(36,'43','相互回帖','68','ideabobo','2026-04-15 19:48:12',3),(37,'44','相互留言反馈','68','ideabobo','2026-04-14 19:48:42',3),(38,'44','相互评论交流','68','ideabobo','2026-04-13 19:49:34',3),(39,'39','回复反馈留言','','','2026-04-14 08:52:01',NULL),(40,'39','回复用户留言反馈','','','2026-04-15 11:06:04',NULL),(41,'39','回复用户反馈','','','2026-04-14 17:11:29',NULL),(42,'11','阿萨德发','68','ideabobo','2026-04-15 17:16:22',2),(43,'10','回复用户交流反馈','','','2026-04-14 14:22:46',NULL),(44,'39','回复用户反馈','','','2026-04-14 13:47:20',NULL),(45,'10','回复发帖交流','','','2026-04-15 16:25:36',NULL),(46,'11','实打实地方','68','ideabobo','2026-04-15 16:30:34',2),(47,'39','回复交流反馈','69','admin','2026-04-14 09:11:28',3),(48,'11','发帖交流相互评论','68','ideabobo','2026-04-14 09:14:56',2),(49,'10','回复交流讨论','','','2026-04-14 09:36:42',NULL),(50,'11','阿萨德发','68','ideabobo','2026-04-13 09:38:26',2),(51,'10','回复交流论坛','','','2026-04-13 14:46:02',NULL),(52,'39','回复留言反馈','69','admin','2026-04-14 09:33:02',3),(53,'39','回复反馈','69','admin','2026-04-13 22:46:38',3),(54,'39','回复用户反馈','69','admin','2026-04-13 16:44:10',3),(55,'39','回复留言反馈','69','admin','2026-04-14 14:53:16',3),(56,'39','回复交流反馈','69','admin','2026-04-14 14:55:22',3),(57,'15','互动发帖交流','71','user1','2026-04-15 14:59:51',2),(58,'10','回复交流','','','2026-04-13 14:14:36',NULL),(59,'10','回复交流评论','','','2026-04-13 14:44:51',NULL),(60,'13','fdasdf','72','user3','2026-04-15 14:47:04',2),(61,'39','回复交流反馈','69','admin','2026-04-14 11:42:06',3),(62,'10','可以相互发帖交流,','71','user1','2026-04-13 11:45:02',2),(63,'39','回复交流反馈','69','admin','2026-04-15 14:18:25',3),(64,'11','bucuo','71','user1','2026-04-15 14:21:24',2),(65,'11','相互交流发帖学习','71','user1','2026-04-14 20:42:05',2),(66,'39','回复交流讨论','69','admin','2026-04-13 20:46:23',3),(67,'42','交流反馈','71','user1','2026-04-14 16:29:18',3),(68,'40','回复交流反馈','69','admin','2026-04-14 16:33:40',3),(69,'40','回复教练反馈','69','admin','2026-04-15 09:37:06',3),(70,'42','可以','71','user1','2026-04-13 09:39:11',3),(71,'40','回复用户反馈','69','admin','2026-04-13 09:43:41',3);
/*!40000 ALTER TABLE `wct_replay` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wct_room`
--

DROP TABLE IF EXISTS `wct_room`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wct_room` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(50) DEFAULT NULL COMMENT '标题',
  `note` varchar(500) DEFAULT NULL COMMENT '内容',
  `ndate` varchar(50) DEFAULT NULL COMMENT '日期',
  `img` varchar(255) DEFAULT NULL COMMENT '配图',
  `type` varchar(255) DEFAULT NULL COMMENT '类型',
  `total` varchar(255) DEFAULT NULL COMMENT '价格',
  `sid` int(11) DEFAULT NULL,
  `shop` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8 COMMENT='自习室表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wct_room`
--

LOCK TABLES `wct_room` WRITE;
/*!40000 ALTER TABLE `wct_room` DISABLE KEYS */;
INSERT INTO `wct_room` VALUES (39,'一楼1203','<p>这儿先添加教室,然后根据教室管理座位,这样就能跟踪到座位的状态</p><p>这里是详细的自习室介绍</p><p><br/></p>','2026-04-14 11:37:46','d2a280be-ed4a-4c72-9f4a-16fc2514bd37.jpg','小自习室','10',7,'第一自习区'),(40,'二楼2208','<p>关于计算机方面的学习</p>','2026-04-14 09:40:44','f9d192de-a408-4ab3-bc62-02fb24364c49.jpeg','小自习室','10',7,'第一自习区'),(41,'三楼','<p>这里是教室的介绍什么什么的</p>','2026-04-14 13:56:55','c3df758d-9ab3-4823-9075-41e0443db4da.jpg','中自习室','10',7,'第一自习区');
/*!40000 ALTER TABLE `wct_room` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wct_shiduan`
--

DROP TABLE IF EXISTS `wct_shiduan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wct_shiduan` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(500) DEFAULT NULL COMMENT '标题',
  `note` varchar(5000) DEFAULT NULL COMMENT '备注',
  `ndate` varchar(255) DEFAULT NULL COMMENT '日期',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='时段表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wct_shiduan`
--

LOCK TABLES `wct_shiduan` WRITE;
/*!40000 ALTER TABLE `wct_shiduan` DISABLE KEYS */;
INSERT INTO `wct_shiduan` VALUES (12,'08:00-09:00','','2026-04-14 09:46:10'),(13,'09:00-10:00','','2026-04-13 09:46:17'),(14,'10:00-11:00','','2026-04-14 09:46:22'),(15,'11:00-12:00','','2026-04-13 09:46:29'),(16,'14:00-15:00','','2026-04-14 09:46:37'),(17,'15:00-16:00','','2026-04-13 09:46:42'),(18,'16:00-17:00','','2026-04-14 09:46:51'),(19,'17:00-18:00','','2026-04-15 09:47:00'),(20,'20:00-21:00','','2026-04-13 11:44:49');
/*!40000 ALTER TABLE `wct_shiduan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wct_shop`
--

DROP TABLE IF EXISTS `wct_shop`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wct_shop` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sname` varchar(100) DEFAULT NULL COMMENT '名称',
  `img` varchar(500) DEFAULT NULL COMMENT '配图',
  `note` varchar(500) DEFAULT NULL COMMENT '内容',
  `address` varchar(500) DEFAULT NULL COMMENT '地址',
  `longitude` varchar(100) DEFAULT NULL COMMENT '经度',
  `latitude` varchar(100) DEFAULT NULL COMMENT '纬度',
  `tel` varchar(100) DEFAULT NULL COMMENT '电话',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COMMENT='教室表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wct_shop`
--

LOCK TABLES `wct_shop` WRITE;
/*!40000 ALTER TABLE `wct_shop` DISABLE KEYS */;
INSERT INTO `wct_shop` VALUES (7,'第一图书馆','9bec09b8-c77e-4989-bb61-2f91586db17a.jpg','<p>详细的介绍信息</p><p><img src=\"upload/be59b32e-939e-4c1c-b8ad-5798f02118d6.jpg\" style=\"max-width:100%;\"/><br/></p><p><img src=\"upload/d40c4596-87ce-4804-94cf-010fd1f5dea5.jpg\" style=\"max-width:100%;\"/><br/></p>','重庆市沙坪坝区曾家镇西区二路66号','106.326058','29.573864','15123385885'),(8,'第二图书馆','78d16863-fd1c-4368-a33d-b1c7122157f5.jpg','<p>这里是详细的教室介绍信息</p><p><img src=\"upload/8f231934-1925-4a20-8b59-fd933fbd81fc.jpg\" style=\"max-width:100%;\"/></p><p><img src=\"upload/9fa95dc8-40bf-4e7a-a25c-ecd1a27dc94e.jpg\" style=\"max-width:100%;\"/></p>','重庆市璧山区','106.1882306268005','29.576887232911915','15123385885');
/*!40000 ALTER TABLE `wct_shop` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wct_site`
--

DROP TABLE IF EXISTS `wct_site`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wct_site` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pid` varchar(10) DEFAULT NULL COMMENT '自习室id',
  `note` varchar(500) DEFAULT NULL COMMENT '备注',
  `ndate` varchar(50) DEFAULT NULL COMMENT '更新日期',
  `title` varchar(255) DEFAULT NULL COMMENT '编号',
  `statecn` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=62 DEFAULT CHARSET=utf8 COMMENT='座位表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wct_site`
--

LOCK TABLES `wct_site` WRITE;
/*!40000 ALTER TABLE `wct_site` DISABLE KEYS */;
INSERT INTO `wct_site` VALUES (28,'39','靠窗','2026-04-15 08:42:08','a0001','维修中'),(29,'39','','2026-04-15 11:37:53','a0002','维修中'),(30,'41','','2026-04-15 11:32:22','a1001','正常'),(31,'41','','2026-04-13 11:32:26','a1002','正常'),(32,'41','','2026-04-13 11:32:30','a1003','正常'),(33,'41','','2026-04-14 11:32:37','a1004','正常'),(34,'42','','2026-04-15 08:33:33','A01','正常'),(35,'42','','2026-04-14 08:33:37','A02','正常'),(36,'42','','2026-04-14 08:33:42','A03','正常'),(37,'39','','2026-04-13 10:24:31','A003','正常'),(38,'40','','2026-04-15 08:28:51','B001','正常'),(39,'40','','2026-04-15 08:28:55','B002','正常'),(40,'39','','2026-04-13 18:32:24','A004','正常'),(41,'39','','2026-04-14 08:50:50','A005','正常'),(42,'39','','2026-04-14 11:05:04','B2003','正常'),(43,'39','','2026-04-15 16:47:36','V001','正常'),(44,'39','靠窗','2026-04-15 09:10:07','V003','正常'),(45,'39','','2026-04-13 13:45:30','B004','正常'),(46,'39','','2026-04-13 16:24:10','C1001','正常'),(47,'39','','2026-04-15 09:10:00','c002','正常'),(48,'40','','2026-04-15 09:35:05','B003','正常'),(49,'42','靠窗','2026-04-14 14:44:24','A04','正常'),(50,'39','','2026-04-14 09:31:44','C003','正常'),(51,'42','','2026-04-14 22:45:19','A05','正常'),(52,'43','','2026-04-15 16:45:12','001','正常'),(53,'39','','2026-04-14 08:42:50','a0092','维修中'),(54,'39','','2026-04-14 14:54:39','a0100','正常'),(55,'39','','2026-04-15 14:13:57','V004','正常'),(56,'40','','2026-04-14 14:44:16','B004','正常'),(57,'40','靠过道','2026-04-15 14:17:45','B005','正常'),(58,'44','靠窗','2026-04-13 20:45:53','A001','正常'),(59,'41','靠窗','2026-04-13 09:36:23','A101','正常'),(60,'40','中间','2026-04-13 09:41:01','B001','正常'),(61,'41','中间','2026-04-13 09:43:08','A006','正常');
/*!40000 ALTER TABLE `wct_site` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wct_type`
--

DROP TABLE IF EXISTS `wct_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wct_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(500) DEFAULT NULL,
  `note` varchar(5000) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wct_type`
--

LOCK TABLES `wct_type` WRITE;
/*!40000 ALTER TABLE `wct_type` DISABLE KEYS */;
/*!40000 ALTER TABLE `wct_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wct_type2`
--

DROP TABLE IF EXISTS `wct_type2`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wct_type2` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(500) DEFAULT NULL,
  `note` varchar(5000) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wct_type2`
--

LOCK TABLES `wct_type2` WRITE;
/*!40000 ALTER TABLE `wct_type2` DISABLE KEYS */;
INSERT INTO `wct_type2` VALUES (24,'小动物',''),(25,'小植物',''),(26,'卡通玩偶',''),(27,'精美',''),(28,'桌面用品','');
/*!40000 ALTER TABLE `wct_type2` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wct_user`
--

DROP TABLE IF EXISTS `wct_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wct_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) DEFAULT NULL COMMENT '用户名',
  `passwd` varchar(50) DEFAULT NULL COMMENT '密码',
  `roletype` varchar(50) DEFAULT NULL COMMENT '角色',
  `email` varchar(200) DEFAULT NULL COMMENT '邮箱',
  `tel` varchar(50) DEFAULT NULL COMMENT '电话',
  `sex` varchar(20) DEFAULT NULL COMMENT '性别',
  `img` varchar(200) DEFAULT NULL COMMENT '头像',
  `favs` varchar(200) DEFAULT NULL COMMENT '收藏合集',
  `openid` varchar(200) DEFAULT NULL COMMENT '微信openid',
  `jifen` int(255) DEFAULT '10' COMMENT '积分',
  `fname` varchar(255) DEFAULT NULL COMMENT '姓名',
  `idcard` varchar(255) DEFAULT NULL COMMENT '身份证',
  `money` varchar(255) DEFAULT NULL COMMENT '余额',
  `sid` int(11) DEFAULT NULL,
  `shop` varchar(255) DEFAULT NULL,
  `desktop` varchar(5000) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=74 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='用户表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wct_user`
--

LOCK TABLES `wct_user` WRITE;
/*!40000 ALTER TABLE `wct_user` DISABLE KEYS */;
INSERT INTO `wct_user` VALUES (68,'ideabobo','111111','5','','15123385885','女','4114eca6-3761-4e37-bb01-7177b7bc4417.png','48,40,39,11,41,12,42','',10,'xiaomi',NULL,'200',NULL,NULL,NULL),(69,'admin','admin','1',NULL,NULL,NULL,NULL,NULL,NULL,10,NULL,NULL,NULL,NULL,NULL,NULL),(70,'user2','111111','2','','15122273773','女','a4bd7652-1e0b-47c7-8fc5-59f0b6ea67f7.jpeg','49,40,42','oe-Zu5opGF3DAuEKmhHvy6zIted0',10,'小走',NULL,'50',NULL,NULL,'eyJpdGVtcyI6W3siaWQiOjksImltZyI6ImUyNDdmMzBhLWJmNjMtNDU2YS05ODg5LTMyNzg3OTM2ZDA1OS5wbmciLCJ4IjoxNTMuNCwieSI6MzkuM30seyJpZCI6MTAsImltZyI6IjJiMWFiNjk2LWQ5NDAtNDgzOS04YzUyLWYwYzdiMWVhZWM3MC5wbmciLCJ4Ijo1NiwieSI6MzMuOX0seyJpZCI6MTEsImltZyI6Ijk3MDU2YWRlLTJhMjItNDU3Mi04NmNiLWI2ZmI5MGUxOGEyYi5wbmciLCJ4IjoyNDIuNiwieSI6NDJ9XSwiYmdDb2xvciI6IiNmZmZmZmYifQ=='),(71,'user1','111111','2','','15123395995','女','65135241-c454-4e32-95ff-0f1939706af2.jpg','42,40,43,15,11,10,39,41','12345678',10,'xiaomi','','868',NULL,NULL,'eyJpdGVtcyI6W3siaWQiOjYsImltZyI6ImFiOWEwZmMzLWFiNGItNGMyYS05MGM4LWU2ZDkxYWU0NmJlYi5wbmciLCJ4IjozMiwieSI6MTM2LjZ9LHsiaWQiOjcsImltZyI6IjEyMmJiMTA3LTVjMzctNDJiOS1hZjUxLWRhNWViMzZmNzg5Yi5wbmciLCJ4IjoyMDMuMywieSI6MTM0fSx7ImlkIjo4LCJpbWciOiI1N2QxZWUwZi0xYWM3LTQwZGEtODZkZi02MDI5NDE4MDkzYzcucG5nIiwieCI6MTM2LCJ5IjoyNDAuNn1dLCJiZ0NvbG9yIjoiI2ZmZmZmZiJ9'),(72,'user3','111111','2','','16123395995','女','2e7e29d9-0f5a-4c87-a86c-5e9033d957b7.jpg','','9876543321',10,'xiawang','','',8,'',NULL),(73,'user6','111111','2','','15123385885','女','9310783f-b77a-47dd-b47e-6d6ad4b8db3f.jpg','','',10,'小王','','',NULL,'',NULL);
/*!40000 ALTER TABLE `wct_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wct_yuyue`
--

DROP TABLE IF EXISTS `wct_yuyue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wct_yuyue` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sid` int(100) DEFAULT NULL COMMENT '教室id',
  `username` varchar(100) DEFAULT NULL COMMENT '用户名',
  `uid` varchar(100) DEFAULT NULL COMMENT '用户id',
  `shop` varchar(100) DEFAULT NULL COMMENT '教室',
  `ndate` varchar(255) DEFAULT NULL COMMENT '更新日期',
  `total` varchar(255) DEFAULT NULL COMMENT '金额',
  `ydate` varchar(50) DEFAULT NULL COMMENT '预约日期',
  `typecn` varchar(500) DEFAULT NULL COMMENT '分类',
  `typeid` int(10) DEFAULT NULL COMMENT '分类id',
  `tel` varchar(50) DEFAULT NULL COMMENT '联系电话',
  `note` varchar(200) DEFAULT NULL COMMENT '备注',
  `statecn` varchar(50) DEFAULT NULL COMMENT '状态',
  `pnote` varchar(255) DEFAULT NULL COMMENT '评论',
  `pf` varchar(255) DEFAULT NULL COMMENT '评分',
  `lxr` varchar(255) DEFAULT NULL COMMENT '联系人',
  `roomid` int(11) DEFAULT NULL COMMENT '自习室id',
  `site` varchar(255) DEFAULT NULL COMMENT '座位',
  `siteid` int(11) DEFAULT NULL COMMENT '座位id',
  `shiduan` varchar(255) DEFAULT NULL COMMENT '时段',
  `room` varchar(255) DEFAULT NULL COMMENT '自习室',
  `shiduanid` int(11) DEFAULT NULL COMMENT '时段id',
  `stime` varchar(255) DEFAULT NULL,
  `etime` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=180 DEFAULT CHARSET=utf8 COMMENT='预约表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wct_yuyue`
--

LOCK TABLES `wct_yuyue` WRITE;
/*!40000 ALTER TABLE `wct_yuyue` DISABLE KEYS */;
INSERT INTO `wct_yuyue` VALUES (160,NULL,'user3','72','','2026-04-13 14:47:48','10','2026-04-14','',NULL,'16123395995','','已完成','pingfen','5','',39,'V004',55,'14:00-15:00','一楼1101',16,'2026-04-14 14:40:32','2026-04-15 16:40:39'),(161,NULL,'user1','71','','2026-04-15 20:41:15','10','2026-04-14','违规',NULL,'15123395995','','已完成','','','',39,'a0100',54,'14:00-15:00','一楼1101',16,'2026-04-14 14:40:32','2026-04-14 16:40:39'),(162,NULL,'user1','71','','2026-04-14 11:46:07','10','2026-04-15','',NULL,'15123395995','','已完成','','','',39,'a0092',53,'16:00-17:00','一楼1101',18,'2026-04-15 14:40:32','2026-04-13 16:40:39'),(163,NULL,'user1','71','','2026-04-15 14:20:22','15','2026-04-14','',NULL,'15123395995','','已完成','','','',42,'A05',51,'20:00-21:00','2201',20,'2026-04-15 14:40:32','2026-04-14 16:40:39'),(164,NULL,'user1','71','','2026-04-15 14:22:40','10','2026-04-14','',NULL,'15123395995','','已完成','真好','5','',39,'A003',37,'09:00-10:00','一楼1101',13,'2026-04-13 14:40:32','2026-04-14 16:40:39'),(165,NULL,'user1','71','','2026-04-14 20:38:51','10','2026-04-15','',NULL,'15123395995','','已完成','','','',43,'001',52,'20:00-21:00','3301',20,'2026-04-15 14:40:32','2026-04-15 16:40:39'),(166,NULL,'user1','71','','2026-04-15 20:43:01','10','2026-04-15','',NULL,'15123395995','','已完成','','','',39,'A003',37,'15:00-16:00','一楼1101',17,'2026-04-14 14:40:32','2026-04-15 16:40:39'),(167,NULL,'user1','71','','2026-04-14 16:28:17','10','2026-04-15','',NULL,'15123395995','','已完成','','','',39,'C003',50,'16:00-17:00','一楼1101',18,'2026-04-14 14:40:32','2026-04-14 16:40:39'),(168,NULL,'user1','71','','2026-04-14 16:30:08','10','2026-04-13','',NULL,'15123395995','','已完成','真不错','5','',41,'a1001',30,'17:00-18:00','一楼1103',19,'2026-04-13 14:40:32','2026-04-14 16:40:39'),(169,NULL,'user1','71','','2026-04-15 09:37:53','10','2026-04-14','',NULL,'15123395995','','已完成','','','',40,'B002',39,'15:00-16:00','一楼1102',17,'2026-04-15 14:40:32','2026-04-14 16:40:39'),(170,NULL,'user1','71','','2026-04-15 09:40:37','10','2026-04-14','',NULL,'15123395995','','已完成','评价','4','',40,'B001',38,'17:00-18:00','一楼1102',19,'2026-04-13 14:40:32','2026-04-13 16:40:39'),(171,7,'user1','71','第一自习区','2026-04-15 14:32:45','10','2026-04-14','',NULL,'15123395995','','已完成','','','',41,'A101',59,'09:00-10:00','三楼',13,'2026-04-13 14:40:32','2026-04-15 16:40:39'),(172,7,'user1','71','第一自习区','2026-04-15 14:40:39','0','2026-04-13','',NULL,'15123395995','','已完成','','','',39,'C003',50,'11:00-12:00','一楼',15,'2026-04-15 14:40:32','2026-04-15 16:40:39'),(173,7,'user2','70','第一自习区','2026-04-14 15:04:24','0','2026-04-14','',NULL,'15122273773','','已完成','','','',39,'A004',40,'09:00-10:00','一楼',13,'2026-04-13 15:04:24','2026-04-15 16:40:39'),(174,7,'user3','72','第一自习区','2026-04-13 15:06:04','0','2026-04-15','',NULL,'16123395995','','已完成','','','',41,'a1002',31,'09:00-10:00','三楼',13,'2026-04-14 15:06:04','2026-04-15 16:40:39'),(175,7,'user1','71','第一自习区','2026-04-14 08:49:28','0','2026-04-15','',NULL,'15123395995','','已完成','','','',39,'a0002',29,'09:00-10:00','一楼',13,'2026-04-14 14:40:32','2026-04-15 16:40:39'),(176,7,'user1','71','第一自习区','2026-04-15 09:03:02','0','2026-04-14','',NULL,'15123395995','','已预约','','','',39,'a0002',29,'10:00-11:00','一楼',14,'',''),(177,7,'user1','71','第一自习区','2026-04-13 09:39:19','0','2026-04-15','',NULL,'15123395995','','已预约','','','',39,'C003',50,'16:00-17:00','一楼1203',18,'',''),(178,7,'user1','71','第一自习区','2026-04-13 09:47:29','0','2026-04-13','',NULL,'15123395995','','已评价','非常不错,很干净','5','',39,'V003',44,'10:00-11:00','一楼1203',14,'2026-04-13 09:47:09','2026-04-13 09:47:15'),(179,7,'user3','72','第一自习区','2026-04-13 09:49:07','0','2026-04-13','',NULL,'16123395995','','已预约','','','',39,'C003',50,'10:00-11:00','一楼1203',14,'','');
/*!40000 ALTER TABLE `wct_yuyue` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-14 10:12:54
