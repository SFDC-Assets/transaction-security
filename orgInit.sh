# Create the demo org
sf demoutil org create scratch -f config/project-scratch-def.json -d 5 -s -p transaction -e security.demo -w 60

#sfdx force:org:create -f config/project-scratch-def.json -a sfdc-security-demo

# Updates the Transaction Security Policies to contain this scratch orgs username
sfdx shane:tsp:username:update

# Push the metadata into the new scratch org.
sf project deploy start

# Assign user the permset
sf org assign permset -n TransactionSecurity

# Set the default password.
sf demoutil user password set -p salesforce1 -g User -l User


# Open the org.
sf org open

# Import the data required by the demo
sfdx automig:load --inputdir ./data

sfdx force:apex:execute -f ./script/apex/createFile.apex
