CREATE DEFINER=`root`@`localhost` FUNCTION `ObtenerCuerpoEmail`(`Bug_id` INT)
	RETURNS text
	LANGUAGE SQL
	DETERMINISTIC
	CONTAINS SQL
	SQL SECURITY DEFINER
	COMMENT ''
BEGIN


DECLARE Cuerpo TEXT;
declare vIdProyecto INT;
DECLARE vProyecto TEXT;
DECLARE vDescripcion TEXT;
DECLARE vUltimaHistoria TEXT;
DECLARE vNumIncidencia TEXT;
DECLARE vIdUsuarioInformador INT;
DECLARE vUsuarioInformador TEXT;
DECLARE vIdUsuarioAsignado INT;
DECLARE vUsuarioAsignado TEXT;
DECLARE vIdEstadoActual INT;
DECLARE vEstadoActual TEXT;
DECLARE vFechaUltimaAct TEXT;
DECLARE vResumen TEXT;

DECLARE cursor1 CURSOR FOR
SELECT bug.id as NumIncidencia,
ConsultarProyecto(bug.project_id) as Proyecto,
ConsultarUsuario(bug.reporter_id) as UsuarioInformador,
ConsultarUsuario(bug.handler_id) as AsignadaAUsuario, 
ConsultarEstado(bug.`status`) as EstadoActual, 
FROM_UNIXTIME(bug.last_updated) as FechaUltimaAct, 
bug.summary as Resumen, 
textobug.description as Descripcion,
ConsultarUltimaHistoria(bug.id,bug.last_updated) as UltimaHistoria
from  mantis_bug_table as bug 
left join mantis_bug_text_table as textobug on textobug.id=bug.bug_text_id
WHERE bug.id=Bug_id;

OPEN cursor1;
FETCH cursor1 into 
vNumIncidencia, 
vProyecto, 
vUsuarioInformador, 
vUsuarioAsignado, 
vEstadoActual, 
vFechaUltimaAct, 
vResumen, 
vDescripcion, 
vUltimaHistoria;


set Cuerpo = CONCAT (
'\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\n',
'Numero Incidencia: ',vNumIncidencia, '\n',
'Proyecto: ', vProyecto, '\n',
'Usuario Informador: ',vUsuarioInformador,'\n',
'Usuario Asignado: ', vUsuarioAsignado, '\n',
'Estado Actual: ', vEstadoActual, '\n',
'Fecha Ultima Actualización: ', vFechaUltimaAct, '\n\n',
'\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\n',
'Descripción Incidencia: ',vDescripcion, '\n\n',
'\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\n',
'Ultima Historia: ', vUltimaHistoria, '\n'
);

RETURN Cuerpo;

END
