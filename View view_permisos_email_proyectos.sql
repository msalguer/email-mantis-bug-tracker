SELECT p.IdUsuario, u.username, u.realname, u.email, p.IdProyecto, p2.name as Proyecto, p.IdUserProj, e.IdUsuario as NoEmail
from mantis_user_table as u, 
mantis_project_table p2,
view_permisos_totales_usuario as p
#usuarios_tareas_nuevas_no_email as e
left outer join usuarios_tareas_nuevas_no_email as e on (concat(e.IdProyecto, e.IdUsuario) = p.IdUserProj)

where u.id =p.IdUsuario
and (p.access_level=55 or p.access_level=90 )
and p.IdProyecto=p2.id
#and e.IdUsuario=p.IdUsuario and e.IdProyecto=p.IdProyecto 
and e.IdUsuario is null 
and u.enabled=true 
