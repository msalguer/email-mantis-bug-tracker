CREATE DEFINER=`root`@`localhost` PROCEDURE `ENVIAR_EMAIL`(IN `Bug_id` INT, IN `Id_UsuarioInformador` INT, IN `Id_UsuarioAsignado` INT)
	LANGUAGE SQL
	NOT DETERMINISTIC
	CONTAINS SQL
	SQL SECURITY DEFINER
	COMMENT ''
BEGIN

DECLARE NumIncidencia INT;
DECLARE EmailUsuario TEXT;
DECLARE CabeceraEmail TEXT;
DECLARE CuerpoEmail TEXT;

DECLARE EmailUsuarioInformador TEXT;
DECLARE EmailUsuarioAsignado TEXT;
DECLARE EnviarEmailUsuarioInformador BOOL DEFAULT TRUE; #Por defecto se envían los mensajes a este Email si no está duplicado
DECLARE EnviarEmailUsuarioAsignado BOOL DEFAULT TRUE;

DECLARE EOF BOOL DEFAULT FALSE;
DECLARE cursor1 CURSOR FOR 
#SELECT v.Id, v.EmailUsuario as EmailUser1 from viewusuariosmonitores v
#WHERE v.Id=Bug_id;
select `bug`.`id` AS `Id`,
`ConsultarEmailUsuario`(`tmonitor`.`user_id`) AS `Email1` 
from (`mantis_bug_table` `bug` join `mantis_bug_monitor_table` `tmonitor` on((`bug`.`id` = `tmonitor`.`bug_id`)))
WHERE bug.Id=Bug_id;

 DECLARE CONTINUE HANDLER
     FOR SQLSTATE '02000'
     SET EOF = TRUE;
     

SET EmailUsuarioInformador= ConsultarEmailUsuario(Id_UsuarioInformador);

if not (Id_UsuarioAsignado is null) and Id_UsuarioAsignado!=0 then
	SET EmailUsuarioAsignado= ConsultarEmailUsuario(Id_UsuarioAsignado);
else
	SET EmailUsuarioAsignado='';
	SET EnviarEmailUsuarioAsignado= FALSE; #No se envía si no tiene de momento usuario asignado
end if;

SET CabeceraEmail= ObtenerResumenEmail(Bug_id);
SET CuerpoEmail= ObtenerCuerpoEmail(Bug_id);

OPEN cursor1;


REPEAT

		FETCH cursor1 INTO NumIncidencia, EmailUsuario;
  
  	if not(EmailUsuario is null) and EmailUsuario!='' then 
	  	insert into mantis_email_table 
				VALUES (DEFAULT,EmailUsuario,CabeceraEmail,CabeceraEmail,CuerpoEmail,DEFAULT);
		end if;

		if EmailUsuario=EmailUsuarioInformador then
			SET EnviarEmailUsuarioInformador= FALSE;
		end if;
		
		if EmailUsuario=EnviarEmailUsuarioAsignado then
				SET EnviarEmailUsuarioAsignado= FALSE;
		end if;

UNTIL EOF END REPEAT;

CLOSE cursor1;

if EnviarEmailUsuarioInformador=True then
	if not (EmailUsuarioInformador is null) and EmailUsuarioInformador!='' then
		insert into mantis_email_table 
		VALUES (DEFAULT,EmailUsuarioInformador,CabeceraEmail,CabeceraEmail,CuerpoEmail,DEFAULT);
	end if;
end if;

#Si son diferentes, envia otro Email
if EnviarEmailUsuarioAsignado=True and EmailUsuarioInformador!=EmailUsuarioAsignado then
	if not (EmailUsuarioAsignado is null) and EmailUsuarioAsignado!='' then
		insert into mantis_email_table 
		VALUES (DEFAULT,EmailUsuarioAsignado,CabeceraEmail,CabeceraEmail,CuerpoEmail,DEFAULT);
	end if;
end if;

END
