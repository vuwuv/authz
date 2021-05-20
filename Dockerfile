FROM alpine:3.12

# Indicates basic authorization is enforced
ENV AUTHORIZER basic
# Indicates basic auditor type is used (log to console)
ENV AUDITOR basic
# Indicates audit logs are streamed to STDOUT
ENV AUDITOR-HOOK ""

VOLUME /run/docker/plugins/

ADD ./policy.json	/var/lib/authz-broker/policy.json
ADD ./bin/authz-broker  /usr/bin/authz-broker

CMD ["/usr/bin/authz-broker"]
