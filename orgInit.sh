sf demoutil org create scratch -f config/project-scratch-def.json -d 5 -s -p transaction -e security.demo -w 60
sfdx demoutil tsp update
sf project deploy start
sf org assign permset -n TransactionSecurity
sf demoutil user password set -p salesforce1 -g User -l User
sf automig load --inputdir ./data
sf apex run -f ./script/apex/createFile.apex
sf org open
