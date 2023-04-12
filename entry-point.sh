#!/bin/bash

handler() {
  echo "Executing handler"

  if [ -z ${sleepPID} ]
  then
    echo "No sleep PID found, exiting"
    exit 0
  fi

  pidCmd=$(ps -cho cmd ${sleepPID})
  if [ $? -ne 0 ]
  then
    echo "Sleep pid '${sleepPID}  no longer running"
    exit 0
  fi

  echo "PID '${sleepPID}' is running cmd '${pidCmd}'"
  if [ "${pidCmd}" = "sleep" ]
  then
    echo "Killing sleep PID: ${sleepPID}"
    kill ${sleepPID}
    exit 0
   else
     echo "PID '${sleepPID}' is running but is not running 'sleep'"
     exit 0
   fi
}

echo -n "Registering traps..."
trap handler INT HUP ABRT TERM
echo "Done!"

 
echo "Starting loop..."
# This script simply runs forever, without this, the container just immediately exits
#while [ ${loopContinue} == true ]
while :
do
  # Send a very long sleep into the background (sleep can't be broken out of with a signal)
  echo "Running sleep in the background"
  sleep 365d &
  sleepPID=$!
  echo "Sleep running as PID: ${sleepPID}"
  echo "Waiting on ${sleepPID}"
  # Make sure the script stops here, otherwise the container will exit
  wait ${sleepPID}
done
