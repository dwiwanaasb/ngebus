-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 07, 2021 at 05:55 AM
-- Server version: 10.4.14-MariaDB
-- PHP Version: 7.4.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_ngebus`
--

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id_order` int(11) NOT NULL,
  `nama_penumpang` varchar(255) NOT NULL,
  `no_telepon` varchar(255) NOT NULL,
  `armada` varchar(255) NOT NULL,
  `rute` varchar(255) NOT NULL,
  `tanggal` varchar(255) NOT NULL,
  `waktu` varchar(255) NOT NULL,
  `tarif` int(11) NOT NULL,
  `nominal_pembayaran` int(11) NOT NULL,
  `jumlah_kembalian` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id_order`, `nama_penumpang`, `no_telepon`, `armada`, `rute`, `tanggal`, `waktu`, `tarif`, `nominal_pembayaran`, `jumlah_kembalian`) VALUES
(1, 'dwiwana', '082190225566', 'Pulau Indah', 'smd - btg', '6/5/2021', '12:00 PM', 40000, 50000, 10000),
(2, 'hanifah', '0852123456', 'Meranti Etam', 'bpn - smd', '6/4/2021', '10:24 PM', 30000, 50000, 20000),
(3, 'ayu', '08123456', 'Pulau Indah', 'smd - btg', '6/6/2021', '03:39 PM', 40000, 50000, 10000);

-- --------------------------------------------------------

--
-- Table structure for table `tiket`
--

CREATE TABLE `tiket` (
  `id_tiket` int(11) NOT NULL,
  `armada` varchar(255) NOT NULL,
  `keberangkatan` varchar(50) NOT NULL,
  `tujuan` varchar(50) NOT NULL,
  `tanggal` varchar(50) NOT NULL,
  `waktu` varchar(50) NOT NULL,
  `stok` int(11) NOT NULL,
  `tarif` int(11) NOT NULL,
  `gambar` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tiket`
--

INSERT INTO `tiket` (`id_tiket`, `armada`, `keberangkatan`, `tujuan`, `tanggal`, `waktu`, `stok`, `tarif`, `gambar`) VALUES
(1, 'Meranti Etam', 'bpn', 'smd', '6/4/2021', '10:24 PM', 9, 30000, 'image_picker1061723909.jpg'),
(2, 'Pulau Indah', 'smd', 'btg', '6/6/2021', '03:39 PM', 0, 40000, 'image_picker886444250.jpg'),
(3, 'Sapu Lidi', 'bpn', 'mbd', '6/5/2021', '10:13 PM', 9, 45000, 'image_picker1714151766.jpg'),
(4, 'Balikpapan Jaya', 'bpn', 'smd', '6/6/2021', '11:13 PM', 10, 35000, 'image_picker363863617.jpg'),
(5, 'Samarinda Lestari', 'smd', 'bpn', '6/10/2021', '11:12 AM', 12, 40000, 'image_picker610738801.jpg');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id_user` int(11) NOT NULL,
  `nama_lengkap` varchar(50) NOT NULL,
  `no_telepon` varchar(15) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id_user`, `nama_lengkap`, `no_telepon`, `username`, `password`) VALUES
(1, 'admin', '123', 'admin', '$2y$10$Wxw7YZ1G1PP70DbZUL7tguiuQH3EoEHrSc85oCBgEvELNhdlM59eK'),
(2, 'Dwiwana', '082190225566', 'dwiwana', '$2y$10$jrGywgN5yR90UgBmPA7dAeEUOwVBzwnicNCm7jJqxnguSgnfKFOZu'),
(3, 'Juniar Ayu', '08123456', 'ayu', '$2y$10$lgRXqtu9l4cN333oVr7pR.IUo1rlmgPUOXhkMsuGWAFfMIyWp66t2');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id_order`);

--
-- Indexes for table `tiket`
--
ALTER TABLE `tiket`
  ADD PRIMARY KEY (`id_tiket`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id_user`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id_order` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `tiket`
--
ALTER TABLE `tiket`
  MODIFY `id_tiket` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id_user` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
