-- phpMyAdmin SQL Dump
-- version 4.7.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Dec 02, 2017 at 03:26 PM
-- Server version: 5.6.35
-- PHP Version: 7.1.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

DROP DATABASE IF EXISTS `task_db`;

--
-- Database: `task_db`
--
CREATE DATABASE IF NOT EXISTS `task_db` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `task_db`;

-- --------------------------------------------------------

--
-- Table structure for table `category`
--

CREATE TABLE `Category` (
  `id` int(6) NOT NULL,
  `name` varchar(64) NOT NULL,
  `owner` int(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `category`
--

INSERT INTO `Category` (`id`, `name`, `owner`) VALUES
(1, 'My Amazing List', 1),
(2, 'Schoolword', 1),
(3, 'Foo', 2),
(5, 'Freelance', 1),
(7, 'Freelance 2', 1);

-- --------------------------------------------------------

--
-- Table structure for table `task`
--

CREATE TABLE `Task` (
  `id` int(9) NOT NULL,
  `description` text NOT NULL,
  `dueDate` date NOT NULL,
  `owner` int(3) NOT NULL,
  `category` int(6) NOT NULL,
  `taskType` int(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `task`
--

INSERT INTO `Task` (`id`, `description`, `dueDate`, `owner`, `category`, `taskType`) VALUES
(1, 'Submit the crazy paper for scripting.', '2017-11-15', 1, 2, 1),
(2, 'Try new stuff', '2017-11-24', 1, 1, 3),
(3, 'Eat cake', '2017-11-24', 1, 1, 2);

-- --------------------------------------------------------

--
-- Table structure for table `task_type`
--

CREATE TABLE `Task_type` (
  `id` int(1) NOT NULL,
  `name` varchar(32) NOT NULL,
  `order` int(1) NOT NULL,
  `alias` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `task_type`
--

INSERT INTO `Task_type` (`id`, `name`, `order`, `alias`) VALUES
(1, 'Normal', 1, 'type-norm'),
(2, 'Urgent', 2, 'type-urge'),
(3, 'Backburner', 3, 'type-back');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `User` (
  `id` int(3) NOT NULL,
  `name` varchar(64) NOT NULL,
  `email` varchar(64) NOT NULL,
  `password` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `user`
--

INSERT INTO `User` (`id`, `name`, `email`, `password`) VALUES
(1, 'Phil', 'phil@example.com', '5f4dcc3b5aa765d61d8327deb882cf99'),
(2, 'Karen', 'karen@example.com', '5f4dcc3b5aa765d61d8327deb882cf99');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `category`
--
ALTER TABLE `Category`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `task`
--
ALTER TABLE `Task`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `task_type`
--
ALTER TABLE `Task_type`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `user`
--
ALTER TABLE `User`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `category`
--
ALTER TABLE `Category`
  MODIFY `id` int(6) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;
--
-- AUTO_INCREMENT for table `task`
--
ALTER TABLE `Task`
  MODIFY `id` int(9) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT for table `task_type`
--
ALTER TABLE `Task_type`
  MODIFY `id` int(1) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `User`
  MODIFY `id` int(3) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
