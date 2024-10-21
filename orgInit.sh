# Create the demo org
sfdx shane:org:create -f config/project-scratch-def.json -d 30 -s --wait 60 --userprefix transaction -o security.demo
#sfdx force:org:create -f config/project-scratch-def.json -a sfdc-security-demo

# Updates the Transaction Security Policies to contain this scratch orgs username
sfdx shane:tsp:username:update

# Push the metadata into the new scratch org.
sfdx force:source:push

# Assign user the permset
sfdx force:user:permset:assign -n TransactionSecurity

# Set the default password.
sf demoutil user password set -p salesforce1 -g User -l User


# Open the org.
sfdx force:org:open

# Import the data required by the demo
sfdx automig:load --inputdir ./data

sfdx force:apex:execute -f ./script/apex/createFile.apex
