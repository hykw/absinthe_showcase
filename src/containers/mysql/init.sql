create database showcase_dev;
create database showcase_test;

grant all privileges on showcase_dev.* TO "mysqluser"@"%" identified by "PASSWORD";
grant all privileges on showcase_test.* TO "mysqluser"@"%" identified by "PASSWORD";

flush privileges;
