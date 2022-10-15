#!/usr/bin/env bash
###
# File: entrypoint.sh
# Project: overlay
# File Created: Sunday, 9th October 2022 1:35:46 am
# Author: Josh.5 (jsunnex@gmail.com)
# -----
# Last Modified: Sunday, 16th October 2022 10:14:40 am
# Modified By: Josh.5 (jsunnex@gmail.com)
###

# Source functions from GOW utils
source /opt/gow/bash-lib/utils.sh

# Execute all container init scripts. Only run this if the container is started as the root user
if [ "$(id -u)" = "0" ]; then
    for init_script in /etc/cont-init.d/*.sh ; do
        gow_log
        gow_log "[ ${init_script}: executing... ]"
        sed -i 's/\r$//' "${init_script}"
        source "${init_script}"
    done
fi

# If a command was passed, run that instead of the usual init startup script
if [ ! -z "$@" ]; then
    exec $@
    exit $?
fi

# Print the current version (if the file exists)
if [[ -f /version.txt ]]; then
    cat /version.txt
fi

# Launch startup script as 'UNAME' user (some services will run as root)
gow_log "Launching the container's startup script as user '${UNAME}'"
chmod +x /opt/gow/startup.sh
exec gosu "${UNAME}" /opt/gow/startup.sh
