-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 12, 2026 at 07:15 PM
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
-- Database: `cccs105`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `BuildRoster` ()   BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 50 DO
        -- Add 4 players for every team ID from 1 to 50
        IF i = 1 THEN
            -- Manila Stars (NBA Superstars)
            INSERT INTO players (first_name, last_name, jersey_number, position, team_id) VALUES 
            ('Stephen', 'Curry', 30, 'Guard', i), ('LeBron', 'James', 23, 'Forward', i), 
            ('Kevin', 'Durant', 35, 'Forward', i), ('Anthony', 'Davis', 3, 'Center', i);
        ELSEIF i = 2 THEN
            -- Cebu Sharks (PBA Legends)
            INSERT INTO players (first_name, last_name, jersey_number, position, team_id) VALUES 
            ('June Mar', 'Fajardo', 15, 'Center', i), ('Scottie', 'Thompson', 6, 'Guard', i), 
            ('CJ', 'Perez', 7, 'Guard', i), ('Terrence', 'Romeo', 7, 'Guard', i);
        ELSEIF i = 3 THEN
            -- Davao Eagles (International Stars)
            INSERT INTO players (first_name, last_name, jersey_number, position, team_id) VALUES 
            ('Luka', 'Doncic', 77, 'Guard', i), ('Kyrie', 'Irving', 11, 'Guard', i), 
            ('Nikola', 'Jokic', 15, 'Center', i), ('Giannis', 'Antetokounmpo', 34, 'Forward', i);
        ELSE
            -- Teams 4-50 (Generic Pro Athletes to reach 200)
            INSERT INTO players (first_name, last_name, jersey_number, position, team_id) VALUES 
            (CONCAT('Pro_Guard_', i), 'Star', 10, 'Guard', i),
            (CONCAT('Pro_Forward_', i), 'Star', 21, 'Forward', i),
            (CONCAT('Pro_Center_', i), 'Star', 32, 'Center', i),
            (CONCAT('Pro_Sub_', i), 'Star', 5, 'Substitute', i);
        END IF;
        SET i = i + 1;
    END WHILE;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Generate200Players` ()   BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 50 DO
        -- 1 Guard, 1 Forward, 1 Center, 1 Sub per team
        INSERT INTO players (first_name, last_name, jersey_number, position, team_id) VALUES 
        (CONCAT('Guard_', i), 'Pro', 11, 'Guard', i),
        (CONCAT('Forward_', i), 'Pro', 23, 'Forward', i),
        (CONCAT('Center_', i), 'Pro', 15, 'Center', i),
        (CONCAT('SixthMan_', i), 'Pro', 0, 'Substitute', i);
        SET i = i + 1;
    END WHILE;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `games`
--

CREATE TABLE `games` (
  `game_id` int(11) NOT NULL,
  `game_date` date DEFAULT NULL,
  `home_team_id` int(11) DEFAULT NULL,
  `away_team_id` int(11) DEFAULT NULL,
  `home_team_score` int(11) DEFAULT NULL,
  `away_team_score` int(11) DEFAULT NULL,
  `venue` varchar(150) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `games`
--

INSERT INTO `games` (`game_id`, `game_date`, `home_team_id`, `away_team_id`, `home_team_score`, `away_team_score`, `venue`) VALUES
(1, '2026-06-02', 1, 2, 21, 4, 'Manila 3x3 Court'),
(2, '2026-06-03', 2, 3, 21, 11, 'Cebu City 3x3 Court'),
(3, '2026-06-04', 3, 4, 21, 4, 'Davao City 3x3 Court'),
(4, '2026-06-05', 4, 5, 21, 6, 'Batangas City 3x3 Court'),
(5, '2026-06-06', 5, 6, 21, 1, 'San Fernando 3x3 Court'),
(6, '2026-06-07', 6, 7, 21, 3, 'Malolos 3x3 Court'),
(7, '2026-06-08', 7, 8, 21, 11, 'Santa Rosa 3x3 Court'),
(8, '2026-06-09', 8, 9, 21, 8, 'Bacolod 3x3 Court'),
(9, '2026-06-10', 9, 10, 21, 7, 'Iloilo City 3x3 Court'),
(10, '2026-06-11', 10, 11, 21, 10, 'Zamboanga City 3x3 Court'),
(11, '2026-06-12', 11, 12, 21, 10, 'Pasig 3x3 Court'),
(12, '2026-06-13', 12, 13, 21, 19, 'Lucena 3x3 Court'),
(13, '2026-06-14', 13, 14, 21, 8, 'Balanga 3x3 Court'),
(14, '2026-06-15', 14, 15, 21, 2, 'Calapan 3x3 Court'),
(15, '2026-06-01', 15, 16, 21, 5, 'Marikina 3x3 Court'),
(16, '2026-06-02', 16, 17, 21, 17, 'Valenzuela 3x3 Court'),
(17, '2026-06-03', 17, 18, 21, 11, 'Navotas 3x3 Court'),
(18, '2026-06-04', 18, 19, 21, 5, 'San Juan 3x3 Court'),
(19, '2026-06-05', 19, 20, 21, 10, 'Muntinlupa 3x3 Court'),
(20, '2026-06-06', 20, 21, 21, 17, 'Makati 3x3 Court'),
(21, '2026-06-07', 21, 22, 21, 14, 'Parañaque 3x3 Court'),
(22, '2026-06-08', 22, 23, 21, 2, 'Taguig 3x3 Court'),
(23, '2026-06-09', 23, 24, 21, 6, 'Pasay 3x3 Court'),
(24, '2026-06-10', 24, 25, 21, 3, 'Caloocan 3x3 Court'),
(25, '2026-06-11', 25, 26, 21, 17, 'Malabon 3x3 Court'),
(26, '2026-06-12', 26, 27, 21, 19, 'Antipolo 3x3 Court'),
(27, '2026-06-13', 27, 28, 21, 2, 'Antipolo 3x3 Court'),
(28, '2026-06-14', 28, 29, 21, 13, 'Cainta 3x3 Court'),
(29, '2026-06-15', 29, 30, 21, 2, 'Taytay 3x3 Court'),
(30, '2026-06-01', 30, 31, 21, 8, 'Binangonan 3x3 Court'),
(31, '2026-06-02', 31, 32, 21, 15, 'Vigan 3x3 Court'),
(32, '2026-06-03', 32, 33, 21, 12, 'Laoag 3x3 Court'),
(33, '2026-06-04', 33, 34, 21, 14, 'Baguio 3x3 Court'),
(34, '2026-06-05', 34, 35, 21, 15, 'Tarlac City 3x3 Court'),
(35, '2026-06-06', 35, 36, 21, 13, 'Palayan 3x3 Court'),
(36, '2026-06-07', 36, 37, 21, 1, 'Ilagan 3x3 Court'),
(37, '2026-06-08', 37, 38, 21, 3, 'Tuguegarao 3x3 Court'),
(38, '2026-06-09', 38, 39, 21, 14, 'Lingayen 3x3 Court'),
(39, '2026-06-10', 39, 40, 21, 19, 'San Fernando 3x3 Court'),
(40, '2026-06-11', 40, 41, 21, 18, 'Legazpi 3x3 Court'),
(41, '2026-06-12', 41, 42, 21, 10, 'Naga City 3x3 Court'),
(42, '2026-06-13', 42, 43, 21, 15, 'Virac 3x3 Court'),
(43, '2026-06-14', 43, 44, 21, 9, 'Masbate City 3x3 Court'),
(44, '2026-06-15', 44, 45, 21, 16, 'Tacloban 3x3 Court'),
(45, '2026-06-01', 45, 46, 21, 14, 'Catbalogan 3x3 Court'),
(46, '2026-06-02', 46, 47, 21, 3, 'Ormoc 3x3 Court'),
(47, '2026-06-03', 47, 48, 21, 12, 'Dumaguete 3x3 Court'),
(48, '2026-06-04', 48, 49, 21, 10, 'Tagbilaran 3x3 Court'),
(49, '2026-06-05', 49, 50, 21, 13, 'GenSan 3x3 Court'),
(50, '2026-06-06', 50, 1, 21, 16, 'Butuan 3x3 Court'),
(64, '2026-06-01', 2, 10, 21, 18, 'Nabua CSPC');

-- --------------------------------------------------------

--
-- Table structure for table `players`
--

CREATE TABLE `players` (
  `player_id` int(11) NOT NULL,
  `first_name` varchar(50) DEFAULT NULL,
  `last_name` varchar(50) DEFAULT NULL,
  `jersey_number` int(11) DEFAULT NULL,
  `position` varchar(20) DEFAULT NULL,
  `team_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `players`
--

INSERT INTO `players` (`player_id`, `first_name`, `last_name`, `jersey_number`, `position`, `team_id`) VALUES
(1, 'Stephen', 'Curry', 30, 'Guard', 1),
(2, 'LeBron', 'James', 23, 'Forward', 1),
(3, 'Kevin', 'Durant', 35, 'Forward', 1),
(4, 'Anthony', 'Davis', 3, 'Center', 1),
(5, 'June Mar', 'Fajardo', 15, 'Center', 2),
(6, 'Scottie', 'Thompson', 6, 'Guard', 2),
(7, 'CJ', 'Perez', 7, 'Guard', 2),
(8, 'Terrence', 'Romeo', 7, 'Guard', 2),
(9, 'Luka', 'Doncic', 77, 'Guard', 3),
(10, 'Kyrie', 'Irving', 11, 'Guard', 3),
(11, 'Nikola', 'Jokic', 15, 'Center', 3),
(12, 'Giannis', 'Antetokounmpo', 34, 'Forward', 3),
(13, 'Robert', 'Bolick', 8, 'Guard', 4),
(14, 'Japeth', 'Aguilar', 25, 'Forward', 4),
(15, 'Christian', 'Standhardinger', 25, 'Center', 4),
(16, 'Chris', 'Newsome', 11, 'Guard', 4),
(17, 'Jayson', 'Tatum', 0, 'Forward', 5),
(18, 'Jaylen', 'Brown', 7, 'Forward', 5),
(19, 'Shai', 'Gilgeous-Alexander', 2, 'Guard', 5),
(20, 'Joel', 'Embiid', 21, 'Center', 5),
(21, 'Damian', 'Lillard', 7, 'Guard', 6),
(22, 'Khris', 'Middleton', 22, 'Forward', 6),
(23, 'Brook', 'Lopez', 11, 'Center', 6),
(24, 'Bobby', 'Portis', 9, 'Forward', 6),
(25, 'Paul', 'George', 13, 'Forward', 7),
(26, 'James', 'Harden', 1, 'Guard', 7),
(27, 'Kawhi', 'Leonard', 2, 'Forward', 7),
(28, 'Ivica', 'Zubac', 40, 'Center', 7),
(29, 'Donovan', 'Mitchell', 45, 'Guard', 8),
(30, 'Darius', 'Garland', 10, 'Guard', 8),
(31, 'Evan', 'Mobley', 4, 'Forward', 8),
(32, 'Jarrett', 'Allen', 31, 'Center', 8),
(33, 'Jimmy', 'Butler', 22, 'Forward', 9),
(34, 'Bam', 'Adebayo', 13, 'Center', 9),
(35, 'Tyler', 'Herro', 14, 'Guard', 9),
(36, 'Jaime', 'Jaquez', 11, 'Forward', 9),
(37, 'De\'Aaron', 'Fox', 5, 'Guard', 10),
(38, 'Domantas', 'Sabonis', 10, 'Center', 10),
(39, 'Keegan', 'Murray', 13, 'Forward', 10),
(40, 'Malik', 'Monk', 0, 'Guard', 10),
(41, 'Tyrese', 'Haliburton', 0, 'Guard', 11),
(42, 'Pascal', 'Siakam', 43, 'Forward', 11),
(43, 'Myles', 'Turner', 33, 'Center', 11),
(44, 'Bennedict', 'Mathurin', 0, 'Guard', 11),
(45, 'Anthony', 'Edwards', 5, 'Guard', 12),
(46, 'Karl-Anthony', 'Towns', 32, 'Center', 12),
(47, 'Rudy', 'Gobert', 27, 'Center', 12),
(48, 'Mike', 'Conley', 10, 'Guard', 12),
(49, 'Jalen', 'Brunson', 11, 'Guard', 13),
(50, 'Julius', 'Randle', 30, 'Forward', 13),
(51, 'OG', 'Anunoby', 8, 'Forward', 13),
(52, 'Josh', 'Hart', 3, 'Guard', 13),
(53, 'Paolo', 'Banchero', 5, 'Forward', 14),
(54, 'Franz', 'Wagner', 22, 'Forward', 14),
(55, 'Jalen', 'Suggs', 4, 'Guard', 14),
(56, 'Wendell', 'Carter', 34, 'Center', 14),
(57, 'Cade', 'Cunningham', 2, 'Guard', 15),
(58, 'Jaden', 'Ivey', 23, 'Guard', 15),
(59, 'Jalen', 'Duren', 0, 'Center', 15),
(60, 'Ausar', 'Thompson', 9, 'Forward', 15),
(61, 'LaMelo', 'Ball', 1, 'Guard', 16),
(62, 'Brandon', 'Miller', 24, 'Forward', 16),
(63, 'Miles', 'Bridges', 0, 'Forward', 16),
(64, 'Mark', 'Williams', 5, 'Center', 16),
(65, 'Trae', 'Young', 11, 'Guard', 17),
(66, 'Dejounte', 'Murray', 5, 'Guard', 17),
(67, 'Jalen', 'Johnson', 1, 'Forward', 17),
(68, 'Clint', 'Capela', 15, 'Center', 17),
(69, 'Ja', 'Morant', 12, 'Guard', 18),
(70, 'Jaren', 'Jackson', 13, 'Forward', 18),
(71, 'Desmond', 'Bane', 22, 'Guard', 18),
(72, 'Marcus', 'Smart', 36, 'Guard', 18),
(73, 'Victor', 'Wembanyama', 1, 'Center', 19),
(74, 'Devin', 'Vassell', 24, 'Guard', 19),
(75, 'Jeremy', 'Sochan', 10, 'Forward', 19),
(76, 'Tre', 'Jones', 33, 'Guard', 19),
(77, 'Zion', 'Williamson', 1, 'Forward', 20),
(78, 'Brandon', 'Ingram', 14, 'Forward', 20),
(79, 'CJ', 'McCollum', 3, 'Guard', 20),
(80, 'Jonas', 'Valanciunas', 17, 'Center', 20),
(81, 'Alperen', 'Sengun', 28, 'Center', 21),
(82, 'Jalen', 'Green', 4, 'Guard', 21),
(83, 'Fred', 'VanVleet', 5, 'Guard', 21),
(84, 'Jabari', 'Smith', 10, 'Forward', 21),
(85, 'Jordan', 'Poole', 13, 'Guard', 22),
(86, 'Kyle', 'Kuzma', 33, 'Forward', 22),
(87, 'Tyus', 'Jones', 5, 'Guard', 22),
(88, 'Daniel', 'Gafford', 21, 'Center', 22),
(89, 'Mikal', 'Bridges', 1, 'Forward', 23),
(90, 'Cam', 'Thomas', 24, 'Guard', 23),
(91, 'Nic', 'Claxton', 33, 'Center', 23),
(92, 'Dennis', 'Schroder', 22, 'Guard', 23),
(93, 'Scottie', 'Barnes', 4, 'Forward', 24),
(94, 'RJ', 'Barrett', 9, 'Forward', 24),
(95, 'Immanuel', 'Quickley', 5, 'Guard', 24),
(96, 'Jakob', 'Poeltl', 19, 'Center', 24),
(97, 'Bradley', 'Beal', 3, 'Guard', 25),
(98, 'Devin', 'Booker', 1, 'Guard', 25),
(99, 'Kevin', 'Durant', 35, 'Forward', 25),
(100, 'Jusuf', 'Nurkic', 20, 'Center', 25),
(101, 'Calvin', 'Abueva', 8, 'Forward', 26),
(102, 'Ian', 'Sangalang', 18, 'Center', 26),
(103, 'Mark', 'Barroca', 14, 'Guard', 26),
(104, 'Paul', 'Lee', 19, 'Guard', 26),
(105, 'Beau', 'Belga', 30, 'Center', 27),
(106, 'Gabe', 'Norwood', 10, 'Forward', 27),
(107, 'Maverick', 'Ahanmisi', 13, 'Guard', 27),
(108, 'James', 'Yap', 18, 'Guard', 27),
(109, 'Arwind', 'Santos', 29, 'Forward', 28),
(110, 'Alex', 'Cabagnot', 5, 'Guard', 28),
(111, 'Marc', 'Pingris', 15, 'Forward', 28),
(112, 'Jeff', 'Chan', 16, 'Guard', 28),
(113, 'Jason', 'Castro', 10, 'Guard', 29),
(114, 'Troy', 'Rosario', 18, 'Forward', 29),
(115, 'Roger', 'Pogoy', 16, 'Guard', 29),
(116, 'Kelly', 'Williams', 12, 'Forward', 29),
(117, 'Bong', 'Quinto', 2, 'Forward', 30),
(118, 'Aaron', 'Black', 1, 'Guard', 30),
(119, 'Cliff', 'Hodge', 7, 'Forward', 30),
(120, 'Raymond', 'Almazan', 20, 'Center', 30),
(121, 'Jerwin', 'Gaco', 19, 'Forward', 31),
(122, 'Rafi', 'Reavis', 4, 'Center', 31),
(123, 'Jared', 'Dillinger', 11, 'Forward', 31),
(124, 'Joe', 'Devance', 38, 'Forward', 31),
(125, 'Kevin', 'Alas', 6, 'Guard', 32),
(126, 'Baser', 'Amer', 9, 'Guard', 32),
(127, 'Brandon', 'Ganuelas', 12, 'Forward', 32),
(128, 'Sean', 'Anthony', 10, 'Forward', 32),
(129, 'Jericho', 'Cruz', 1, 'Guard', 33),
(130, 'Jio', 'Jalalon', 6, 'Guard', 33),
(131, 'Vic', 'Manuel', 87, 'Forward', 33),
(132, 'Kevin', 'Quiambao', 10, 'Forward', 33),
(133, 'Carl', 'Tamayo', 22, 'Forward', 34),
(134, 'Kai', 'Sotto', 11, 'Center', 34),
(135, 'AJ', 'Edu', 13, 'Center', 34),
(136, 'Dwight', 'Ramos', 24, 'Guard', 34),
(137, 'Bobby', 'Ray', 28, 'Guard', 35),
(138, 'Kiefer', 'Ravena', 15, 'Guard', 35),
(139, 'Thirdy', 'Ravena', 1, 'Forward', 35),
(140, 'Rhenz', 'Abando', 2, 'Guard', 35),
(141, 'Robby', 'Celiz', 8, 'Forward', 36),
(142, 'Cedric', 'Ablaza', 14, 'Forward', 36),
(143, 'Alwyn', 'Alday', 5, 'Guard', 36),
(144, 'Hesed', 'Gabog', 11, 'Guard', 36),
(145, 'Justin', 'Gutang', 29, 'Forward', 37),
(146, 'Will', 'GoZum', 13, 'Forward', 37),
(147, 'Jacob', 'Cortez', 7, 'Guard', 37),
(148, 'Tony', 'Ynot', 11, 'Guard', 37),
(149, 'Yancy', 'De Ocampo', 18, 'Center', 38),
(150, 'Ranidel', 'De Ocampo', 33, 'Forward', 38),
(151, 'Jimmy', 'Alapag', 3, 'Guard', 38),
(152, 'Asi', 'Taulava', 88, 'Center', 38),
(153, 'Gary', 'David', 20, 'Guard', 39),
(154, 'Willie', 'Miller', 11, 'Guard', 39),
(155, 'Jayjay', 'Helterbrand', 13, 'Guard', 39),
(156, 'Mark', 'Caguioa', 47, 'Guard', 39),
(157, 'Danny', 'Ildefonso', 10, 'Forward', 40),
(158, 'Lordy', 'Tugade', 12, 'Forward', 40),
(159, 'Olsen', 'Racela', 17, 'Guard', 40),
(160, 'Dondon', 'Hontiveros', 7, 'Guard', 40),
(161, 'Alvin', 'Patrimonio', 16, 'Forward', 41),
(162, 'Jerry', 'Codiñera', 44, 'Center', 41),
(163, 'Johnny', 'Abarrientos', 14, 'Guard', 41),
(164, 'Jojo', 'Lastimosa', 6, 'Guard', 41),
(165, 'Kenneth', 'Duremdes', 15, 'Forward', 42),
(166, 'Marlou', 'Aquino', 13, 'Center', 42),
(167, 'Bal', 'David', 1, 'Guard', 42),
(168, 'Noli', 'Locsin', 6, 'Forward', 42),
(169, 'Vergel', 'Meneses', 18, 'Forward', 43),
(170, 'Bong', 'Hawkins', 16, 'Forward', 43),
(171, 'Jeffrey', 'Cariaso', 22, 'Guard', 43),
(172, 'Nelson', 'Asaytono', 25, 'Forward', 43),
(173, 'Pido', 'Jarencio', 25, 'Guard', 44),
(174, 'Samboy', 'Lim', 9, 'Forward', 44),
(175, 'Allan', 'Caidic', 8, 'Guard', 44),
(176, 'Hector', 'Calma', 14, 'Guard', 44),
(177, 'Robert', 'Jaworski', 7, 'Guard', 45),
(178, 'Ramon', 'Fernandez', 19, 'Center', 45),
(179, 'Philip', 'Cezar', 18, 'Forward', 45),
(180, 'Bogs', 'Adornado', 33, 'Forward', 45),
(181, 'Atoy', 'Co', 6, 'Guard', 46),
(182, 'Francis', 'Arnaiz', 8, 'Guard', 46),
(183, 'Bernie', 'Fabiosa', 15, 'Guard', 46),
(184, 'Freddie', 'Hubalde', 10, 'Forward', 46),
(185, 'Benjie', 'Paras', 14, 'Center', 47),
(186, 'Ronnie', 'Magsanoc', 5, 'Guard', 47),
(187, 'Eric', 'Altamirano', 11, 'Guard', 47),
(188, 'Pido', 'Jarencio', 25, 'Guard', 47),
(189, 'Vince', 'Carter', 15, 'Forward', 48),
(190, 'Tracy', 'McGrady', 1, 'Forward', 48),
(191, 'Allen', 'Iverson', 3, 'Guard', 48),
(192, 'Shaquille', 'O\'Neal', 34, 'Center', 48),
(193, 'Kobe', 'Bryant', 24, 'Guard', 49),
(194, 'Pau', 'Gasol', 16, 'Center', 49),
(195, 'Derek', 'Fisher', 2, 'Guard', 49),
(196, 'Lamar', 'Odom', 7, 'Forward', 49),
(197, 'Michael', 'Jordan', 23, 'Guard', 50),
(198, 'Scottie', 'Pippen', 33, 'Forward', 50),
(199, 'Dennis', 'Rodman', 91, 'Forward', 50),
(200, 'Steve', 'Kerr', 25, 'Guard', 50);

-- --------------------------------------------------------

--
-- Table structure for table `teams`
--

CREATE TABLE `teams` (
  `team_id` int(11) NOT NULL,
  `team_name` varchar(100) NOT NULL,
  `city` varchar(100) DEFAULT NULL,
  `coach_name` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `teams`
--

INSERT INTO `teams` (`team_id`, `team_name`, `city`, `coach_name`) VALUES
(1, 'Manila Stars', 'Manila', 'Coach Aris'),
(2, 'Cebu Sharks', 'Cebu City', 'Coach Benjie'),
(3, 'Davao Eagles', 'Davao City', 'Coach Caloy'),
(4, 'Batangas Blades', 'Batangas City', 'Coach Danny'),
(5, 'Pampanga Lanterns', 'San Fernando', 'Coach Ed'),
(6, 'Bulacan Kuyas', 'Malolos', 'Coach Frank'),
(7, 'Laguna Heroes', 'Santa Rosa', 'Coach Gabby'),
(8, 'Bacolod Smile', 'Bacolod', 'Coach Harold'),
(9, 'Iloilo Royals', 'Iloilo City', 'Coach Ian'),
(10, 'Zamboanga Valientes', 'Zamboanga City', 'Coach Jun'),
(11, 'Pasig Pirates', 'Pasig', 'Coach Ken'),
(12, 'Quezon Huskers', 'Lucena', 'Coach Lando'),
(13, 'Bataan Risers', 'Balanga', 'Coach Mon'),
(14, 'Mindoro Disiplinados', 'Calapan', 'Coach Noel'),
(15, 'Marikina Shoemakers', 'Marikina', 'Coach Ogie'),
(16, 'Valenzuela Classic', 'Valenzuela', 'Coach Pido'),
(17, 'Navotas Clutch', 'Navotas', 'Coach Quinto'),
(18, 'San Juan Knights', 'San Juan', 'Coach Randy'),
(19, 'Muntinlupa Cagers', 'Muntinlupa', 'Coach Sonny'),
(20, 'Makati Skyscrapers', 'Makati', 'Coach Tim'),
(21, 'Parañaque Patriots', 'Parañaque', 'Coach Bong'),
(22, 'Taguig Generals', 'Taguig', 'Coach Al'),
(23, 'Pasay Voyagers', 'Pasay', 'Coach Chot'),
(24, 'Caloocan Kankaloo', 'Caloocan', 'Coach Jojo'),
(25, 'Malabon Tigers', 'Malabon', 'Coach Leo'),
(26, 'Rizal Crusaders', 'Antipolo', 'Coach Mark'),
(27, 'Antipolo Pilgrims', 'Antipolo', 'Coach Nap'),
(28, 'Cainta Robins', 'Cainta', 'Coach Rico'),
(29, 'Taytay Archers', 'Taytay', 'Coach Steve'),
(30, 'Binangonan Waves', 'Binangonan', 'Coach Vic'),
(31, 'Vigan Heritage', 'Vigan', 'Coach Willy'),
(32, 'Laoag Sunshine', 'Laoag', 'Coach Xavi'),
(33, 'Baguio Frost', 'Baguio', 'Coach Yolly'),
(34, 'Tarlac United', 'Tarlac City', 'Coach Zap'),
(35, 'Nueva Ecija Vanguards', 'Palayan', 'Coach Arnel'),
(36, 'Isabela Warriors', 'Ilagan', 'Coach Bert'),
(37, 'Cagayan Giants', 'Tuguegarao', 'Coach Cris'),
(38, 'Pangasinan Heat', 'Lingayen', 'Coach Dom'),
(39, 'La Union Surfers', 'San Fernando', 'Coach Ely'),
(40, 'Bicol Volcanoes', 'Legazpi', 'Coach Fred'),
(41, 'Naga Flames', 'Naga City', 'Coach Gerry'),
(42, 'Catanduanes Waves', 'Virac', 'Coach Henry'),
(43, 'Masbate Rodeos', 'Masbate City', 'Coach Ivan'),
(44, 'Leyte Ironmen', 'Tacloban', 'Coach Jake'),
(45, 'Samar Guardians', 'Catbalogan', 'Coach Karl'),
(46, 'Ormoc Sugarcane', 'Ormoc', 'Coach Luis'),
(47, 'Dumaguete Gentle', 'Dumaguete', 'Coach Mike'),
(48, 'Bohol Tarsiers', 'Tagbilaran', 'Coach Nick'),
(49, 'GenSan Warriors', 'GenSan', 'Coach Oscar'),
(50, 'Butuan Kingfishers', 'Butuan', 'Coach Paul');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `games`
--
ALTER TABLE `games`
  ADD PRIMARY KEY (`game_id`),
  ADD KEY `home_team_id` (`home_team_id`),
  ADD KEY `away_team_id` (`away_team_id`);

--
-- Indexes for table `players`
--
ALTER TABLE `players`
  ADD PRIMARY KEY (`player_id`),
  ADD KEY `team_id` (`team_id`);

--
-- Indexes for table `teams`
--
ALTER TABLE `teams`
  ADD PRIMARY KEY (`team_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `games`
--
ALTER TABLE `games`
  MODIFY `game_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=67;

--
-- AUTO_INCREMENT for table `players`
--
ALTER TABLE `players`
  MODIFY `player_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=202;

--
-- AUTO_INCREMENT for table `teams`
--
ALTER TABLE `teams`
  MODIFY `team_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=53;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `games`
--
ALTER TABLE `games`
  ADD CONSTRAINT `games_ibfk_1` FOREIGN KEY (`home_team_id`) REFERENCES `teams` (`team_id`),
  ADD CONSTRAINT `games_ibfk_2` FOREIGN KEY (`away_team_id`) REFERENCES `teams` (`team_id`);

--
-- Constraints for table `players`
--
ALTER TABLE `players`
  ADD CONSTRAINT `players_ibfk_1` FOREIGN KEY (`team_id`) REFERENCES `teams` (`team_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
