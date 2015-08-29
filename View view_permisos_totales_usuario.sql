SELECT IdProyecto, IdUsuario, access_level, concat (IdProyecto, IdUsuario) as IdUserProj from view_permisos_proyectos
union
select IdProyecto, IdUsuario, access_level, concat (IdProyecto, IdUsuario) as IdUserProj from view_permisos_subproyectos
group by IdProyecto, IdUsuario 
