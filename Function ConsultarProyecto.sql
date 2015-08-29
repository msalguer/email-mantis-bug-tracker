CREATE DEFINER=`root`@`localhost` FUNCTION `ConsultarProyecto`(`CodProyecto` INT)
	RETURNS text
	LANGUAGE SQL
	DETERMINISTIC
	CONTAINS SQL
	SQL SECURITY DEFINER
	COMMENT ''
BEGIN

declare NombreProyecto TEXT;

set NombreProyecto=''; #Valor por defecto, por si no encuentra el usuario

select mantis_project_table.name into NombreProyecto
from mantis_project_table where mantis_project_table.id=CodProyecto;

if (NombreProyecto is null) then
	set NombreProyecto='';
end if;

return NombreProyecto;

END
