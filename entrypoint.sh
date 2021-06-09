#!/usr/bin/env bash

set -e

HALYARD_DAEMON_PID_FILE=/opt/halyard/pid
HALYARD_DAEMON_PID=""
HALYARD_STARTUP_TIMEOUT_SECONDS=${HALYARD_STARTUP_TIMEOUT_SECONDS-"120"}

HAL=/opt/halyard/bin/hal

exit_trap() {
    echo -e "Halyard is closing"
    PGID=$(ps -o pgid= $$ | tr -d \ )
    kill -TERM -$PGID 2>/dev/null

    echo "Server is closed"
    exit 0
}
trap exit_trap INT EXIT

echo "Starting the halyard"

/opt/halyard/bin/halyard "$@" &
HALYARD_DAEMON_PID=$!
echo $HALYARD_DAEMON_PID >$HALYARD_DAEMON_PID_FILE

wait_start=$(date +%s)

set +e
$HAL --ready &>/dev/null
while [ "$?" != "0" ]; do
    wait_now=$(date +%s)
    wait_time=$(($wait_now - $wait_start))
    if [ "$wait_time" -gt "$HALYARD_STARTUP_TIMEOUT_SECONDS" ]; then
        echo >&2 ""
        echo >&2 "Waiting for halyard to start timed out after $wait_time seconds"
        exit 1
    fi
    sleep 2
    $HAL --ready &>/dev/null
done
set -e

echo "Halyard started"

wait $HALYARD_DAEMON_PID
if [ $? -eq 1 ]; then
    echo "Halyard shutdown is not done in gracefully"
    exit 1
fi
