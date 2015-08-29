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
ConsultarUltimaHistoria(bug.id,bug.last_updated) AS UltimaHistoria,
v.IdUsuario as IdUsuario, v.email as EmailUsuario
from 
view_permisos_email_proyectos v,
mantis_bug_table as bug,
mantis_bug_text_table as textobug
WHERE bug.last_updated>=(UNIX_TIMESTAMP()-800000) 
and textobug.id = bug.bug_text_id
and bug.`status`=10
and bug.handler_id=0
and v.IdProyecto=bug.project_id 
and bug.reporter_id!= v.IdUsuario
group by v.email, bug.id 
