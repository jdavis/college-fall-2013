/*
 * Entities.
 */

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
	`company` VARCHAR(64),

	PRIMARY KEY (`name`)
);

CREATE TABLE `airplane` (
	`id` INT,
	`total_seats` INT,

	PRIMARY KEY (`id`)
);

CREATE TABLE `flight_leg` (
	`number` INT,

	PRIMARY KEY (`number`)
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

	PRIMARY KEY (`code`)
);

CREATE TABLE `leg_instance` (
	`date` DATETIME,
	`seatsAvailable` INT,

	PRIMARY KEY (`date`)
);

CREATE TABLE `seat` (
	`number` INT,

	PRIMARY KEY (`number`)
);

/*
 * Relationships.
 */

CREATE TABLE `can_land` (
	`airplane_type_name` VARCHAR(64),
	`airport_code` INT,

	PRIMARY KEY (`airplane_type_name`, `airport_code`),

	FOREIGN KEY (`airport_code`)
		REFERENCES `airport` (`code`),

	FOREIGN KEY (`airplane_type_name`)
		REFERENCES `airplane_type` (`name`)
);

CREATE TABLE `type` (
	`airplane_type_name` VARCHAR(64),
	`airplane_id` INT,

	PRIMARY KEY (`airplane_id`),

	FOREIGN KEY (`airplane_type_name`)
		REFERENCES `airplane_type` (`name`)
		ON DELETE NO ACTION,

	FOREIGN KEY (`airplane_id`)
		REFERENCES `airplane` (`id`)
);

CREATE TABLE `departure_airport` (
	`airport_code` INT,
	`flight_leg_number` INT,
	`scheduled_departure_time` DATETIME,

	PRIMARY KEY (`flight_leg_number`),

	FOREIGN KEY (`flight_leg_number`)
		REFERENCES `flight_leg` (`number`),

	FOREIGN KEY (`airport_code`)
		REFERENCES `airport` (`code`)
		ON DELETE NO ACTION
);

CREATE TABLE `arrival_airport` (
	`airport_code` INT,
	`flight_leg_number` INT,
	`scheduled_arrival_time` DATETIME,

	PRIMARY KEY (`flight_leg_number`),

	FOREIGN KEY (`flight_leg_number`)
		REFERENCES `flight_leg` (`number`),

	FOREIGN KEY (`airport_code`)
		REFERENCES `airport` (`code`)
		ON DELETE NO ACTION
);

CREATE TABLE `departs` (
	`airport_code` INT,
	`leg_instance_date` DATETIME,
	`depart_time` DATETIME,

	PRIMARY KEY (`leg_instance_date`),

	FOREIGN KEY (`airport_code`)
		REFERENCES `airport` (`code`),

	FOREIGN KEY (`leg_instance_date`)
		REFERENCES `leg_instance` (`date`)
);

CREATE TABLE `arrives` (
	`airport_code` INT,
	`leg_instance_date` DATETIME,
	`arrive_time` DATETIME,

	PRIMARY KEY (`leg_instance_date`),

	FOREIGN KEY (`airport_code`)
		REFERENCES `airport` (`code`),

	FOREIGN KEY (`leg_instance_date`)
		REFERENCES `leg_instance` (`date`)
);

CREATE TABLE `assigned` (
	`airplane_id` INT,
	`leg_instance_date` DATETIME,

	PRIMARY KEY (`leg_instance_date`),

	FOREIGN KEY (`airplane_id`)
		REFERENCES `airplane` (`id`)
		ON DELETE NO ACTION,

	FOREIGN KEY (`leg_instance_date`)
		REFERENCES `leg_instance` (`date`)
);

CREATE TABLE `legs` (
	`flight_leg_number` INT,
	`flight_number` INT,

	PRIMARY KEY (`flight_leg_number`),

	FOREIGN KEY (`flight_number`)
		REFERENCES `flight` (`number`)
		ON DELETE NO ACTION,

	FOREIGN KEY (`flight_leg_number`)
		REFERENCES `flight_leg` (`number`)
		ON DELETE CASCADE
);

CREATE TABLE `fares` (
	`flight_number` INT,
	`fare_code` INT,

	PRIMARY KEY (`fare_code`),

	FOREIGN KEY (`fare_code`)
		REFERENCES `fare` (`code`)
		ON DELETE CASCADE,

	FOREIGN KEY (`flight_number`)
		REFERENCES `flight` (`number`)
		ON DELETE NO ACTION
);

CREATE TABLE `reservation` (
	`customer_name` VARCHAR(64),
	`cpone` INT,

	`seat_number` INT,
	`leg_instance_date` DATETIME,


	FOREIGN KEY (`seat_number`)
		REFERENCES `seat` (`number`)
		ON DELETE CASCADE,

	FOREIGN KEY (`leg_instance_date`)
		REFERENCES `leg_instance` (`date`)
		ON DELETE NO ACTION
);

CREATE TABLE `instance_of` (
	`flight_leg_number` INT,
	`leg_instance_date` DATETIME,

	PRIMARY KEY (`flight_leg_number`, `leg_instance_date`),
	
	FOREIGN KEY (`leg_instance_date`)
		REFERENCES `leg_instance` (`date`)
		ON DELETE CASCADE,

	FOREIGN KEY (`flight_leg_number`)
		REFERENCES `flight_leg` (`number`)
		ON DELETE NO ACTION
);