CREATE TABLE `usuarios_tareas_nuevas_no_email` (
	`IdUsuario` INT(10) NULL DEFAULT NULL,
	`IdProyecto` INT(10) NULL DEFAULT NULL
)
COMMENT='Sirve para excluir el envio de emails a los usuarios que están relacionados con estos proyectos'
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB;
