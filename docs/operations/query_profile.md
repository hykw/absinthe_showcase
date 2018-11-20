# profile page

Query one's information and, questions and answers ever wrote.

## Query/Mutations
- `Authorization` header is required

```
{
  me {
    user {
      id
      nickname
      email
      permission
    }
    questions(limit: 1, offset: 1) {
      id
      totalCount
    }
     answers(limit: 10, offset: 2) {
      totalCount
      question {
        id
      }
    }
  }
}

```

## Implementation notes
- [qa_type.ex](https://github.com/hykw/absinthe_showcase/blob/master/src/lib/showcase_web/graphql/schema/qa_type.ex)
  - Same as [query question detail and answers](query_qanda.md), it extracts dataloder/1 and inject :total_count.

## Notes
