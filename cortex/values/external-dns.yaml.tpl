image:
  tag: v0.5.100
aws:
  region: us-east-1
rbac:
  create: true
logLevel: debug
domainFilters:
- {{ ( ds "global" ).external_dns_domain }}