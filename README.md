# absinthe_showcase
This is a showcase for Absinthe

## Features

- Battery included
  - You can soon try it in Docker Compose.
- Written in the latest libraries:
  - OTP 21, Elixir 1.7.4
  - Phoenix 1.4, Ecto 3.0
  - Absinthe 1.4.13
- Avoiding N+1 problem with [dataloader](https://hex.pm/packages/dataloader)
- Authorizing user permission with a custom middleware
- Count the number of records regardless of LIMIT/OFFSET specified, which is very useful in pagination
- Supports multistage query such as `{questions{users{} answers{}}}`, `{me {users{} questions{} answers{}}}`, `{questions{answers{users{}}}}`, etc.

- Various queries/mutations
  - mutations
    - login with email and password; supports two permissions
      - normal user
      - admin user
    - create user account
      - only admin user can create new accounts
      - guests(no login user) or normal users are rejected
  - query
    - various queries includes total record counts

## How to try this?
- build docker compose
  - [How to build Docker Compose?](docs/docker.md)
- setup table and seed data
  - `mix deps.get && mix deps.compile`
  - `mix ecto.setup`
- access graphiql
  - `http://localhost:5001/graphiql`
- Enjoy!

## Schemas
<img src="docs/images/er.png" width="450px">

- Notice
  - users.plain_pasword: raw password(not hashed) on purpose
  - users.permission: 0 = normal user, 1 = admin user
  - all tables, user, question and answer, have `total_count` field as a virtual field. In case `totalCount` is specified, the count willl be stored in the field.

## GraphQL Schemas
- [GraphQL Schema](docs/schema/index.html)

## Queries and Mutations
- mutations
  - [login](docs/operations/mutation_login.md)
  - [create user](docs/operations/mutation_create_user.md)

- queries
  - [query question lists](docs/operations/query_questions.md)
  - [query question detail and answers](docs/operations/query_qanda.md)
  - [profile page](docs/operations/query_profile.md)
  - [other's profile page](docs/operations/query_others_profile.md)
