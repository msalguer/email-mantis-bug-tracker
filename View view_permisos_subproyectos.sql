SELECT h.child_id as IdProyecto, u.user_id as IdUsuario, u.access_level
from mantis_project_user_list_table as u, mantis_project_hierarchy_table as h
where u.project_id=h.parent_id 
and u.access_level=55
UNION
select p.id as IdProyecto, u.id as IdUsuario, u.access_level
from mantis_user_table as u, mantis_project_table as p
where u.access_level=90 
