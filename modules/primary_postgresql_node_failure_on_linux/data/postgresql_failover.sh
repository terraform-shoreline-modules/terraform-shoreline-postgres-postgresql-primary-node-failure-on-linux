bash

#!/bin/bash



# Set variables

PRIMARY_NODE=${PRIMARY_NODE}

STANDBY_NODE=${STANDBY_NODE}



# Restart the PostgreSQL service on the primary node

sudo systemctl restart postgresql



# Check if the service is running

if ! systemctl is-active --quiet postgresql; then

    # If the service is not running, failover to the standby node

    sudo -u postgres pg_ctl promote -D $STANDBY_NODE

fi