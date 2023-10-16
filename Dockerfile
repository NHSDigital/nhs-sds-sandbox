FROM bitnami/openldap:2.6.6-debian-11-r59

ENV LDAP_ALLOW_ANON_BINDING="yes"
ENV LDAP_ROOT="o=nhs"
ENV LDAP_BIND_DN="cn=admin,o=nhs"

USER root

RUN mkdir -p  /ldifs \
    && mkdir -p /schemas

COPY ./ldifs/* /ldifs
COPY ./schemas/* /schemas

USER 1001