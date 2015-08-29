select `bug`.`id` AS `Id`,
`tmonitor`.`user_id` AS `IdUsuario`,
`ConsultarEmailUsuario`(`tmonitor`.`user_id`) AS `EmailUsuario` 
from (`mantis_bug_table` `bug` join `mantis_bug_monitor_table` `tmonitor` on((`bug`.`id` = `tmonitor`.`bug_id`))) 
