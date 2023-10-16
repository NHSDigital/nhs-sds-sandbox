# NHS SDS SANDBOX

basic sds ldap with some pre-canned data

# quick start

just reference the repo in your docker-compose file
```yaml


services:

  sds_ldap:
    container_name: sds_ldap
    build:
      context: https://github.com/NHSDigital/nhs-sds-sandbox.git
    restart: unless-stopped
    ports:
      - "11389:11389"
      - "11636:11636"
    environment:
      LDAP_PORT_NUMBER: 11389
      LDAP_LDAPS_PORT_NUMBER: 11636
      LDAP_ENABLE_TLS: no
      BITNAMI_DEBUG: true
    volumes:
      # mount individual .ldif files to add data (bitnami won't find recursively, so you can't mount a subfolder)
      - ./more-ldifs/20_my_custom_users.ldif:/ldifs/20_my_custom_users.ldif:ro
      # mount individual schema extensions with a .ldif extension
#      - ./02_my_schema_extensions:/schemas/02_my_schema_extensions.ldif:ro

```


### contributing
contributors see [contributing](CONTRIBUTING.md)
