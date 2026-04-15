#!/bin/bash

check() {
   if [[ $? != 0 ]]; then
      echo "Error! Stopping the script."
      exit 1
   fi
}

configure() {
  if [[ $# -gt 0 ]]; then
    echo "run agent.sh configure $@"
    ${AGENT_DIST}/bin/agent.sh configure "$@"; check
  fi
}

reconfigure() {
    declare -a opts
    [[ -n "${SERVER_URL}" ]]  && opts[${#opts[@]}]='--server-url' && opts[${#opts[@]}]="$SERVER_URL"
    if [[ 0 -ne "${#opts[@]}" ]]; then
      # Using sed to strip double quotes produced by docker-compose
      for i in $(seq 0 $(expr ${#opts[@]} - 1)); do
        opts[$i]="$(echo "${opts[$i]}" | sed -e 's/""/"/g')"
      done
      configure "${opts[@]}"
      echo "File buildAgent.properties was updated"
    fi
    for AGENT_OPT in ${AGENT_OPTS}; do
      echo ${AGENT_OPT} >>  ${CONFIG_DIR}/buildAgent.properties
    done
}

prepare_conf() {
    echo "Will prepare agent config" ;
    cp -p ${AGENT_DIST}/conf/*.* ${CONFIG_DIR}/; check
    cp -p ${CONFIG_DIR}/buildAgent.dist.properties ${CONFIG_DIR}/buildAgent.properties; check
    reconfigure
    echo "File buildAgent.properties was created and updated" ;
}

rm -f ${LOG_DIR}/*.pid

export CONFIG_FILE=${CONFIG_DIR}/buildAgent.properties
if [ -f ${CONFIG_FILE} ] ; then
   echo "File buildAgent.properties was found in ${CONFIG_DIR}. Will start the agent using it." ;
else
   echo "Will create new buildAgent.properties using distributive" ;
   if [[ -n "${SERVER_URL}" ]]; then
      echo "TeamCity URL is provided: ${SERVER_URL}"
   else
      echo "TeamCity URL is not provided, but is required."
      exit 1
   fi
   prepare_conf
fi

${AGENT_DIST}/bin/agent.sh start

while [ ! -f ${LOG_DIR}/teamcity-agent.log ];
do
   echo -n "."
   sleep 1
done

trap '${AGENT_DIST}/bin/agent.sh stop force; while ps -p $(cat $(ls -1 ${LOG_DIR}/*.pid)) &>/dev/null; do sleep 1; done; kill %%' SIGINT SIGTERM SIGHUP

tail -qF ${LOG_DIR}/teamcity-agent.log &
wait
