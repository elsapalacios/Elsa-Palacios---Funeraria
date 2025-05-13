-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 13-05-2025 a las 08:30:48
-- Versión del servidor: 10.4.28-MariaDB
-- Versión de PHP: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `funeraria_optimizada`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `bloquear_usuario` (IN `ced` INT, IN `razon` VARCHAR(255))   BEGIN
  INSERT INTO bloqueo_usuario (Id_cedula, motivo, estado, fecha_bloqueo)
  VALUES (ced, razon, 'Activo', NOW());
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `registrar_afiliacion` (IN `ced` INT, IN `id_tipo` INT)   BEGIN
  INSERT INTO afiliacion (Id_cedula, id_tipo)
  VALUES (ced, id_tipo);
END$$

--
-- Funciones
--
CREATE DEFINER=`root`@`localhost` FUNCTION `obtener_nombre_afiliado` (`ced` INT) RETURNS VARCHAR(200) CHARSET utf8mb4 COLLATE utf8mb4_general_ci DETERMINISTIC BEGIN
  DECLARE nombre_completo VARCHAR(200);
  SELECT CONCAT_WS(' ', nombres, apellidos)
  INTO nombre_completo
  FROM estado_usuario
  WHERE Id_cedula = ced;
  RETURN nombre_completo;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `obtener_tipo_afiliacion` (`ced` INT) RETURNS VARCHAR(50) CHARSET utf8mb4 COLLATE utf8mb4_general_ci DETERMINISTIC BEGIN
  DECLARE tipo VARCHAR(50);
  SELECT t.nombre_tipo
  INTO tipo
  FROM afiliacion a
  JOIN tipo_afiliacion t ON a.id_tipo = t.id_tipo
  WHERE a.Id_cedula = ced
  LIMIT 1;
  RETURN tipo;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `afiliacion`
--

CREATE TABLE `afiliacion` (
  `id_afiliacion` int(11) NOT NULL,
  `Id_cedula` int(11) NOT NULL,
  `id_tipo` int(11) NOT NULL,
  `fecha_registro` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `afiliado_servicio`
--

CREATE TABLE `afiliado_servicio` (
  `id_afiliado_servicio` int(11) NOT NULL,
  `id_afiliacion` int(11) NOT NULL,
  `id_servicio` int(11) NOT NULL,
  `fecha_servicio` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Disparadores `afiliado_servicio`
--
DELIMITER $$
CREATE TRIGGER `trg_log_servicio_solicitado` AFTER INSERT ON `afiliado_servicio` FOR EACH ROW BEGIN
  INSERT INTO logs (Id_cedula, nombre, direccion_ip, evento, fecha_evento)
  SELECT e.Id_cedula, CONCAT_WS(' ', e.nombres, e.apellidos), '127.0.0.1',
         CONCAT('Servicio solicitado: ', s.nombre_servicio), NOW()
  FROM afiliacion a
  JOIN estado_usuario e ON a.Id_cedula = e.Id_cedula
  JOIN servicios s ON s.id_servicio = NEW.id_servicio
  WHERE a.id_afiliacion = NEW.id_afiliacion;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `bloqueo_usuario`
--

CREATE TABLE `bloqueo_usuario` (
  `id_bloqueo` int(11) NOT NULL,
  `Id_cedula` int(11) NOT NULL,
  `motivo` text DEFAULT NULL,
  `fecha_bloqueo` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `compra`
--

CREATE TABLE `compra` (
  `id_compra` int(11) NOT NULL,
  `id_afiliacion` int(11) DEFAULT NULL,
  `fecha` datetime DEFAULT current_timestamp(),
  `descripcion` text DEFAULT NULL,
  `tipo` enum('Rosa','Ataúd','Cartel','Otro') DEFAULT NULL,
  `cantidad` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `estado_usuario`
--

CREATE TABLE `estado_usuario` (
  `Id_estado_usuario` int(50) NOT NULL,
  `Id_cedula` int(11) NOT NULL,
  `estado_usuario` enum('Vivo','Muerto') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `logs`
--

CREATE TABLE `logs` (
  `id_logs` bigint(20) NOT NULL,
  `Id_cedula` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `direccion_ip` varchar(45) NOT NULL,
  `evento` text NOT NULL,
  `fecha_evento` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `plan`
--

CREATE TABLE `plan` (
  `id_plan` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `cobertura_km` int(11) DEFAULT NULL,
  `tarjetas_agradecimiento` int(11) DEFAULT NULL,
  `tipo_cofre` varchar(50) DEFAULT NULL,
  `incluye_lapida` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `plan_servicio`
--

CREATE TABLE `plan_servicio` (
  `id_plan` int(11) NOT NULL,
  `id_servicio` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `servicio`
--

CREATE TABLE `servicio` (
  `id_servicio` int(11) NOT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  `tipo` enum('Acompañamiento','Elementos Fúnebres','Transporte','Cafetería','Misa','Otros') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `servicios`
--

CREATE TABLE `servicios` (
  `id_servicio` int(11) NOT NULL,
  `nombre_servicio` varchar(100) NOT NULL,
  `descripcion` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `servicio_acompanamiento`
--

CREATE TABLE `servicio_acompanamiento` (
  `id_servicio` int(11) NOT NULL,
  `nombre_servicio` enum('Silla','Elementos Fúnebres') NOT NULL,
  `id_afiliacion` int(11) DEFAULT NULL,
  `fecha_servicio` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipo_afiliacion`
--

CREATE TABLE `tipo_afiliacion` (
  `id_tipo` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `Id_cedula` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `usuario` int(50) NOT NULL,
  `contraseña_hash` varchar(255) NOT NULL,
  `correo` varchar(100) NOT NULL,
  `telefono` int(100) NOT NULL,
  `direccion` varchar(100) NOT NULL,
  `tipo_afiliacion` enum('Contribuyente','Beneficiario') DEFAULT NULL,
  `rol` enum('Admin','Empleado','Cliente') NOT NULL,
  `intentos_fallidos` tinyint(4) DEFAULT 0,
  `bloqueado` tinyint(1) DEFAULT 0,
  `fecha_bloqueo` datetime DEFAULT NULL,
  `ultimo_login` datetime DEFAULT NULL,
  `activo` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_estado_afiliados`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_estado_afiliados` (
`Id_cedula` int(11)
,`estado_usuario` enum('Vivo','Muerto')
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_servicios_por_afiliado`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_servicios_por_afiliado` (
`id_afiliacion` int(11)
,`id_servicio` int(11)
,`fecha_servicio` datetime
);

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_estado_afiliados`
--
DROP TABLE IF EXISTS `vista_estado_afiliados`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_estado_afiliados`  AS SELECT `estado_usuario`.`Id_cedula` AS `Id_cedula`, `estado_usuario`.`estado_usuario` AS `estado_usuario` FROM `estado_usuario` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_servicios_por_afiliado`
--
DROP TABLE IF EXISTS `vista_servicios_por_afiliado`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_servicios_por_afiliado`  AS SELECT `a`.`id_afiliacion` AS `id_afiliacion`, `s`.`id_servicio` AS `id_servicio`, `afs`.`fecha_servicio` AS `fecha_servicio` FROM (((`afiliado_servicio` `afs` join `afiliacion` `a` on(`afs`.`id_afiliacion` = `a`.`id_afiliacion`)) join `estado_usuario` `e` on(`a`.`Id_cedula` = `e`.`Id_cedula`)) join `servicios` `s` on(`afs`.`id_servicio` = `s`.`id_servicio`)) ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `afiliacion`
--
ALTER TABLE `afiliacion`
  ADD PRIMARY KEY (`id_afiliacion`),
  ADD KEY `Id_cedula` (`Id_cedula`),
  ADD KEY `id_tipo` (`id_tipo`);

--
-- Indices de la tabla `afiliado_servicio`
--
ALTER TABLE `afiliado_servicio`
  ADD PRIMARY KEY (`id_afiliado_servicio`),
  ADD KEY `id_afiliacion` (`id_afiliacion`),
  ADD KEY `id_servicio` (`id_servicio`);

--
-- Indices de la tabla `bloqueo_usuario`
--
ALTER TABLE `bloqueo_usuario`
  ADD PRIMARY KEY (`id_bloqueo`),
  ADD KEY `Id_cedula` (`Id_cedula`);

--
-- Indices de la tabla `compra`
--
ALTER TABLE `compra`
  ADD PRIMARY KEY (`id_compra`),
  ADD KEY `id_afiliacion` (`id_afiliacion`);

--
-- Indices de la tabla `estado_usuario`
--
ALTER TABLE `estado_usuario`
  ADD PRIMARY KEY (`Id_estado_usuario`),
  ADD KEY `Id_usuario` (`Id_cedula`);

--
-- Indices de la tabla `logs`
--
ALTER TABLE `logs`
  ADD PRIMARY KEY (`id_logs`),
  ADD KEY `Id_cedula` (`Id_cedula`);

--
-- Indices de la tabla `plan`
--
ALTER TABLE `plan`
  ADD PRIMARY KEY (`id_plan`);

--
-- Indices de la tabla `plan_servicio`
--
ALTER TABLE `plan_servicio`
  ADD PRIMARY KEY (`id_plan`,`id_servicio`),
  ADD KEY `id_servicio` (`id_servicio`);

--
-- Indices de la tabla `servicio`
--
ALTER TABLE `servicio`
  ADD PRIMARY KEY (`id_servicio`);

--
-- Indices de la tabla `servicios`
--
ALTER TABLE `servicios`
  ADD PRIMARY KEY (`id_servicio`);

--
-- Indices de la tabla `servicio_acompanamiento`
--
ALTER TABLE `servicio_acompanamiento`
  ADD PRIMARY KEY (`id_servicio`),
  ADD KEY `id_afiliacion` (`id_afiliacion`);

--
-- Indices de la tabla `tipo_afiliacion`
--
ALTER TABLE `tipo_afiliacion`
  ADD PRIMARY KEY (`id_tipo`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`Id_cedula`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `afiliacion`
--
ALTER TABLE `afiliacion`
  MODIFY `id_afiliacion` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `afiliado_servicio`
--
ALTER TABLE `afiliado_servicio`
  MODIFY `id_afiliado_servicio` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `bloqueo_usuario`
--
ALTER TABLE `bloqueo_usuario`
  MODIFY `id_bloqueo` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `compra`
--
ALTER TABLE `compra`
  MODIFY `id_compra` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `estado_usuario`
--
ALTER TABLE `estado_usuario`
  MODIFY `Id_estado_usuario` int(50) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `logs`
--
ALTER TABLE `logs`
  MODIFY `id_logs` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `plan`
--
ALTER TABLE `plan`
  MODIFY `id_plan` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `servicio`
--
ALTER TABLE `servicio`
  MODIFY `id_servicio` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `servicios`
--
ALTER TABLE `servicios`
  MODIFY `id_servicio` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `servicio_acompanamiento`
--
ALTER TABLE `servicio_acompanamiento`
  MODIFY `id_servicio` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tipo_afiliacion`
--
ALTER TABLE `tipo_afiliacion`
  MODIFY `id_tipo` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `Id_cedula` int(11) NOT NULL AUTO_INCREMENT;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `afiliacion`
--
ALTER TABLE `afiliacion`
  ADD CONSTRAINT `afiliacion_ibfk_1` FOREIGN KEY (`Id_cedula`) REFERENCES `usuarios` (`Id_cedula`),
  ADD CONSTRAINT `afiliacion_ibfk_2` FOREIGN KEY (`id_tipo`) REFERENCES `tipo_afiliacion` (`id_tipo`),
  ADD CONSTRAINT `fk_tipo_afiliacion` FOREIGN KEY (`id_tipo`) REFERENCES `tipo_afiliacion` (`id_tipo`);

--
-- Filtros para la tabla `afiliado_servicio`
--
ALTER TABLE `afiliado_servicio`
  ADD CONSTRAINT `afiliado_servicio_ibfk_1` FOREIGN KEY (`id_afiliacion`) REFERENCES `afiliacion` (`id_afiliacion`),
  ADD CONSTRAINT `afiliado_servicio_ibfk_2` FOREIGN KEY (`id_servicio`) REFERENCES `servicios` (`id_servicio`);

--
-- Filtros para la tabla `bloqueo_usuario`
--
ALTER TABLE `bloqueo_usuario`
  ADD CONSTRAINT `bloqueo_usuario_ibfk_1` FOREIGN KEY (`Id_cedula`) REFERENCES `afiliacion` (`Id_cedula`);

--
-- Filtros para la tabla `compra`
--
ALTER TABLE `compra`
  ADD CONSTRAINT `compra_ibfk_1` FOREIGN KEY (`id_afiliacion`) REFERENCES `afiliacion` (`id_afiliacion`);

--
-- Filtros para la tabla `estado_usuario`
--
ALTER TABLE `estado_usuario`
  ADD CONSTRAINT `estado_usuario_ibfk_1` FOREIGN KEY (`Id_cedula`) REFERENCES `estado_usuario` (`Id_estado_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `logs`
--
ALTER TABLE `logs`
  ADD CONSTRAINT `logs_ibfk_1` FOREIGN KEY (`Id_cedula`) REFERENCES `estado_usuario` (`Id_cedula`);

--
-- Filtros para la tabla `plan_servicio`
--
ALTER TABLE `plan_servicio`
  ADD CONSTRAINT `plan_servicio_ibfk_1` FOREIGN KEY (`id_plan`) REFERENCES `plan` (`id_plan`),
  ADD CONSTRAINT `plan_servicio_ibfk_2` FOREIGN KEY (`id_servicio`) REFERENCES `servicio` (`id_servicio`);

--
-- Filtros para la tabla `servicio_acompanamiento`
--
ALTER TABLE `servicio_acompanamiento`
  ADD CONSTRAINT `servicio_acompanamiento_ibfk_1` FOREIGN KEY (`id_afiliacion`) REFERENCES `afiliacion` (`id_afiliacion`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
