CREATE TABLE `sh59_keysystem` (
  `key_id` int(11) NOT NULL,
  `user` varchar(64) NOT NULL,
  `plate` varchar(8) NOT NULL,
  `amount` int(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


ALTER TABLE `sh59_keysystem`
  ADD PRIMARY KEY (`key_id`);


ALTER TABLE `sh59_keysystem`
  MODIFY `key_id` int(11) NOT NULL AUTO_INCREMENT;
