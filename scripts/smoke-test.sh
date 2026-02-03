#!/bin/bash
set -eux
URL=${1:-http://localhost:8080/api/hello}
timeout 5 bash -c "until curl -fsS $URL >/dev/null; do sleep 1; done"
curl -fsS $URL
