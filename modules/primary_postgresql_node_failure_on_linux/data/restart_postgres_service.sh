

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