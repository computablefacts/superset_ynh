Si vous donnez à un utilisateur YunoHost le droit d'accéder à cette
application Superset, il peut se connecter au Superset avec ses informations
d'identification YunoHost, c'est-à-dire que Superset utilise le LDAP de
YunoHost pour authentifier les utilisateurs.

Les utilisateurs auront le rôle Superset Public. Ce rôle n'a aucune
autorisation par défaut dans Superset donc les utilisateurs n'auront accès à
rien, juste à quelques alertes indiquant qu'ils n'ont pas de droits.

Tous les administrateurs YunoHost auront le rôle Admin de Superset. Pour
qu'ils puissent tout faire, y compris modifier les rôles.

En tant qu'administrateur, vous pouvez, par exemple, accorder des autorisations
au rôle Public donc tous les utilisateurs auront ces autorisations.

Attention, les rôles Superset dépendent des groupes YunoHost auxquels
l'utilisateur appartient. Cela signifie que les rôles Superset seront
synchronisés à partir des groupes YunoHost.

Si vous créez les groupes ci-dessous dans YunoHost, vous pouvez donner le
rôle existant correspondant dans Superset :
- superset_alpha => Alpha
- superset_gamma => Gamma
- superset_sql_lab => sql_lab

Pour des autorisations plus complexes, vous pouvez créer 3 rôles personnalisés
dans Superset et attribuer ces rôles à un utilisateur en l'affectant dans le
groupe YunoHost correspondant :
- superset_custom1 => custom1
- superset_custom2 => custom2
- superset_custom3 => custom3
