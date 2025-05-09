-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 10-05-2025 a las 00:13:19
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
-- Base de datos: `database_funeraria`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `afiliacion`
--

CREATE TABLE `afiliacion` (
  `id_afiliacion` int(11) NOT NULL,
  `id_cedula` int(11) NOT NULL,
  `id_tipo` int(11) NOT NULL,
  `fecha_registro` date NOT NULL
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
  `id_cedula` int(50) NOT NULL,
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
  `evento` varchar(50) NOT NULL,
  `detalles` text DEFAULT NULL,
  `fecha` timestamp NOT NULL DEFAULT current_timestamp()
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

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `afiliacion`
--
ALTER TABLE `afiliacion`
  ADD PRIMARY KEY (`id_afiliacion`),
  ADD KEY `id_cedula` (`id_cedula`),
  ADD KEY `id_tipo` (`id_tipo`);

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
  ADD KEY `Id_usuario` (`id_cedula`);

--
-- Indices de la tabla `logs`
--
ALTER TABLE `logs`
  ADD PRIMARY KEY (`id_logs`),
  ADD KEY `idx_fecha` (`fecha`);

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
  ADD CONSTRAINT `afiliacion_ibfk_1` FOREIGN KEY (`id_cedula`) REFERENCES `usuarios` (`Id_cedula`),
  ADD CONSTRAINT `afiliacion_ibfk_2` FOREIGN KEY (`id_tipo`) REFERENCES `tipo_afiliacion` (`id_tipo`);

--
-- Filtros para la tabla `compra`
--
ALTER TABLE `compra`
  ADD CONSTRAINT `compra_ibfk_1` FOREIGN KEY (`id_afiliacion`) REFERENCES `afiliacion` (`id_afiliacion`);

--
-- Filtros para la tabla `estado_usuario`
--
ALTER TABLE `estado_usuario`
  ADD CONSTRAINT `estado_usuario_ibfk_1` FOREIGN KEY (`id_cedula`) REFERENCES `estado_usuario` (`Id_estado_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `plan_servicio`
--
ALTER TABLE `plan_servicio`
  ADD CONSTRAINT `plan_servicio_ibfk_1` FOREIGN KEY (`id_plan`) REFERENCES `plan` (`id_plan`),
  ADD CONSTRAINT `plan_servicio_ibfk_2` FOREIGN KEY (`id_servicio`) REFERENCES `servicio` (`id_servicio`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;



-- --------------------------------------------------------
-- Tabla de Bloqueo de Usuario
CREATE TABLE `bloqueo_usuario` (
  `id_bloqueo` INT AUTO_INCREMENT PRIMARY KEY,
  `id_cedula` INT NOT NULL,
  `motivo` TEXT,
  `fecha_bloqueo` DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (`id_cedula`) REFERENCES afiliacion(`id_cedula`)
);

-- --------------------------------------------------------
-- Tabla de Tipo de Afiliación
CREATE TABLE `tipo_afiliacion` (
  `id_tipo` INT PRIMARY KEY,
  `nombre_tipo` ENUM('Contribuyente', 'Beneficiario') NOT NULL
);

-- Agregar FK a afiliacion
ALTER TABLE `afiliacion`
ADD CONSTRAINT fk_tipo_afiliacion
FOREIGN KEY (`id_tipo`) REFERENCES tipo_afiliacion(`id_tipo`);

-- --------------------------------------------------------
-- Tabla de Servicio de Acompañamiento
CREATE TABLE `servicio_acompanamiento` (
  `id_servicio` INT AUTO_INCREMENT PRIMARY KEY,
  `nombre_servicio` ENUM('Silla', 'Elementos Fúnebres') NOT NULL,
  `id_afiliacion` INT,
  `fecha_servicio` DATE,
  FOREIGN KEY (`id_afiliacion`) REFERENCES afiliacion(`id_afiliacion`)
);
