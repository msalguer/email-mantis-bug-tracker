CREATE DEFINER=`root`@`localhost` FUNCTION `ConsultarUsuario`(`CodUsuario` INT)
	RETURNS text
	LANGUAGE SQL
	DETERMINISTIC
	CONTAINS SQL
	SQL SECURITY DEFINER
	COMMENT ''
BEGIN

declare NombreUsuario TEXT;

set NombreUsuario=''; #Valor por defecto, por si no encuentra el usuario

select mantis_user_table.realname into NombreUsuario
from mantis_user_table where mantis_user_table.id=CodUsuario;

if (NombreUsuario is null) then
	set NombreUsuario='';
end if;

return NombreUsuario;

END
