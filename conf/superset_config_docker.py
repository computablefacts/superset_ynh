# The allowed translation for you app
LANGUAGES = {
    "en": {"flag": "us", "name": "English"},
    #"es": {"flag": "es", "name": "Spanish"},
    #"it": {"flag": "it", "name": "Italian"},
    "fr": {"flag": "fr", "name": "French"},
    #"zh": {"flag": "cn", "name": "Chinese"},
    #"ja": {"flag": "jp", "name": "Japanese"},
    #"de": {"flag": "de", "name": "German"},
    #"pt": {"flag": "pt", "name": "Portuguese"},
    #"pt_BR": {"flag": "br", "name": "Brazilian Portuguese"},
    #"ru": {"flag": "ru", "name": "Russian"},
    #"ko": {"flag": "kr", "name": "Korean"},
    #"sk": {"flag": "sk", "name": "Slovak"},
    #"sl": {"flag": "si", "name": "Slovenian"},
}

from flask_appbuilder.security.manager import AUTH_LDAP

AUTH_TYPE = AUTH_LDAP
AUTH_LDAP_SERVER = "ldap://host.docker.internal"
AUTH_LDAP_USE_TLS = False

# registration configs
AUTH_USER_REGISTRATION = True  # allow users who are not already in the FAB DB
AUTH_USER_REGISTRATION_ROLE = "Public"  # this role will be given in addition to any AUTH_ROLES_MAPPING
AUTH_LDAP_FIRSTNAME_FIELD = "givenName"
AUTH_LDAP_LASTNAME_FIELD = "sn"
AUTH_LDAP_EMAIL_FIELD = "mail"  # if null in LDAP, email is set to: "{username}@email.notfound"

# search configs
AUTH_LDAP_SEARCH = "ou=users,dc=yunohost,dc=org"  # the LDAP search base
AUTH_LDAP_UID_FIELD = "uid"  # the username field
AUTH_LDAP_BIND_USER = "uid=__LDAP_USER__,ou=users,dc=yunohost,dc=org"  # the special bind username for search
AUTH_LDAP_BIND_PASSWORD = "__LDAP_PASSWORD__"  # the special bind password for search

# only allow users with Superset app permission in YunoHost
AUTH_LDAP_SEARCH_FILTER = "(&(|(objectclass=posixAccount))(permission=cn=__APP__.main,ou=permission,dc=yunohost,dc=org))"

# a mapping from LDAP DN to a list of Superset roles
AUTH_ROLES_MAPPING = {
    "cn=admins,ou=groups,dc=yunohost,dc=org": ["Admin"],
    "cn=superset_alpha,ou=groups,dc=yunohost,dc=org": ["Alpha"],
    "cn=superset_gamma,ou=groups,dc=yunohost,dc=org": ["Gamma"],
    "cn=superset_sql_lab,ou=groups,dc=yunohost,dc=org": ["sql_lab"],
    "cn=superset_custom1,ou=groups,dc=yunohost,dc=org": ["custom1"],
    "cn=superset_custom2,ou=groups,dc=yunohost,dc=org": ["custom2"],
    "cn=superset_custom3,ou=groups,dc=yunohost,dc=org": ["custom3"],
}

# the LDAP user attribute which has their role DNs
AUTH_LDAP_GROUP_FIELD = "memberOf"

# if we should replace ALL the user's roles each login, or only on registration
AUTH_ROLES_SYNC_AT_LOGIN = True

# force users to re-auth after 30min of inactivity (to keep roles in sync)
PERMANENT_SESSION_LIFETIME = 1800
