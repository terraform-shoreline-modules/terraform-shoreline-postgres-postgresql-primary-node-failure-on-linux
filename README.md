
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Primary PostgreSQL Node Failure on Linux
---

This incident type refers to a failure in the primary PostgreSQL node on a Linux system. PostgreSQL is a popular open source relational database management system used by many organizations. The primary node is responsible for handling the majority of the traffic and data replication in a PostgreSQL cluster. When the primary node fails, it can result in data loss, slow performance, and potential downtime for users. This type of incident requires immediate attention and resolution to minimize the impact on users and ensure data integrity.

### Parameters
```shell
export VERSION="PLACEHOLDER"

export PRIMARY_NODE="PLACEHOLDER"

export STANDBY_NODE="PLACEHOLDER"
```

## Debug

### Check PostgreSQL service status
```shell
systemctl status postgresql
```

### Check PostgreSQL logs for any errors
```shell
tail -f /var/log/postgresql/postgresql-${VERSION}-main.log
```

### Check PostgreSQL configuration file for any misconfigurations
```shell
cat /etc/postgresql/${VERSION}/main/postgresql.conf
```

### Check disk space and resource utilization
```shell
df -h

top
```

## Repair

### Restart the failed PostgreSQL node service to bring it back online.
```shell


#!/bin/bash



# Stop PostgreSQL service

sudo systemctl stop postgresql.service



# Start PostgreSQL service

sudo systemctl start postgresql.service



# Check if PostgreSQL service is running

if sudo systemctl is-active --quiet postgresql.service; then

  echo "PostgreSQL service successfully restarted."

else

  echo "Failed to restart PostgreSQL service."

fi


```

### If restarting the service doesn't work, try to failover to a standby node in the PostgreSQL cluster.
```shell
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


```