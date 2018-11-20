# login

Login with email and password. `create_user` mutation or `me` query requires the token returned here.

## Query/Mutations

```
mutation {
  login(email: "user1@example.jp", password: "password1", permission: NORMAL_USER) {
    token
}
```

```
mutation {
  login(email: "admin1@example.jp", password: "password3", permission: ADMIN) {
    token
    user {
      id
      nickname
      email
    }
  }
}
```

## Implementation notes

- [authentication.ex](https://github.com/hykw/absinthe_showcase/blob/master/src/lib/showcase_web/graphql/authentication.ex)
  - just call to [Phoenix.Token](https://hexdocs.pm/phoenix/Phoenix.Token.html)

## Notes

As you can see, `password` is stored as is(not hashed). I've left it to you to implement some hashing logic on purpose. That's the reason why the field name is `plain_password` not `password`.

