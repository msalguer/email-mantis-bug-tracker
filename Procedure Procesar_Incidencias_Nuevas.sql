CREATE DEFINER=`root`@`localhost` PROCEDURE `PROCESAR_INCIDENCIAS_NUEVAS`()
	LANGUAGE SQL
	NOT DETERMINISTIC
	CONTAINS SQL
	SQL SECURITY DEFINER
	COMMENT ''
BEGIN

DECLARE IdIncidencia INT;
DECLARE IdUsuario INT;
DECLARE EmailUsuario INT;

DECLARE EOF BOOL DEFAULT FALSE;
DECLARE cursor1 CURSOR FOR 
select v.NumIncidencia, v.IdUsuario, v.EmailUsuario from viewincidencias_nuevas v;

DECLARE CONTINUE HANDLER
     FOR SQLSTATE '02000'
     SET EOF = TRUE;

OPEN cursor1;

REPEAT

	FETCH cursor1 INTO IdIncidencia, IdUsuario, EmailUsuario;
	
	if not EOF then
		CALL ENVIAR_EMAIL(IdIncidencia, IdUsuario,EmailUsuario);
	end if;

UNTIL EOF END REPEAT;

CLOSE cursor1;

END
