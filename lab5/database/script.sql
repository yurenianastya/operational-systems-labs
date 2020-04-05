-- -----------------------------------------------------
-- Schema yurenia_db
-- -----------------------------------------------------
DROP DATABASE IF EXISTS `yurenia_db`;
CREATE DATABASE `yurenia_db` ;
USE `yurenia_db` ;

DROP TABLE IF EXISTS `country`;
DROP TABLE IF EXISTS `transaction`;
DROP TABLE IF EXISTS `currency`;
DROP TABLE IF EXISTS `customer`;
DROP TABLE IF EXISTS `private_account`;
DROP TABLE IF EXISTS `country_has_currency`;
DROP TABLE IF EXISTS `bank_has_transaction`;
DROP TABLE IF EXISTS `business_account`;
DROP TABLE IF EXISTS `bank_password`;
DROP TABLE IF EXISTS `customer_password`;
DROP TABLE IF EXISTS `business_password`;
DROP TABLE IF EXISTS `product`;
DROP TABLE IF EXISTS `business`;
DROP TABLE IF EXISTS `service`;
DROP TABLE IF EXISTS `bank`;
-- -----------------------------------------------------
-- Table `yurenia_db`.`country`
-- -----------------------------------------------------
CREATE TABLE `yurenia_db`.`country` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `tax` INT NOT NULL,
  INDEX `tax_INDEX` (`tax` ASC),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC),
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `yurenia_db`.`customer`
-- -----------------------------------------------------
CREATE TABLE `yurenia_db`.`customer` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `surname` VARCHAR(45) NOT NULL,
  `phone_number` INT(12) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `income` DECIMAL(45) NOT NULL,
  `country_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_customer_country1_idx` (`country_id` ASC),
  CONSTRAINT `fk_customer_country1`
    FOREIGN KEY (`country_id`)
    REFERENCES `yurenia_db`.`country` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `yurenia_db`.`transaction`
-- -----------------------------------------------------
CREATE TABLE `yurenia_db`.`transaction` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `transaction_info` VARCHAR(45) NULL,
  `amount` DECIMAL(45) NOT NULL,
  `business_id` INT(45) NOT NULL,
  `private_account_id` INT NOT NULL,
  `bank_id` INT NOT NULL,
  `transaction_code` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `transaction_code_UNIQUE` (`transaction_code` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `yurenia_db`.`currency`
-- -----------------------------------------------------
CREATE TABLE `yurenia_db`.`currency` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `transaction_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_currency_transaction1_idx` (`transaction_id` ASC),
  CONSTRAINT `fk_currency_transaction1`
    FOREIGN KEY (`transaction_id`)
    REFERENCES `yurenia_db`.`transaction` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `yurenia_db`.`private_account`
-- -----------------------------------------------------
CREATE TABLE `yurenia_db`.`private_account` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `account_number` BIGINT NOT NULL,
  `account_balance` DECIMAL NOT NULL,
  `owners_name` VARCHAR(45) NOT NULL,
  `currency_id` INT NOT NULL,
  `customer_id` INT NOT NULL,
  `transaction_id` INT NOT NULL,
  UNIQUE INDEX `account_number_UNIQUE` (`account_number` ASC),
  PRIMARY KEY (`id`),
  INDEX `fk_private_account_customer1_idx` (`customer_id` ASC),
  INDEX `fk_private_account_transaction1_idx` (`transaction_id` ASC),
  INDEX `fk_private_account_currency1_idx` (`currency_id` ASC),
  CONSTRAINT `fk_private_account_currency1`
    FOREIGN KEY (`currency_id`)
    REFERENCES `yurenia_db`.`currency` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_private_account_customer1`
    FOREIGN KEY (`customer_id`)
    REFERENCES `yurenia_db`.`customer` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_private_account_transaction1`
    FOREIGN KEY (`transaction_id`)
    REFERENCES `yurenia_db`.`transaction` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `yurenia_db`.`business`
-- -----------------------------------------------------
CREATE TABLE `yurenia_db`.`business` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `service` VARCHAR(45) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  UNIQUE INDEX `name_UNIQUE` (`name` ASC),
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `yurenia_db`.`business_account`
-- -----------------------------------------------------
CREATE TABLE `yurenia_db`.`business_account` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `owner_company` VARCHAR(45) NOT NULL,
  `balance` DECIMAL NULL,
  `business_id` INT NOT NULL,
  `currency_id` INT NOT NULL,
  `transaction_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_business_account_business1_idx` (`business_id` ASC),
  INDEX `fk_business_account_transaction1_idx` (`transaction_id` ASC),
  CONSTRAINT `fk_business_account_business1`
    FOREIGN KEY (`business_id`)
    REFERENCES `yurenia_db`.`business` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_business_account_transaction1`
    FOREIGN KEY (`transaction_id`)
    REFERENCES `yurenia_db`.`transaction` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `yurenia_db`.`service`
-- -----------------------------------------------------
CREATE TABLE `yurenia_db`.`service` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `price` DECIMAL NOT NULL,
  `quantity` INT NOT NULL,
  `business_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_service_business1_idx` (`business_id` ASC),
  CONSTRAINT `fk_service_business1`
    FOREIGN KEY (`business_id`)
    REFERENCES `yurenia_db`.`business` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `yurenia_db`.`product`
-- -----------------------------------------------------
CREATE TABLE `yurenia_db`.`product` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `price` DECIMAL NOT NULL,
  `quantity` INT NOT NULL,
  `business_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_product_business1_idx` (`business_id` ASC),
  CONSTRAINT `fk_product_business1`
    FOREIGN KEY (`business_id`)
    REFERENCES `yurenia_db`.`business` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `yurenia_db`.`bank`
-- -----------------------------------------------------
CREATE TABLE `yurenia_db`.`bank` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `country_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_bank_country1_idx` (`country_id` ASC),
  CONSTRAINT `fk_bank_country1`
    FOREIGN KEY (`country_id`)
    REFERENCES `yurenia_db`.`country` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `yurenia_db`.`customer_password`
-- -----------------------------------------------------
CREATE TABLE `yurenia_db`.`customer_password` (
  `customer_id` INT NOT NULL AUTO_INCREMENT,
  `customer_password` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`customer_id`),
  INDEX `fk_passwords_customer1_idx` (`customer_id` ASC),
  CONSTRAINT `fk_passwords_customer1`
    FOREIGN KEY (`customer_id`)
    REFERENCES `yurenia_db`.`customer` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `yurenia_db`.`country_has_currency`
-- -----------------------------------------------------
CREATE TABLE `yurenia_db`.`country_has_currency` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `country_id` INT NOT NULL,
  `currency_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_country_has_currency_currency1_idx` (`currency_id` ASC),
  INDEX `fk_country_has_currency_country1_idx` (`country_id` ASC),
  CONSTRAINT `fk_country_has_currency_country1`
    FOREIGN KEY (`country_id`)
    REFERENCES `yurenia_db`.`country` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_country_has_currency_currency1`
    FOREIGN KEY (`currency_id`)
    REFERENCES `yurenia_db`.`currency` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `yurenia_db`.`business_password`
-- -----------------------------------------------------
CREATE TABLE `yurenia_db`.`business_password` (
  `business_id` INT NOT NULL AUTO_INCREMENT,
  `business_password` VARCHAR(45) NULL,
  PRIMARY KEY (`business_id`),
  INDEX `fk_business_password_business1_idx` (`business_id` ASC),
  CONSTRAINT `fk_business_password_business1`
    FOREIGN KEY (`business_id`)
    REFERENCES `yurenia_db`.`business` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `yurenia_db`.`bank_password`
-- -----------------------------------------------------
CREATE TABLE `yurenia_db`.`bank_password` (
  `bank_id` INT NOT NULL AUTO_INCREMENT,
  `bank_password` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`bank_id`),
  INDEX `fk_bank_password_bank1_idx` (`bank_id` ASC),
  UNIQUE INDEX `bank_password_UNIQUE` (`bank_password` ASC),
  CONSTRAINT `fk_bank_password_bank1`
    FOREIGN KEY (`bank_id`)
    REFERENCES `yurenia_db`.`bank` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `yurenia_db`.`bank_has_transaction`
-- -----------------------------------------------------
CREATE TABLE `yurenia_db`.`bank_has_transaction` (
  `id` VARCHAR(45) NOT NULL,
  `bank_id` INT NOT NULL AUTO_INCREMENT,
  `transaction_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_bank_has_transaction_transaction1_idx` (`transaction_id` ASC),
  INDEX `fk_bank_has_transaction_bank1_idx` (`bank_id` ASC),
  CONSTRAINT `fk_bank_has_transaction_bank1`
    FOREIGN KEY (`bank_id`)
    REFERENCES `yurenia_db`.`bank` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_bank_has_transaction_transaction1`
    FOREIGN KEY (`transaction_id`)
    REFERENCES `yurenia_db`.`transaction` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

INSERT INTO `country`(`id`, `name`, `tax`) VALUES
(1, 'Ukraine', '1'),
(2, 'USA', '2'),
(3, 'France', '4'),
(4, 'Great Britian', '3'),
(5, 'Poland', '2'),
(6, 'Portugal', '1'),
(7, 'Sweden', '3'),
(8, 'Swizerland', '5'),
(9, 'Germany', '3'),
(10, 'Czechia', '1');

INSERT INTO `customer`(`id`, `name`, `surname`, `phone_number`, `email`, `income`, `country_id`) VALUES
(1, 'Ivan', 'Kovalchuk', '0987654321', 'ivank@gmail.com', '1500', '1'),
(2, 'Name', 'Surname', '0987654320', 'customer@gmail.com', '0', '2'),
(3, 'John', 'Smith', '0987655432', 'johnsmith@gmail.com', '2000', '2'),
(4, 'Willy', 'Waters', '0987654432', 'watergeen@gmail.com', '1500', '2'),
(5, 'Jorgen', 'Ginger', '0984561237', 'gingyj@gmail.com', '1500', '2'),
(6, 'Colt', 'Steele', '0912345678', 'lacolt@gmail.com', '1500', '2'),
(7, 'Bran', 'Stone', '0999999999', 'brandonpost@gmail.com', '1500', '2'),
(8, 'Svangire', 'Fergusson', '0913243542', 'svanrigferg@gmail.com', '1500', '2'),
(9, 'Fridrich', 'Waltzen', '066991034', 'frichwalt@gmail.com', '1500', '2'),
(10, 'Patryck', 'Olszanski', '0564839100', 'patryk777@gmail.com', '1500', '2');


INSERT INTO `customer_password` (`customer_id`, `customer_password`) VALUES
(1, 'password'),
(2, 'theoriginal'),
(3, 'thepassword'),
(4, 'thecoolpassword'),
(5, 'strongpass'),
(6, 'imtoolazy'),
(7, 'createpassword'),
(8, 'mysecurepass'),
(9, 'thisisstupid'),
(10, 'themostsecurepass');

INSERT INTO `bank`(`id`, `name`, `country_id`) VALUES
(1, 'IronBank', 1),
(2, 'AlphaBank', 10),
(3, 'CoolBank', 2),
(4, 'Monobank', 6),
(5, 'Oschadbank', 7),
(6, 'EuropeanBank', 8),
(7, 'WesternBank', 6),
(8, 'PrivatBank', 10),
(9, 'RedBank', 5),
(10, 'GreenBank', 4);

INSERT INTO `bank_password`(`bank_id`, `bank_password`) VALUES
(1, 'passwordd'),
(2, 'theoriginald'),
(3, 'thepasswordd'),
(4, 'thecoolpasswordd'),
(5, 'strongpassd'),
(6, 'imtoolazyd'),
(7, 'createpasswordd'),
(8, 'mysecurepassd'),
(9, 'thisisstupidd'),
(10, 'themostsecurepassd');

INSERT INTO `business`(`id`, `name`, `service`, `email`) VALUES
(1, 'coolbusiness', 'contracts', 'seriousmail@mail.com'),
(2, 'sodamagazine', 'beverages', 'sodamail@mail.com'),
(3, 'grocerystore', 'vegetables', 'grocery@mail.com'),
(4, 'cinema', 'movies', 'cinema@mail.com'),
(5, 'videogamestore', 'games', 'bestshop@mail.com'),
(6, 'fruitstore', 'fruits', 'fruits@mail.com'),
(7, 'alcoholstore', 'alcohol', 'thedrunks@mail.com'),
(8, 'winestore', 'wine', 'sweetwine@mail.com'),
(9, 'candyshop', 'candies', 'sweets@mail.com'),
(10, 'eletronicstore', 'telephones', 'electro@mail.com');

INSERT INTO `business_password` VALUES
(1, 'passwor'),
(2, 'theorigina'),
(3, 'thepasswor'),
(4, 'thecoolpasswor'),
(5, 'strongpas'),
(6, 'imtoolaz'),
(7, 'createpasswor'),
(8, 'mysecurepas'),
(9, 'thisisstupi'),
(10, 'themostsecurepas');

INSERT INTO `transaction`(`id`, `transaction_info`, `amount`,
`business_id`, `private_account_id`, `bank_id`, `transaction_code`) VALUES
(1, '', 1500, 1, 2, 3, 'afkehsd11'),
(2, '', 1409, 3, 4, 5, 'asdjhv23'),
(3, '', 123123, 7, 3, 2, 'asdqwe12'),
(4, '', 12387, 5, 3, 1, 'asudhj144'),
(5, '', 4987, 5, 2, 8, 'asda152'),
(6, '', 12312, 5, 2, 8, 'aasd152'),
(7, '', 237, 4, 2, 8, 'asdasd2'),
(8, '', 2368, 9, 1, 8, 'asdasd52'),
(9, '', 12, 2, 4, 5, 'asdasd1232'),
(10, '', 1, 8, 9, 10, 'asdasddasd2');

INSERT INTO `currency`(`id`, `name`, `transaction_id`) VALUES
(1, 'dollar', 1),
(2, 'euro', 2),
(3, 'pound', 3),
(4, 'yen', 4),
(5, 'ausdollar', 5),
(6, 'hryvnia', 6),
(7, 'rubles', 7),
(8, 'tenge', 8),
(9, 'peso', 9),
(10, 'lev', 10);

INSERT INTO `private_account`(`id`, `account_number`, `account_balance`, `owners_name`, `currency_id`,
`customer_id`, `transaction_id`) VALUES
(1, 4109237612873276, 0, 'John', 4, 3, 1),
(2, 4109237612733276, 0, 'Fridrich', 3, 9, 2),
(3, 0009237612873276, 0, 'Patryck', 1, 10, 3),
(4, 9609237612543276, 0, 'Jorgen', 4, 5, 4),
(5, 7309237322873276, 0, 'Ivan', 4, 1, 5),
(6, 2409238112873276, 0, 'Bran', 1, 7, 6),
(7, 6409231212873276, 0, 'Colt', 5, 6, 7),
(8, 3509237312873276, 0, 'Svanrige', 4, 8, 8),
(9, 4209237612873276, 0, 'Name', 4, 2, 9),
(10,2309237612873276, 0, 'Willy', 2, 4, 10);

INSERT INTO `business_account`(`id`, `owner_company`, `balance`, `business_id`, `currency_id`,
 `transaction_id`) VALUES
 (1, 'owner', 0, 1, 2, 6),
 (2, 'theowner', 0, 2, 3, 1),
 (3, 'coolowner', 0, 4, 7, 5),
 (4, 'richowner', 0, 4, 2, 3),
 (5, 'lazyowner', 0, 5, 9, 1),
 (6, 'dudeowner', 0, 6, 3, 7),
 (7, 'hopelessowner', 0, 7, 4, 4),
 (8, 'crazyowner', 0, 8, 1, 9),
 (9, 'anowner', 0, 9, 1, 5),
 (10, 'lastowner', 0, 10, 1, 10);

INSERT INTO `country_has_currency`(`country_id`, `currency_id`, `id`) VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 3),
(4, 4, 4),
(5, 5, 5),
(6, 6, 6),
(7, 7, 7),
(8, 8, 8),
(9, 9, 9),
(10, 10, 10);

INSERT INTO `bank_has_transaction`(`bank_id`, `transaction_id`, `id`) VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 3),
(4, 4, 4),
(5, 5, 5),
(6, 6, 6),
(7, 7, 7),
(8, 8, 8),
(9, 9, 9),
(10, 10, 10);

INSERT INTO `service`(`id`, `name`, `price`, `quantity`, `business_id`) VALUES
(1, 'ticket', 10, 1000, 1),
(2,  'beer', 100, 1000, 2),
(3,  'movie', 10000, 1000, 3),
(4,  'certificate', 5, 1000, 4),
(5,  'soda', 16, 1000, 5),
(6, 'tour', 70, 1000, 6),
(7, 'concert', 42, 1000, 7),
(8, 'tax', 34, 1000, 8),
(9, 'fee', 11, 1000, 9),
(10, 'tuition', 10, 1000, 10);

INSERT INTO `product`(`id`, `name`, `price`, `quantity`, `business_id`) VALUES
(1, 'soda', 10, 1000, 1),
(2,  'wine', 100, 1000, 2),
(3,  'carrot', 10000, 1000, 3),
(4,  'lettuce', 5, 1000, 4),
(5,  'toys', 16, 1000, 5),
(6, 'map', 70, 1000, 6),
(7, 'notebook', 42, 1000, 7),
(8, 'keyboard', 34, 1000, 8),
(9, 'bottle', 11, 1000, 9),
(10, 'book', 10, 1000, 10);

