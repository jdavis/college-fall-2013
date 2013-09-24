CREATE TABLE `airport` (
	`code` INT,
	`name` VARCHAR(64),
	`city` VARCHAR(64),
	`state` VARCHAR(16),
	PRIMARY KEY (`code`)
);

CREATE TABLE `airplane_type` (
	`name` VARCHAR(64),
	`max_seats` INT,
	`company` VARCHAR(128),
	PRIMARY KEY (`name`),
	FOREIGN KEY (`airport_code`)
		REFERENCES `airport` (`code`)
);

CREATE TABLE `can_land` (
	`airplane_type_name` VARCHAR(64),
	`airport_code` INT,
	PRIMARY KEY (`airport_type_name`, `airport_code`),
	FOREIGN KEY (`airport_code`)
		REFERENCES `airport`,
	FOREIGN KEY (`airplane_type_name`)
		REFERENCES `airplane_type`
);

CREATE TABLE `airplane` (
	`id` INT,
	`total_seats` INT,
	`type` VARCHAR(64) NOT NULL,
	PRIMARY KEY (`id`),
	FOREIGN KEY (`type`)
		REFERENCES `airplane_type`
);

CREATE TABLE `arrival_airport` (
	`airport_code` INT,
	`scheduled_arrival_time` DATETIME,
	FOREIGN KEY (`airport_code`)
		REFERENCES `airport`
);



CREATE TABLE `departure_airport` (
	`airport_code` INT,
	`scheduled_departure_time` DATETIME,
	FOREIGN KEY (`airport_code`)
		REFERENCES `airport`
);

CREATE TABLE `flight` (
	`number` INT,
	`airline` VARCHAR(64),
	PRIMARY KEY (`number`)
);

CREATE TABLE `fare` (
	`code` INT,
	`amount` DOUBLE,
	`restrictions` VARCHAR(64),
	`flight_number` INT,
	PRIMARY KEY (`code`, `flight_number`),
	FOREIGN KEY (`flight_number`)
		REFERENCES `flight`
		ON DELETE CASCADE
);