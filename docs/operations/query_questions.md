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
  - [TinyEctoHelperMySQL](https://hex.pm/packages/tiny_ecto_helper_mysql) are called in case `totalCount` is specified to get the TRUE total record counts.
  - This is very useful in paginations. For example, say there are 10 records(id:1 to id:10) in a table. `SELECT COUNT(*) FROM WHERE id > 5 LIMIT 3` only returns `3` because of `LIMIT 3`, but the required value is the number of remaining records, i.e. `5`.

## Notes
