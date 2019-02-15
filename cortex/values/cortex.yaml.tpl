fullnameOverride: cortex

cortex:
  env:
  - name: GOGC
    value: "60"
  - name: JAEGER_AGENT_HOST
    value: jaegertracing-agent.cortex.svc.cluster.local
  - name: JAEGER_SAMPLER_TYPE
    value: ratelimiting
  - name: JAEGER_SAMPLER_PARAM
    value: '7'
  cache_enable_fifocache: "true"
  consul_hostname: "consul.cortex.svc.cluster.local:8500"
  database_uri: "postgres://{{ ( ds "global" ).pg_db_user }}:{{ ( ds "global" ).pg_db_pass }}@postgresql-postgresql.cortex.svc.cluster.local/{{ ( ds "global" ).pg_db_name }}?sslmode=disable"
  distributor_health_check_ingesters: "true"
  distributor_ingestion_burst_size: "5000000"
  distributor_ingestion_rate_limit: "2500000"
  distributor_replication_factor: "3"
  distributor_shard_by_all_labels: "true"
  dynamodb_original_table_name: "{{ ( ds "infra" ).dynamodb_table_name }}"
  dynamodb_periodic_table_from: "2030-01-01"
  dynamodb_url: "{{ ( ds "infra" ).dynamodb_url }}"
  dynamodb_use_periodic_tables: "false"
  dynamodb_v9_schema_from: "2019-01-01"
  event_sample_rate: "1000"
  ingester_chunk_encoding: "3"
  ingester_claim_on_rollout: "true"
  ingester_client_expected_samples_per_series: "1"
  ingester_client_expected_timeseries: "1000"
  ingester_join_after: "30s"
  ingester_max_chunk_idle: "60m"
  ingester_max_series_per_metric: "5000000"
  ingester_max_series_per_user: "10000000"
  ingester_normalise_tokens: "true"
  ingester_num_tokens: "512"
  ingester_retain_period: "10m10s"
  ingester_search_pending_for: "2m"
  log_level: "info"
  memcached_expiration: "24h"
  memcached_hostname: "memcached-chunk.cortex.svc.cluster.local"
  memcached_service: "memcache"
  memcached_timeout: "1s"
  querier_align_querier_with_step: "true"
  querier_batch_iterators: "true"
  querier_cache_results: "true"
  querier_ingester_streaming: "true"
  querier_max_concurrent: "200"
  querier_max_outstanding_requests_per_tenant: "100"
  querier_query_parallelism: "1000"
  querier_timeout: "5m"
  querier_worker_parallelism: "100"
  s3_url: "{{ ( ds "infra" ).s3_url }}"
  store_cardinality_cache_size: "10000"
  store_index_cache_read_memcached_expiration: "24h"
  store_index_cache_read_memcached_hostname: "memcached-read.cortex.svc.cluster.local"
  store_index_cache_read_memcached_service: "memcache"
  store_index_cache_read_memcached_timeout: "1s"
  store_index_cache_validity: "10m"
  store_index_cache_write_memcached_expiration: "24h"
  store_index_cache_write_memcached_hostname: "memcached-write.cortex.svc.cluster.local"
  store_index_cache_write_memcached_service: "memcache"
  store_index_cache_write_memcached_timeout: "1s"
  store_memcached_hostname: "memcached-read.cortex.svc.cluster.local"
  store_memcached_service: "memcache"
  store_min_chunk_age: "30m"
  validation_max_label_names_per_series: "25"
  validation_reject_old_samples: "true"

alertmanager:
  enabled: false
  replicaCount: 0
  servicemonitor:
    enabled: true
    labels:
      release: prometheus-operator

configs:
  enabled: false
  replicaCount: 0
  servicemonitor:
    enabled: true
    labels:
      release: prometheus-operator

distributor:
  enabled: true
  replicaCount: 5
  servicemonitor:
    enabled: true
    labels:
      release: prometheus-operator
  resources:
    limits:
      cpu: 2
      memory: 2Gi
    requests:
      cpu: 1
      memory: 512Mi

ingester:
  enabled: true
  replicaCount: 9
  servicemonitor:
    enabled: true
    labels:
      release: prometheus-operator
  resources:
    limits:
      cpu: 4
      memory: 8Gi
    requests:
      cpu: 2
      memory: 4Gi

nginx:
  enabled: true
  replicaCount: 3
  servicemonitor:
    enabled: true
    labels:
      release: prometheus-operator
  service:
    type: LoadBalancer
    annotations:
      external-dns.alpha.kubernetes.io/ttl: "10"
      external-dns.alpha.kubernetes.io/alias: "false"
      external-dns.alpha.kubernetes.io/hostname: "{{ ( ds "global" ).cortex_external_dns }}"

querier:
  enabled: true
  replicaCount: 5
  log_level: "debug"
  servicemonitor:
    enabled: true
    labels:
      release: prometheus-operator
  resources:
    limits:
      cpu: 4
      memory: 12Gi
    requests:
      cpu: 2
      memory: 4Gi
  env:
  - name: GOGC
    value: "60"
  - name: JAEGER_AGENT_HOST
    value: jaegertracing-agent.cortex.svc.cluster.local
  - name: JAEGER_SAMPLER_TYPE
    value: ratelimiting
  - name: JAEGER_SAMPLER_PARAM
    value: '7'
  - name: GODEBUG
    value: gctrace=1

query_frontend:
  enabled: true
  replicaCount: 2
  servicemonitor:
    enabled: true
    labels:
      release: prometheus-operator

ruler:
  enabled: false
  replicaCount: 0
  servicemonitor:
    enabled: true
    labels:
      release: prometheus-operator

table_manager:
  enabled: false
