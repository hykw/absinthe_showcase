# absinthe_showcase
a showcase for Absinthe

## How to build Docker Compose?

```
MYUID=${UID} docker-compose up -d --build
```

- showcase: Phoenix
- showcase_mysql: MySQL

### ports and volumes
- ports
  - 5002 -> MySQL:3306
  - 5001 -> Phoenix:4000

- volumes(at host -> in docker)
  - showcase/src -> /showcase/src

See [docker-compose.yml](src/docker-compose.yml) in detail.
