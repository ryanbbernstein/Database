-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema masterlist
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema masterlist
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `masterlist` DEFAULT CHARACTER SET utf8 ;
USE `masterlist` ;

-- -----------------------------------------------------
-- Table `masterlist`.`suppliers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `masterlist`.`suppliers` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `NAME` VARCHAR(30) NOT NULL,
  `DELIVERY_TIME` INT NULL,
  `DISCOUNT` FLOAT(5,2) NULL,
  PRIMARY KEY (`ID`),
  UNIQUE INDEX `ID_UNIQUE` (`ID` ASC),
  UNIQUE INDEX `NAME_UNIQUE` (`NAME` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `masterlist`.`products`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `masterlist`.`products` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `SKU` VARCHAR(30) NOT NULL,
  `NAME` TINYTEXT NOT NULL,
  `BRAND` VARCHAR(30) NULL,
  `SUPPLIER` INT NOT NULL,
  `COST` DECIMAL(10,2) NOT NULL,
  `MSRP` DECIMAL(10,2) NULL,
  `MAP` DECIMAL(10,2) NULL,
  `ALT_SKU` VARCHAR(25) NULL,
  `ALT_SUPPLIER` VARCHAR(30) NULL,
  `ALT_COST` DECIMAL(10,2) NULL,
  `UPC` VARCHAR(14) NULL,
  `WIDTH` FLOAT(5,2) NOT NULL,
  `LENGTH` FLOAT(5,2) NOT NULL,
  `HEIGHT` FLOAT(5,2) NOT NULL,
  `WEIGHT(LB)` FLOAT(6,2) NOT NULL,
  `DIM_WEIGHT` FLOAT(6,2) GENERATED ALWAYS AS ((LENGTH*WIDTH*HEIGHT)/166) VIRTUAL,
  `SHIPPING_WEIGHT` SMALLINT(5) NOT NULL DEFAULT WEIGHT(LB),
  `SHIPPING_COST` DECIMAL(10,2) NULL,
  `LABOR_MATERIALS_COST` DECIMAL(10,2) NOT NULL DEFAULT 1.5,
  `BC_PRICE` DECIMAL(10,2) GENERATED ALWAYS AS (((COST*1.17)+SHIPPING_COST+LABOR_MATERIALS_COST)*1.15) VIRTUAL,
  `AMAZON_PRICE` DECIMAL(10,2) GENERATED ALWAYS AS (((COST*1.17)+SHIPPING_COST+LABOR_MATERIALS_COST)*1.1765),
  `AMAZON_FLOOR` DECIMAL(10,2) GENERATED ALWAYS AS (((COST*1.01)+SHIPPING_COST+LABOR_MATERIALS_COST)*1.1765),
  `AMAZON_CEILING` DECIMAL(10,2) GENERATED ALWAYS AS (((COST+SHIPPING_COST)^0.7)+AMAZON_PRICE),
  `AMAZON_VENDOR_PRICE` DECIMAL(10,2) GENERATED ALWAYS AS (),
  `FBA_PRICE` DECIMAL(10,2) NULL,
  `FBA_FLOOR` DECIMAL(10,2) NULL,
  `FBA_CEILING` DECIMAL(10,2) NULL,
  `EBAY_PRICE` DECIMAL(10,2) GENERATED ALWAYS AS (((COST*1.17)+SHIPPING_COST+LABOR_MATERIALS_COST)*1.1765) VIRTUAL,
  `JET_PRICE` DECIMAL(10,2) NULL,
  `RAKUTEN_PRICE` DECIMAL(10,2) GENERATED ALWAYS AS (((COST*1.17)+SHIPPING_COST+LABOR_MATERIALS_COST)*1.1765),
  `HOUZZ_PRICE` DECIMAL(10,2) GENERATED ALWAYS AS (((COST*1.17)+SHIPPING_COST+LABOR_MATERIALS_COST)*1.1765),
  `NEWEGG_PRICE` DECIMAL(10,2) GENERATED ALWAYS AS (((COST*1.17)+SHIPPING_COST+LABOR_MATERIALS_COST)*1.12),
  `SEARS_PRICE` DECIMAL(10,2) GENERATED ALWAYS AS (((COST*1.17)+SHIPPING_COST+LABOR_MATERIALS_COST)*1.22) VIRTUAL,
  PRIMARY KEY (`ID`),
  UNIQUE INDEX `UPC_UNIQUE` (`UPC` ASC),
  UNIQUE INDEX `SKU_UNIQUE` (`SKU` ASC),
  UNIQUE INDEX `ID_UNIQUE` (`ID` ASC),
  INDEX `fk_products_suppliers_idx` (`SUPPLIER` ASC),
  CONSTRAINT `fk_products_suppliers`
    FOREIGN KEY (`SUPPLIER`)
    REFERENCES `masterlist`.`suppliers` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `masterlist`.`alternates`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `masterlist`.`alternates` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `PRODUCT` INT NOT NULL,
  `SUPPLIER` INT NOT NULL,
  `SKU` VARCHAR(30) NOT NULL,
  `COST` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE INDEX `ID_UNIQUE` (`ID` ASC),
  INDEX `fk_alternates_products1_idx` (`PRODUCT` ASC),
  INDEX `fk_alternates_suppliers1_idx` (`SUPPLIER` ASC),
  CONSTRAINT `fk_alternates_products1`
    FOREIGN KEY (`PRODUCT`)
    REFERENCES `masterlist`.`products` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_alternates_suppliers1`
    FOREIGN KEY (`SUPPLIER`)
    REFERENCES `masterlist`.`suppliers` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `masterlist`.`users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `masterlist`.`users` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `USER` VARCHAR(15) NOT NULL,
  `PASSWORD` VARCHAR(20) NOT NULL,
  `RIGHTS` ENUM('admin', 'data', 'cs', 'store', 'warehouse') NOT NULL DEFAULT 'cs',
  UNIQUE INDEX `user_UNIQUE` (`USER` ASC),
  PRIMARY KEY (`ID`),
  UNIQUE INDEX `ID_UNIQUE` (`ID` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `masterlist`.`log_book`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `masterlist`.`log_book` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `TIMESTAMP` TIMESTAMP NOT NULL,
  `USER` INT NOT NULL,
  `CHANGE` ENUM('UPDATE', 'DELETE') NOT NULL,
  `DETAIL` TINYTEXT NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE INDEX `ID_UNIQUE` (`ID` ASC),
  INDEX `fk_log_book_users1_idx` (`USER` ASC),
  CONSTRAINT `fk_log_book_users1`
    FOREIGN KEY (`USER`)
    REFERENCES `masterlist`.`users` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
