SELECT p.project_id as IdProyecto, p.user_id as IdUsuario, p.access_level
from mantis_project_user_list_table as p
where p.access_level=55 
