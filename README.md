# hasura-atlas

This demo shows an example Hasura project which sources its SQL migrations from [Atlas][atlas], a tool used to drive **_declarative_** database migrations.

Think of it like Terraform for your database!

This is a big improvement over existing database migration solutions, which inevitably lead to the accumulation of dozens, if not hundreds, of `up.sql` migration files.

## Getting started

### With pkgx

#### Start Hasura

```shell
pkgx task start
```

#### Apply migrations

```shell
pkgx task atlas:migrate
```

#### Inspect database

```shell
pkgx task atlas:inspect
```

[atlas]: https://atlasgo.io/
