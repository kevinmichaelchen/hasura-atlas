# hasura-atlas

This demo shows an example Hasura project which sources its SQL migrations from [Atlas][atlas], a tool used to drive **_declarative_** database migrations.

Think of it like Terraform for your database!

This is a big improvement over existing database migration solutions, for a few reasons:

1. You can easily `git diff` and see how your schemas has evolved over time.
1. You avoid accumulating dozens, if not hundreds, of `up.sql` migration files.

The database schema is maintained with HCL in [**`public.hcl`**](./db/schema/public.hcl).

## Getting started

### With pkgx

Assuming you've installead [pkgx](https://pkgx.sh/), it should be easy to get started.

```shell
sudo rm -rf $(which pkgx) ; curl -fsS https://pkgx.sh | sh
```

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

## Using the API

### Creating some data

```graphql
mutation CreateOwnerAndPet {
  owner: insertOwnerOne(
    object: {
      name: "Kevin"
      pets: {
        data: {
          name: "Porkchop"
        }
      }
    }
  ) {
    id
    name
    pets {
      id
      name
    }
  }
}
```

[atlas]: https://atlasgo.io/
