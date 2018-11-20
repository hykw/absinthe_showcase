# Other's profile page

Query users' information and, questions and answers who wrote.

## Query/Mutations

```
{
  users(limit: 5, offset: 0) {
    totalCount
    id
    nickname
  }
}
```

```
{
  users(id: 6) {
    id
    nickname
    questions{
      id
      totalCount
    }
    answers {
      id
      totalCount
    }
  }
}
```

## Implementation notes

## Notes
- Unlike me, `Authorization` header is not required
