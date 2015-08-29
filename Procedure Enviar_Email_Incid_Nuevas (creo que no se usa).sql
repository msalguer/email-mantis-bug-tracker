CREATE DEFINER=`root`@`localhost` PROCEDURE `ENVIAR_EMAIL_INCID_NUEVAS`(IN `Bug_id` INT, IN `Id_Usuario` INT, IN `Email_Usuario` INT)
	LANGUAGE SQL
	NOT DETERMINISTIC
	CONTAINS SQL
	SQL SECURITY DEFINER
	COMMENT ''
BEGIN

DECLARE EmailUsuario TEXT;
DECLARE CabeceraEmail TEXT;
DECLARE CuerpoEmail TEXT;
    
SET EmailUsuario= Email_Usuario;	#ConsultarEmailUsuario(Id_UsuarioInformador);

SET CabeceraEmail= ObtenerResumenEmail(Bug_id);
SET CuerpoEmail= ObtenerCuerpoEmail(Bug_id);

if not(EmailUsuario is null) and EmailUsuario!='' then 
 	insert into mantis_email_table 
		VALUES (DEFAULT,EmailUsuario,CabeceraEmail,CabeceraEmail,CuerpoEmail,DEFAULT);
end if;


END
