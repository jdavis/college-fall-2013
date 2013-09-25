/*
 * Delete Relationships first.
 */

DROP TABLE `reservation`;

DROP TABLE `instance_of`;

DROP TABLE `can_land`;

DROP TABLE `fares`;

DROP TABLE `legs`;

DROP TABLE `arrival_airport`;
DROP TABLE `departure_airport`;

DROP TABLE `arrives`;
DROP TABLE `departs`;

DROP TABLE `assigned`;

DROP TABLE `type`;

/*
 * Delete Entities now.
 */

DROP TABLE `fare`;

DROP TABLE `flight`;
DROP TABLE `flight_leg`;

DROP TABLE `airplane`;

DROP TABLE `airplane_type`;

DROP TABLE `leg_instance`;

DROP TABLE `seat`;

DROP TABLE `airport`;