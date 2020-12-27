#!/bin/bash
# startup.sh

mv "/opt/jboss/wildfly/standalone/$DEPLOYMENT" /opt/jboss/wildfly/standalone/deployments/

if [ "$MULTICONT" = "yes" ]
then
  until cat /home/test/test.txt | grep 1; do
    >&2 echo "MySQL is unavailable - sleeping 2s"
    sleep 2
  done
fi

/opt/jboss/wildfly/bin/standalone.sh -b 0.0.0.0 -bmanagement 0.0.0.0