#

# update user

Update user info. This mutation requires `Authorization` header.

## Query/Mutations

```
mutation {
  updateUser(nickname: "updated_nick", email: "updateduser@example.jp") {
    id
    nickname
    email
  }
}
```

## Implementation notes

## Notes
