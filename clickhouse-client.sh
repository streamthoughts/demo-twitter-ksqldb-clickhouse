#!/bin/bash

set -e

docker exec -it clickhouse bin/bash -c "clickhouse-client --multiline"
