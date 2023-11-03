schema "hdb_catalog" {
  comment = "Hasura metadata catalogue"
}

table "hdb_action_log" {
  schema = schema.hdb_catalog
  column "id" {
    null    = false
    type    = uuid
    default = sql("hdb_catalog.gen_hasura_uuid()")
  }
  column "action_name" {
    null = true
    type = text
  }
  column "input_payload" {
    null = false
    type = jsonb
  }
  column "request_headers" {
    null = false
    type = jsonb
  }
  column "session_variables" {
    null = false
    type = jsonb
  }
  column "response_payload" {
    null = true
    type = jsonb
  }
  column "errors" {
    null = true
    type = jsonb
  }
  column "created_at" {
    null    = false
    type    = timestamptz
    default = sql("now()")
  }
  column "response_received_at" {
    null = true
    type = timestamptz
  }
  column "status" {
    null = false
    type = text
  }
  primary_key {
    columns = [column.id]
  }
  check "hdb_action_log_status_check" {
    expr = "(status = ANY (ARRAY['created'::text, 'processing'::text, 'completed'::text, 'error'::text]))"
  }
}

table "hdb_cron_event_invocation_logs" {
  schema = schema.hdb_catalog
  column "id" {
    null    = false
    type    = text
    default = sql("hdb_catalog.gen_hasura_uuid()")
  }
  column "event_id" {
    null = true
    type = text
  }
  column "status" {
    null = true
    type = integer
  }
  column "request" {
    null = true
    type = json
  }
  column "response" {
    null = true
    type = json
  }
  column "created_at" {
    null    = true
    type    = timestamptz
    default = sql("now()")
  }
  primary_key {
    columns = [column.id]
  }
  foreign_key "hdb_cron_event_invocation_logs_event_id_fkey" {
    columns     = [column.event_id]
    ref_columns = [table.hdb_cron_events.column.id]
    on_update   = CASCADE
    on_delete   = CASCADE
  }
  index "hdb_cron_event_invocation_event_id" {
    columns = [column.event_id]
  }
}
table "hdb_cron_events" {
  schema = schema.hdb_catalog
  column "id" {
    null    = false
    type    = text
    default = sql("hdb_catalog.gen_hasura_uuid()")
  }
  column "trigger_name" {
    null = false
    type = text
  }
  column "scheduled_time" {
    null = false
    type = timestamptz
  }
  column "status" {
    null    = false
    type    = text
    default = "scheduled"
  }
  column "tries" {
    null    = false
    type    = integer
    default = 0
  }
  column "created_at" {
    null    = true
    type    = timestamptz
    default = sql("now()")
  }
  column "next_retry_at" {
    null = true
    type = timestamptz
  }
  primary_key {
    columns = [column.id]
  }
  index "hdb_cron_event_status" {
    columns = [column.status]
  }
  index "hdb_cron_events_unique_scheduled" {
    unique  = true
    columns = [column.trigger_name, column.scheduled_time]
    where   = "(status = 'scheduled'::text)"
  }
  check "valid_status" {
    expr = "(status = ANY (ARRAY['scheduled'::text, 'locked'::text, 'delivered'::text, 'error'::text, 'dead'::text]))"
  }
}
table "hdb_metadata" {
  schema = schema.hdb_catalog
  column "id" {
    null = false
    type = integer
  }
  column "metadata" {
    null = false
    type = json
  }
  column "resource_version" {
    null    = false
    type    = integer
    default = 1
  }
  primary_key {
    columns = [column.id]
  }
  index "hdb_metadata_resource_version_key" {
    unique  = true
    columns = [column.resource_version]
  }
}
table "hdb_scheduled_event_invocation_logs" {
  schema = schema.hdb_catalog
  column "id" {
    null    = false
    type    = text
    default = sql("hdb_catalog.gen_hasura_uuid()")
  }
  column "event_id" {
    null = true
    type = text
  }
  column "status" {
    null = true
    type = integer
  }
  column "request" {
    null = true
    type = json
  }
  column "response" {
    null = true
    type = json
  }
  column "created_at" {
    null    = true
    type    = timestamptz
    default = sql("now()")
  }
  primary_key {
    columns = [column.id]
  }
  foreign_key "hdb_scheduled_event_invocation_logs_event_id_fkey" {
    columns     = [column.event_id]
    ref_columns = [table.hdb_scheduled_events.column.id]
    on_update   = CASCADE
    on_delete   = CASCADE
  }
}
table "hdb_scheduled_events" {
  schema = schema.hdb_catalog
  column "id" {
    null    = false
    type    = text
    default = sql("hdb_catalog.gen_hasura_uuid()")
  }
  column "webhook_conf" {
    null = false
    type = json
  }
  column "scheduled_time" {
    null = false
    type = timestamptz
  }
  column "retry_conf" {
    null = true
    type = json
  }
  column "payload" {
    null = true
    type = json
  }
  column "header_conf" {
    null = true
    type = json
  }
  column "status" {
    null    = false
    type    = text
    default = "scheduled"
  }
  column "tries" {
    null    = false
    type    = integer
    default = 0
  }
  column "created_at" {
    null    = true
    type    = timestamptz
    default = sql("now()")
  }
  column "next_retry_at" {
    null = true
    type = timestamptz
  }
  column "comment" {
    null = true
    type = text
  }
  primary_key {
    columns = [column.id]
  }
  index "hdb_scheduled_event_status" {
    columns = [column.status]
  }
}
table "hdb_schema_notifications" {
  schema = schema.hdb_catalog
  column "id" {
    null = false
    type = integer
  }
  column "notification" {
    null = false
    type = json
  }
  column "resource_version" {
    null    = false
    type    = integer
    default = 1
  }
  column "instance_id" {
    null = false
    type = uuid
  }
  column "updated_at" {
    null    = true
    type    = timestamptz
    default = sql("now()")
  }
  primary_key {
    columns = [column.id]
  }
  check "hdb_schema_notifications_id_check" {
    expr = "(id = 1)"
  }
}
table "hdb_version" {
  schema = schema.hdb_catalog
  column "hasura_uuid" {
    null    = false
    type    = uuid
    default = sql("hdb_catalog.gen_hasura_uuid()")
  }
  column "version" {
    null = false
    type = text
  }
  column "upgraded_on" {
    null = false
    type = timestamptz
  }
  column "cli_state" {
    null    = false
    type    = jsonb
    default = "{}"
  }
  column "console_state" {
    null    = false
    type    = jsonb
    default = "{}"
  }
  column "ee_client_id" {
    null = true
    type = text
  }
  column "ee_client_secret" {
    null = true
    type = text
  }
  primary_key {
    columns = [column.hasura_uuid]
  }
  index "hdb_version_one_row" {
    unique = true
    on {
      expr = "((version IS NOT NULL))"
    }
  }
}
