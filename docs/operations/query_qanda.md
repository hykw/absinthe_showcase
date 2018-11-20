# query question detail and answers

Query question detail data and answers

## Query/Mutations

```
{
  questions(id: 1) {
    id
    title
    body
    user {
      id
      nickname
    }
    answers(limit: 3, offset: 0) {
      totalCount
      id
      body
    }
  }
}
```


## Implementation notes
- [qa_type.ex](https://github.com/hykw/absinthe_showcase/blob/master/src/lib/showcase_web/graphql/schema/qa_type.ex)
  - In order to avoid N+1 problem, the user record associated with each questions is load through dataloader/1
- Context's [qa.ex](https://github.com/hykw/absinthe_showcase/blob/master/src/lib/showcase/qa/qa.ex)
  - Unlike `user`, answers associated with the question are not only load through dataloader/1 but also to be injected `:total_count`. The implementation of dataloader/1 are extracted in the context(in answers_for_question) and :total_count is set in Dataloader.get/4



## Notes
