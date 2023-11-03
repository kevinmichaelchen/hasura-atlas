schema "public" {
  comment = "standard public schema"
}

table "owner" {
  schema = schema.public
  column "id" {
    null = false
    type = int
    identity {
      generated = ALWAYS
      start = 1
      increment = 1
    }
  }
  column "name" {
    null = true
    type = varchar(100)
  }
  primary_key {
    columns = [column.id]
  }
}

table "pet" {
  schema = schema.public
  column "id" {
    null = false
    type = int
    identity {
      generated = ALWAYS
      start = 1
      increment = 1
    }
  }
  column "name" {
    null = false
    type = varchar(100)
  }
  column "owner_id" {
    null = true
    type = int
  }
  primary_key {
    columns = [column.id]
  }
  foreign_key "owner_fk" {
    columns     = [column.owner_id]
    ref_columns = [table.owner.column.id]
  }
}
