-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema renaciente
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema renaciente
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `renaciente` DEFAULT CHARACTER SET utf8mb4 ;
USE `renaciente` ;

-- -----------------------------------------------------
-- Table `renaciente`.`usuarios`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `renaciente`.`usuarios` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(100) NOT NULL,
  `email` VARCHAR(150) NOT NULL,
  `password_hash` VARCHAR(255) NOT NULL,
  `telefono` VARCHAR(20) NULL DEFAULT NULL,
  `rol` ENUM('cliente', 'admin') NOT NULL DEFAULT 'cliente',
  `activo` TINYINT(1) NOT NULL DEFAULT 1,
  `creado_en` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP(),
  PRIMARY KEY (`id`),
  UNIQUE INDEX `email` (`email` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `renaciente`.`carritos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `renaciente`.`carritos` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `usuario_id` INT(10) UNSIGNED NULL DEFAULT NULL,
  `identificador_sesion` VARCHAR(100) NULL DEFAULT NULL,
  `estado` ENUM('activo', 'convertido', 'abandonado') NOT NULL DEFAULT 'activo',
  `creado_en` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP(),
  `actualizado_en` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `idx_carritos_usuario` (`usuario_id` ASC) VISIBLE,
  INDEX `idx_carritos_sesion` (`identificador_sesion` ASC) VISIBLE,
  INDEX `idx_carritos_estado` (`estado` ASC) VISIBLE,
  CONSTRAINT `fk_carritos_usuario`
    FOREIGN KEY (`usuario_id`)
    REFERENCES `renaciente`.`usuarios` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `renaciente`.`categorias`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `renaciente`.`categorias` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(100) NOT NULL,
  `identificador_url` VARCHAR(100) NOT NULL,
  `description` TEXT NULL DEFAULT NULL,
  `imagen` VARCHAR(255) NULL DEFAULT NULL,
  `orden` INT(11) NOT NULL DEFAULT 0,
  `activa` TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `identificador_url` (`identificador_url` ASC) VISIBLE,
  INDEX `idx_categorias_activa` (`activa` ASC) VISIBLE,
  INDEX `idx_categorias_orden` (`orden` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `renaciente`.`colores`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `renaciente`.`colores` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(50) NOT NULL,
  `codigo_color` VARCHAR(7) NULL DEFAULT NULL,
  `orden` INT(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `nombre` (`nombre` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `renaciente`.`detalle_carrito`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `renaciente`.`detalle_carrito` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `carrito_id` INT(10) UNSIGNED NOT NULL,
  `variante_id` INT(10) UNSIGNED NOT NULL,
  `cantidad` INT(11) NOT NULL DEFAULT 1,
  `precio_unitario` DECIMAL(10,0) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `uq_detalle_carrito_variante` (`carrito_id` ASC, `variante_id` ASC) VISIBLE,
  INDEX `idx_detalle_carrito` (`carrito_id` ASC) VISIBLE,
  INDEX `idx_detalle_carrito_variante` (`variante_id` ASC) VISIBLE,
  CONSTRAINT `fk_detalle_carrito`
    FOREIGN KEY (`carrito_id`)
    REFERENCES `renaciente`.`carritos` (`id`)
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `renaciente`.`direcciones`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `renaciente`.`direcciones` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `usuario_id` INT(10) UNSIGNED NOT NULL,
  `alias` VARCHAR(50) NULL DEFAULT NULL,
  `nombre_receptor` VARCHAR(100) NOT NULL,
  `telefono` VARCHAR(20) NOT NULL,
  `calle` VARCHAR(200) NOT NULL,
  `ciudad` VARCHAR(100) NOT NULL,
  `departamento` VARCHAR(100) NOT NULL,
  `codigo_postal` VARCHAR(20) NULL DEFAULT NULL,
  `pais` VARCHAR(50) NOT NULL DEFAULT 'Colombia',
  `es_principal` TINYINT(1) NOT NULL DEFAULT 0,
  `creado_en` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP(),
  PRIMARY KEY (`id`),
  INDEX `idx_direcciones_usuario` (`usuario_id` ASC) VISIBLE,
  CONSTRAINT `fk_direcciones_usuario`
    FOREIGN KEY (`usuario_id`)
    REFERENCES `renaciente`.`usuarios` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `renaciente`.`pedidos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `renaciente`.`pedidos` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `usuario_id` INT(10) UNSIGNED NULL DEFAULT NULL,
  `direccion_id` INT(10) UNSIGNED NULL DEFAULT NULL,
  `codigo` VARCHAR(20) NOT NULL,
  `correo_contacto` VARCHAR(150) NOT NULL,
  `subtotal` DECIMAL(10,0) NOT NULL,
  `envio` DECIMAL(10,0) NOT NULL DEFAULT 0,
  `descuento` DECIMAL(10,0) NOT NULL DEFAULT 0,
  `total` DECIMAL(10,0) NOT NULL,
  `estado` ENUM('pendiente', 'pagado', 'enviado', 'entregado', 'cancelado') NOT NULL DEFAULT 'pendiente',
  `metodo_pago` VARCHAR(50) NULL DEFAULT NULL,
  `notas` TEXT NULL DEFAULT NULL,
  `creado_en` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP(),
  `actualizado_en` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `codigo` (`codigo` ASC) VISIBLE,
  INDEX `idx_pedidos_usuario` (`usuario_id` ASC) VISIBLE,
  INDEX `idx_pedidos_direccion` (`direccion_id` ASC) VISIBLE,
  INDEX `idx_pedidosestado` (`estado` ASC) VISIBLE,
  INDEX `idx_pedidos_creado` (`creado_en` ASC) VISIBLE,
  CONSTRAINT `fk_pedidos_direccion`
    FOREIGN KEY (`direccion_id`)
    REFERENCES `renaciente`.`direcciones` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_pedidos_usuarios`
    FOREIGN KEY (`usuario_id`)
    REFERENCES `renaciente`.`usuarios` (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `renaciente`.`productos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `renaciente`.`productos` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `categoria_id` INT(10) UNSIGNED NOT NULL,
  `nombre` VARCHAR(150) NOT NULL,
  `identificador_url` VARCHAR(150) NOT NULL,
  `descripcion_corta` VARCHAR(150) NULL DEFAULT NULL,
  `descripcion_larga` TEXT NULL DEFAULT NULL,
  `precio_base` DECIMAL(10,0) NOT NULL,
  `activo` TINYINT(1) NOT NULL DEFAULT 1,
  `destacado` TINYINT(1) NOT NULL DEFAULT 0,
  `creado_en` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP(),
  `actualizado_en` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `identificador_url` (`identificador_url` ASC) VISIBLE,
  INDEX `idx_productos_categoria` (`categoria_id` ASC) VISIBLE,
  INDEX `idx_productos_activo` (`activo` ASC) VISIBLE,
  INDEX `idx_productos_destacado` (`destacado` ASC) VISIBLE,
  INDEX `idx_productos_identificador_url` (`identificador_url` ASC) VISIBLE,
  CONSTRAINT `fk_productos_categoria`
    FOREIGN KEY (`categoria_id`)
    REFERENCES `renaciente`.`categorias` (`id`)
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `renaciente`.`tallas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `renaciente`.`tallas` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(10) NOT NULL,
  `orden` INT(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `nombre` (`nombre` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `renaciente`.`variantes_producto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `renaciente`.`variantes_producto` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `producto_id` INT(10) UNSIGNED NOT NULL,
  `talla_id` INT(10) UNSIGNED NOT NULL,
  `color_id` INT(10) UNSIGNED NOT NULL,
  `codigo_interno` VARCHAR(50) NOT NULL,
  `precio` DECIMAL(10,0) NOT NULL,
  `stock` INT(11) NOT NULL DEFAULT 0,
  `activa` TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `codigo_interno` (`codigo_interno` ASC) VISIBLE,
  UNIQUE INDEX `uq_variante_unica` (`producto_id` ASC, `talla_id` ASC, `color_id` ASC) VISIBLE,
  INDEX `idx_variantes_producto` (`producto_id` ASC) VISIBLE,
  INDEX `idx_variantes_talla` (`talla_id` ASC) VISIBLE,
  INDEX `idx_variantes_color` (`color_id` ASC) VISIBLE,
  INDEX `idx_variantes_activa` (`activa` ASC) VISIBLE,
  CONSTRAINT `fk_variantes_color`
    FOREIGN KEY (`color_id`)
    REFERENCES `renaciente`.`colores` (`id`)
    ON UPDATE CASCADE,
  CONSTRAINT `fk_variantes_producto`
    FOREIGN KEY (`producto_id`)
    REFERENCES `renaciente`.`productos` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_variantes_talla`
    FOREIGN KEY (`talla_id`)
    REFERENCES `renaciente`.`tallas` (`id`)
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `renaciente`.`detalle_pedido`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `renaciente`.`detalle_pedido` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `pedido_id` INT(10) UNSIGNED NOT NULL,
  `variante_id` INT(10) UNSIGNED NOT NULL,
  `cantidad` INT(11) NOT NULL,
  `precio_unitario` DECIMAL(10,0) NOT NULL,
  `subtotal` DECIMAL(10,0) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `idx_detalle_pedido` (`pedido_id` ASC) VISIBLE,
  INDEX `idx_detalle_pedido_variante` (`variante_id` ASC) VISIBLE,
  CONSTRAINT `fk_detalle_pedido`
    FOREIGN KEY (`pedido_id`)
    REFERENCES `renaciente`.`pedidos` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_detalle_pedido_variante`
    FOREIGN KEY (`variante_id`)
    REFERENCES `renaciente`.`variantes_producto` (`id`)
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `renaciente`.`imagenes_producto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `renaciente`.`imagenes_producto` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `producto_id` INT(10) UNSIGNED NOT NULL,
  `ruta_imagen` VARCHAR(255) NOT NULL,
  `texto_alternativo` VARCHAR(150) NULL DEFAULT NULL,
  `orden` INT(11) NOT NULL DEFAULT 0,
  `es_principal` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  INDEX `idx_imagenes_producto` (`producto_id` ASC) VISIBLE,
  INDEX `idx_imagenes_principal` (`es_principal` ASC) VISIBLE,
  CONSTRAINT `fk_imagenes_producto`
    FOREIGN KEY (`producto_id`)
    REFERENCES `renaciente`.`productos` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `renaciente`.`pagos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `renaciente`.`pagos` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `pedido_id` INT(10) UNSIGNED NOT NULL,
  `metodo` VARCHAR(50) NOT NULL,
  `estado` ENUM('pendiente', 'aprobado', 'rechazado', 'reembolsado') NOT NULL DEFAULT 'pendiente',
  `monto` DECIMAL(10,0) NOT NULL,
  `referencia` VARCHAR(100) NULL DEFAULT NULL,
  `respuesta_pasarela` TEXT NULL DEFAULT NULL,
  `creado_en` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP(),
  `actualizado_en` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `idx_pagos_pedidos` (`pedido_id` ASC) VISIBLE,
  INDEX `idx_pagos_estado` (`estado` ASC) VISIBLE,
  CONSTRAINT `fk_pagos_pedido`
    FOREIGN KEY (`pedido_id`)
    REFERENCES `renaciente`.`pedidos` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
