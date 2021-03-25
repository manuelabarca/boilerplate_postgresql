[![Open in GitPod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/manuelabarca/boilerplate_postgresql)

PostgreSQL
To get PostgreSQL for your project, you can use our dedicated PostgreSQL image built on top of gitpod/workspace-full.

Simply base your .gitpod.dockerfile on:

FROM gitpod/workspace-postgres

This will give you an auto-starting PostgreSQL server (it should auto-start every time you open a new Terminal), plus a few utility scripts that you can run in a Terminal or in a .gitpod.yml command:

pg_start: start the PostgreSQL service
pg_stop: stop the PostgreSQL service
pg_ctl status: check if the PostgreSQL service is running
Once the PostgreSQL server is running, you can use the psql CLI as usual:

$ psql -h localhost -d postgres
psql (10.8 (Ubuntu 10.8-0ubuntu0.18.10.1))
Type "help" for help.

postgres=#