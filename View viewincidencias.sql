select bug.id AS id,
bug.bug_text_id AS NumIncidencia,
ConsultarProyecto(bug.project_id) AS Proyecto,
bug.reporter_id as IdUsuarioInformador,
ConsultarUsuario(bug.reporter_id) AS UsuarioInformador,
bug.handler_id as IdUsuarioAsignado,
ConsultarUsuario(bug.handler_id) AS AsignadaAUsuario,
ConsultarEstado(bug.status) AS EstadoActual,
from_unixtime(bug.last_updated) AS FechaUltimaAct,
bug.summary AS Resumen,textobug.description AS Descripcion,
ConsultarUltimaHistoria(bug.id,bug.last_updated) AS UltimaHistoria
from (mantis_bug_table as bug 
left join mantis_bug_text_table as textobug on((textobug.id = bug.bug_text_id))) 
WHERE bug.last_updated>=(UNIX_TIMESTAMP()-500000) 
