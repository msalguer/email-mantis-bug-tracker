CREATE DEFINER=`root`@`localhost` FUNCTION `ConsultarEmailUsuario`(`IdUsuario` INT)
	RETURNS text
	LANGUAGE SQL
	DETERMINISTIC
	CONTAINS SQL
	SQL SECURITY DEFINER
	COMMENT ''
BEGIN

declare EmailUsuario TEXT;

set EmailUsuario=''; #Valor por defecto, por si no encuentra el usuario

select mantis_user_table.email into EmailUsuario
from mantis_user_table where mantis_user_table.id=IdUsuario;

if (EmailUsuario is null) then
	set EmailUsuario='';
end if;

return EmailUsuario;

END
