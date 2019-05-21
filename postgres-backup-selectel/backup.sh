#! /bin/sh

set -e
set -o pipefail

# Selectel settings
if [[ "${SELECTEL_USER}" = "**None**" ]]; then
  echo "You need to set the SELECTEL_USER environment variable."
  exit 1
fi

if [[ "${SELECTEL_PASSWORD}" = "**None**" ]]; then
  echo "You need to set the SELECTEL_PASSWORD environment variable."
  exit 1
fi

if [[ "${SELECTEL_CONTAINER_NAME}" = "**None**" ]]; then
  echo "You need to set the SELECTEL_CONTAINER_NAME environment variable."
  exit 1
fi

if [[ "${SELECTEL_USER_ID}" = "**None**" ]]; then
  echo "You need to set the SELECTEL_USER_ID environment variable."
  exit 1
fi

if [[ "${SELECTEL_DELETE_AFTER}" = "**None**" ]]; then
  echo "You need to set the SELECTEL_DELETE_AFTER environment variable."
  exit 1
fi

if [[ "${POSTGRES_DATABASE}" = "**None**" ]]; then
  echo "You need to set the POSTGRES_DATABASE environment variable."
  exit 1
fi

if [[ "${POSTGRES_HOST}" = "**None**" ]]; then
  if [[ -n "${POSTGRES_PORT_5432_TCP_ADDR}" ]]; then
    POSTGRES_HOST=$POSTGRES_PORT_5432_TCP_ADDR
    POSTGRES_PORT=$POSTGRES_PORT_5432_TCP_PORT
  else
    echo "You need to set the POSTGRES_HOST environment variable."
    exit 1
  fi
fi

if [[ "${POSTGRES_USER}" = "**None**" ]]; then
  echo "You need to set the POSTGRES_USER environment variable."
  exit 1
fi

if [[ "${POSTGRES_PASSWORD}" = "**None**" ]]; then
  echo "You need to set the POSTGRES_PASSWORD environment variable or link to a container named POSTGRES."
  exit 1
fi

# env vars needed for aws tools
export PGPASSWORD=$POSTGRES_PASSWORD
export FILE_NAME="${POSTGRES_DATABASE}_$(date +"%Y-%m-%dT%H:%M:%SZ").sql.gz"

POSTGRES_HOST_OPTS="-h $POSTGRES_HOST -p $POSTGRES_PORT -U $POSTGRES_USER $POSTGRES_EXTRA_OPTS"

echo "Creating dump of ${POSTGRES_DATABASE} database from ${POSTGRES_HOST}..."

pg_dump $POSTGRES_HOST_OPTS $POSTGRES_DATABASE | gzip > dump.sql.gz

export SELECTEL_FILE_UPLOAD_URL="https://api.selcdn.ru/v1/SEL_$SELECTEL_USER_ID/$SELECTEL_CONTAINER_NAME/"

echo "Obtain selectel access token"

# get selectel access token
export SELECTEL_ACCESS_TOKEN=$(
    curl -i https://api.selcdn.ru/auth/v1.0 \
        -H "X-Auth-User: $SELECTEL_USER" \
        -H "X-Auth-Key: $SELECTEL_PASSWORD" \
    | grep -i 'x-auth-token:' | awk -F ': ' '{ print $2 }'
)

echo "Selectel access token is - $SELECTEL_ACCESS_TOKEN"
echo "Uploading dump to $SELECTEL_CONTAINER_NAME (${SELECTEL_FILE_UPLOAD_URL})"

# upload to selectel
echo -e "Upload command is:\ncurl -i -XPUT \"${SELECTEL_FILE_UPLOAD_URL}\"\n -H \"X-Auth-Token: $SELECTEL_ACCESS_TOKEN\"\n -H \"X-Delete-After: $SELECTEL_DELETE_AFTER\"\n -T $FILE_NAME"
curl -i -XPUT $SELECTEL_FILE_UPLOAD_URL -H "X-Auth-Token: $SELECTEL_ACCESS_TOKEN" -H "X-Delete-After: $SELECTEL_DELETE_AFTER" -T run.sh

echo "SQL backup uploaded successfully"
