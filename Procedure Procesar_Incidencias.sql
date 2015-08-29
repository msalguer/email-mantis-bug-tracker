CREATE DEFINER=`root`@`localhost` PROCEDURE `PROCESAR_INCIDENCIAS`()
	LANGUAGE SQL
	NOT DETERMINISTIC
	CONTAINS SQL
	SQL SECURITY DEFINER
	COMMENT ''
BEGIN

DECLARE IdIncidencia INT;
DECLARE IdUsuarioInformador INT;
DECLARE IdUsuarioAsignado INT;

DECLARE EOF BOOL DEFAULT FALSE;
DECLARE cursor1 CURSOR FOR 
select v.id, v.IdUsuarioInformador, v.IdUsuarioAsignado from viewincidencias v;

DECLARE CONTINUE HANDLER
     FOR SQLSTATE '02000'
     SET EOF = TRUE;

OPEN cursor1;

REPEAT

	FETCH cursor1 INTO IdIncidencia, IdUsuarioInformador, IdUsuarioAsignado;

	if not EOF then
		CALL ENVIAR_EMAIL(IdIncidencia, IdUsuarioInformador,IdUsuarioAsignado);
	end if;

UNTIL EOF END REPEAT;

CLOSE cursor1;


END
