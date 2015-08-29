CREATE DEFINER=`root`@`localhost` FUNCTION `ObtenerResumenEmail`(`Bug_id` INT)
	RETURNS text
	LANGUAGE SQL
	DETERMINISTIC
	CONTAINS SQL
	SQL SECURITY DEFINER
	COMMENT ''
BEGIN


DECLARE Resumen TEXT;

DECLARE vNumIncidencia TEXT;
DECLARE vProyecto TEXT;
DECLARE vResumen TEXT;

DECLARE cursor1 CURSOR FOR
SELECT bug.bug_text_id as NumIncidencia,
ConsultarProyecto(bug.project_id) as Proyecto,
bug.summary as Resumen
from  mantis_bug_table as bug 
WHERE bug.id=Bug_id;

OPEN cursor1;
FETCH cursor1 into vNumIncidencia, vProyecto, vResumen;

set Resumen = CONCAT ('\[Mantis\]\[Proyecto: ',vProyecto,'. Incidencia:',vNumIncidencia,'\]\: ',vResumen);

RETURN Resumen;

END
