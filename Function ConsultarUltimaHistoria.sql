CREATE DEFINER=`root`@`localhost` FUNCTION `ConsultarUltimaHistoria`(`Bug_id` INT, `FechaUltimaActualizacion` INT)
	RETURNS text
	LANGUAGE SQL
	DETERMINISTIC
	CONTAINS SQL
	SQL SECURITY DEFINER
	COMMENT ''
BEGIN


declare FechaUltimaHistoria INT;
DECLARE IdUltimaHistoria INT;

declare FieldNameHistoria TEXT;
declare ValueHistoria TEXT;
declare TipoHistoria INT;
declare NombreUsuarioHistoria TEXT;

declare ValorRetorno TEXT;

select max(historia.date_modified) into FechaUltimaHistoria
from mantis_bug_history_table as historia
where historia.bug_id=Bug_Id;

select min(historia.id) into IdUltimaHistoria
from mantis_bug_history_table as historia
where historia.bug_id=Bug_Id and historia.date_modified=FechaUltimaHistoria;

select historia.`type` into TipoHistoria
from mantis_bug_history_table as historia
where historia.id=IdUltimaHistoria;

select historia.field_name into FieldNameHistoria
from mantis_bug_history_table as historia
where historia.id=IdUltimaHistoria;

select ConsultarUsuario(historia.user_id) into NombreUsuarioHistoria
from mantis_bug_history_table as historia
where historia.id=IdUltimaHistoria;

if FieldNameHistoria='' then
	select historia.old_value into ValueHistoria
	from mantis_bug_history_table as historia
	where historia.id=IdUltimaHistoria;
else
	select historia.new_value into ValueHistoria
	from mantis_bug_history_table as historia
	where historia.id=IdUltimaHistoria;
end if;

set ValorRetorno= CONCAT('Modificación Realizada. ',ValueHistoria); #Por defecto

if TipoHistoria=0 then #Modificación de datos básicos de la incidencia

	set ValorRetorno= CONCAT('Modificado: ',FieldNameHistoria,'Valor: ',ValueHistoria);

	if FieldNameHistoria='category' then
 		set ValorRetorno= CONCAT('Modificada categoría: ',ValueHistoria);
	end if;
 
	if FieldNameHistoria='priority' then
		set ValorRetorno=CONCAT('Modificada prioridad: ',ValueHistoria);
	end if;

	if FieldNameHistoria='project_id' then
 		set ValorRetorno=CONCAT('Modificado proyecto: ',ValueHistoria);
	end if;

	if FieldNameHistoria='status' then
 		set ValorRetorno=CONCAT('Modificado estado: ',ConsultarEstado(ValueHistoria));
	end if;

	if FieldNameHistoria='summary' then
 		set ValorRetorno=CONCAT('Modificado resumen de incidencia: ',ValueHistoria);
	end if;
	
	if FieldNameHistoria='handler_id' then
			set ValorRetorno=CONCAT('Asignada a usuario: ',ConsultarUsuario(ValueHistoria));
	end if;

	if FieldNameHistoria='resolution' then
		set ValorRetorno=CONCAT('Modificada resolución: ',ValueHistoria);
		if ValueHistoria='20' then  #Corregida
			set ValorRetorno='Modificada resolución: Corregida';
		end if;
		if ValueHistoria='30' then  #Reabierta
			set ValorRetorno='Modificada resolución: Reabierta';
		end if;
		if ValueHistoria='40' then  #No reproducible
			set ValorRetorno='Modificada resolución: No reproducible';
		end if;	
		if ValueHistoria='60' then  #Duplicada
			set ValorRetorno='Modificada resolución: Duplicada';
		end if;	
		if ValueHistoria='70' then  #No es una incidencia
			set ValorRetorno='Modificada resolución: No es una incidencia';
		end if;	
		if ValueHistoria='80' then  #Suspendida
			set ValorRetorno='Modificada resolución: Suspendida';
		end if;		
	end if;

end if;

if TipoHistoria=1 then
	set ValorRetorno= CONCAT('Asignada a usuario: ',NombreUsuarioHistoria);
end if;

if TipoHistoria=2 then # Añadida nota
	select notas.note into ValorRetorno
	from mantis_bugnote_text_table as notas
	where notas.id=ValueHistoria;
	set ValorRetorno=CONCAT('Nueva Nota: ',ValorRetorno);
end if;


if TipoHistoria=8 then
	set ValorRetorno=CONCAT('Pasos para reproducir actualizados: ',ValueHistoria);
end if;

if TipoHistoria=9 then
	set ValorRetorno= CONCAT('Nuevo fichero adjunto: ',ValueHistoria);
end if;

if ValorRetorno is null then
	SET ValorRetorno= 'Nueva incidencia';
end if;

return ValorRetorno;

END
