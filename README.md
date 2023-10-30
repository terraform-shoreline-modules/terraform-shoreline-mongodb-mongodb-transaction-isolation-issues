
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# MongoDB transaction isolation issues.
---

This incident type refers to an issue related to the transaction isolation level in MongoDB databases. Transaction isolation is an important property that ensures the consistency of data in the database. When there are isolation issues, it can lead to problems such as dirty reads, non-repeatable reads, and phantom reads. These issues can cause inconsistencies in the data and affect the overall performance and reliability of the system. Therefore, it is important to address MongoDB transaction isolation issues promptly and effectively.

### Parameters
```shell
export DATABASE_NAME="PLACEHOLDER"

export DESIRED_ISOLATION_LEVEL="PLACEHOLDER"
```

## Debug

### Check MongoDB database status
```shell
systemctl status mongod
```

### Check the MongoDB logs for any errors related to transaction isolation
```shell
grep "transaction" /var/log/mongodb/mongod.log
```

### Check the current MongoDB database lock status
```shell
mongo --eval "db.currentOp({'$all':true, 'waitingForLock':true})"
```

### Check the current MongoDB database connections
```shell
mongo --eval "db.currentOp()"
```

### Check the current MongoDB server status
```shell
mongo --eval "db.serverStatus()"
```

### Check the current MongoDB database index usage
```shell
mongo --eval "db.currentOp({'$all':true, 'indexBounds':true})"
```

### Check the current MongoDB database collections for any inconsistencies
```shell
mongo --eval "db.adminCommand({checkValidata:true})"
```

### Check the MongoDB database for any data corruption issues
```shell
mongo ${DATABASE_NAME} --eval "db.runCommand({repairDatabase: 1})"
```

### Check the MongoDB database for any slow queries
```shell
mongo ${DATABASE_NAME} --eval "db.currentOp({'secs_running': {$gte: 5}}).sort({'$natural': -1})"
```

### Check the MongoDB database for any locked queries
```shell
mongo ${DATABASE_NAME} --eval "db.currentOp({'lockStats.timeLockedMicros.r': {$gt: 0}}).pretty()"
```

## Repair

### Check the MongoDB isolation level configuration and ensure it is set to the appropriate level based on the application's requirements.
```shell


#!/bin/bash



# set the appropriate isolation level based on application requirements

isolation_level=${DESIRED_ISOLATION_LEVEL}



# update the MongoDB configuration file with the new isolation level

sed -i "s/transaction_isolation_level=.*/transaction_isolation_level=$isolation_level/g" /etc/mongod.conf



# restart the MongoDB service to apply the new configuration

systemctl restart mongod.service



echo "MongoDB isolation level has been updated to $isolation_level."


```