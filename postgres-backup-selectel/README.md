# postgres-backup-selectel

Backup PostgresSQL to Selectel Cloud Storage (supports periodic backups)

## Usage

Docker:
```sh
$ docker run -e SELECTEL_USER=user_name -e SELECTEL_PASSWORD=passwd -e SELECTEL_CONTAINER_NAME=container -e SELECTEL_DELETE_AFTER=86400 -e POSTGRES_DATABASE=dbname -e POSTGRES_USER=user -e POSTGRES_PASSWORD=password -e POSTGRES_HOST=localhost dodone/postgres-backup-selectel
```

Docker Compose:
```yaml
postgres:
  image: postgres
  environment:
    POSTGRES_USER: user
    POSTGRES_PASSWORD: password

pgbackups3:
  image: dodone/postgres-backup-selectel
  links:
    - postgres
  environment:
    SCHEDULE: '@daily'
    SELECTEL_USER: user_name
    SELECTEL_PASSWORD: password
    SELECTEL_CONTAINER_NAME: conatainer_name
    SELECTEL_DELETE_AFTER: 86400  # 60 * 60 * 24 = 1d (in seconds)
    POSTGRES_DATABASE: dbname
    POSTGRES_USER: user
    POSTGRES_PASSWORD: password
    POSTGRES_EXTRA_OPTS: '--schema=public --blobs'
```

### Automatic Periodic Backups

You can additionally set the `SCHEDULE` environment variable like `-e SCHEDULE="@daily"` to run the backup automatically.

More information about the scheduling can be found [here](http://godoc.org/github.com/robfig/cron#hdr-Predefined_schedules).
