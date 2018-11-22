# query question lists

Query question lists with the author(user) info such as id, nickname

## Query/Mutations

```
{
  questions(limit: 5, offset: 0) {
    totalCount
    id
    title
    user {
      id
      nickname
    }
  }
}
```

## Implementation notes
- Context's [qa.ex](https://github.com/hykw/absinthe_showcase/blob/master/src/lib/showcase/qa/qa.ex)
  - In case `totalCount` is specified, two queries will be issued; a query which excludes `:limit` and `:offset`, and the original query(This is very useful in paginations).

## Notes
