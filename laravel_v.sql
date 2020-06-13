-- phpMyAdmin SQL Dump
-- version 5.0.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 16, 2020 at 02:57 PM
-- Server version: 10.4.11-MariaDB
-- PHP Version: 7.4.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `laravel_v`
--

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `connection` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2014_10_12_000000_create_users_table', 1),
(2, '2014_10_12_100000_create_password_resets_table', 1),
(3, '2019_08_19_000000_create_failed_jobs_table', 1),
(4, '2020_05_08_100900_create_roles_table', 1),
(6, '2020_05_13_193653_create_profiles_table', 2);

-- --------------------------------------------------------

--
-- Table structure for table `password_resets`
--

CREATE TABLE `password_resets` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `profiles`
--

CREATE TABLE `profiles` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) DEFAULT NULL,
  `photo` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'images/no_image.png',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `profiles`
--

INSERT INTO `profiles` (`id`, `user_id`, `photo`, `created_at`, `updated_at`) VALUES
(1, 1, 'images/bZ3LgySR1nKiQNj8tQQi.png', '2020-05-14 09:12:38', '2020-05-15 09:36:30'),
(2, 4, 'images/no_image.png', '2020-05-15 09:28:31', '2020-05-15 09:28:31'),
(5, 5, 'images/no_image.png', '2020-05-15 03:57:46', '2020-05-15 03:57:46'),
(6, 6, 'images/no_image.png', '2020-05-16 03:52:47', '2020-05-16 03:52:47'),
(7, 7, 'images/no_image.png', '2020-05-16 03:53:32', '2020-05-16 03:53:32'),
(8, 8, 'images/no_image.png', '2020-05-16 04:19:06', '2020-05-16 04:19:06'),
(9, 9, 'images/no_image.png', '2020-05-16 05:17:38', '2020-05-16 05:17:38');

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id`, `name`, `created_at`, `updated_at`) VALUES
(1, 'Administrator', '2020-05-10 07:09:06', '2020-05-10 07:09:06'),
(2, 'Customer', '2020-05-11 13:52:27', '2020-05-12 06:37:05'),
(13, 'Guest', '2020-05-14 04:05:44', '2020-05-14 04:05:44');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `api_token` varchar(80) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `role_id` bigint(20) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `email_verified_at`, `password`, `api_token`, `remember_token`, `created_at`, `updated_at`, `role_id`) VALUES
(1, 'pankaj bisht', 'bisht.pankaj90@gmail.com', NULL, '$2y$10$R/WuVGH.75d6D37bkx9KFeMhAzx3b.sl2ncZpRdJwMLodjT41XrAO', 'H5odCXSo8VwQulwY4Jy3DFIuvk0wjN7mL0YFiLykAcjzUCxOiogFnlzp3eUdXvjcVg3Y7CBtQlMDWrej', NULL, '2020-05-10 07:14:04', '2020-05-16 06:20:18', 1),
(4, 'panku bisht', 'panku90@gmail.com', NULL, '$2y$10$6OEGNI8HZuGIlPeanb9M9.X22S11PPp2u6qM5.eOerB/k97K4YY6q', NULL, NULL, '2020-05-15 03:56:24', '2020-05-15 07:25:43', 2),
(5, 'tester', 'tester@gmail.com', NULL, '$2y$10$7FMPc2LtATWzsIRi/TiSx.hD0rQg20MHIc9ofS3tACce88DwRz7Mi', NULL, NULL, '2020-05-15 03:57:46', '2020-05-16 03:53:58', 2),
(6, 'sachin', 'sachin@gmail.com', NULL, '$2y$10$eBSP0xdrs3ybq.5uangI2uHOLl0VA4djQuEaIrBgB/IfQ3CvZogBm', NULL, NULL, '2020-05-16 03:52:47', '2020-05-16 03:52:47', 2),
(7, 'ramesh', 'ramesh@gmail.com', NULL, '$2y$10$PqdA5jPOylrdpeHVj7bJwOGmwVKzDPffOJaaeCmrtH5IkXLBpQi5S', NULL, NULL, '2020-05-16 03:53:32', '2020-05-16 03:53:41', 1),
(8, 'akush ojha', 'akush@gmail.com', NULL, '$2y$10$0tOUV7/SZavT3S7xNnPqgOj3KdzGxNvLd8lbkkBFmjlDBigLiZmVe', NULL, NULL, '2020-05-16 04:19:06', '2020-05-16 04:19:06', 1),
(9, 'ytresd', 'ac@gmail.com', NULL, '$2y$10$OcW64Rn1i1wV61ZV067t8OmxVoBpjnwZL0bApKfzVktSDkVN7FWQq', NULL, NULL, '2020-05-16 05:17:38', '2020-05-16 05:17:38', 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `password_resets`
--
ALTER TABLE `password_resets`
  ADD KEY `password_resets_email_index` (`email`);

--
-- Indexes for table `profiles`
--
ALTER TABLE `profiles`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `profiles`
--
ALTER TABLE `profiles`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
