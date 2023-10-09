If you give a YunoHost user the right to access this Superset app, he 
can connect to Superset with its YunoHost credential i.e. Superset
uses YunoHost LDAP to authenticate users.

Users will have the Superset role Public. This role has no permission 
by default in Superset so users will have access to nothing, just some
alerts saying they don't have rights.

Every YunoHost admins will have the Superset Admin role. So they can
do everything including changing roles.

As an admin you can, for example, give permissions to the Public role
so every users will have those permissions.

Be carreful that Superset roles depend on YunoHost groups the user 
belong to. It means that Superset roles will be synced with YunoHost
groups.

If you create the groups below in YunoHost, you can give the corresponding
existing role in Superset:
- superset_alpha => Alpha
- superset_gamma => Gamma
- superset_sql_lab => sql_lab

For more complex permissions, you can create 3 custom roles in Superset
and give these roles to a user by affecting him in the corresponding
YunoHost groups:
- superset_custom1 => custom1
- superset_custom2 => custom2
- superset_custom3 => custom3
