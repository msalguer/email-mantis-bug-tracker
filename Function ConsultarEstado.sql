CREATE DEFINER=`root`@`localhost` FUNCTION `ConsultarEstado`(`CodEstado` INT)
	RETURNS text
	LANGUAGE SQL
	DETERMINISTIC
	CONTAINS SQL
	SQL SECURITY DEFINER
	COMMENT ''
BEGIN

declare CodigoEstado TEXT;


if CodEstado=10 then
 set CodigoEstado= 'Nueva';
end if;

if CodEstado=20 then
 set CodigoEstado= 'Se necesitan más datos';
end if;

if CodEstado=30 then
 set CodigoEstado= 'Aceptada';
end if;

if CodEstado=40 then
 set CodigoEstado= 'Confirmada';
end if;

if CodEstado=50 then
 set CodigoEstado= 'Asignada';
end if;

if CodEstado=80 then
 set CodigoEstado= 'Resuelta';
end if;

if CodEstado=90 then
 set CodigoEstado= 'Cerrada';
end if;

return CodigoEstado;

END
