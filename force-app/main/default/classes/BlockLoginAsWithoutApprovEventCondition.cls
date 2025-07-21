global class BlockLoginAsWithoutApprovEventCondition implements TxnSecurity.EventCondition {
global Boolean evaluate(SObject event) {
// Cast the event to LoginAsEvent
LoginAsEvent loginEvent = (LoginAsEvent) event;

// Extract the necessary fields from the LoginAsEvent
String actorUsername = loginEvent.DelegatedUsername; // Username of the admin
String targetUserId = loginEvent.UserId; // ID of the user being logged in as

// Add null checks and debug logs
if (actorUsername == null) {
System.debug('Actor Username is null');
}
if (targetUserId == null) {
System.debug('Target User ID is null');
}

// Query to check if there is a valid approval
List<LoginAsRequest__c> approvals = [
SELECT Id, Is_Valid__c, Approved_Until__c
FROM LoginAsRequest__c
WHERE Approver_User__r.Username = :actorUsername
AND Target_User__c = :targetUserId
LIMIT 1
];

// Add debug logs
System.debug('Approvals: ' + approvals);
if (!approvals.isEmpty()) {
System.debug('Is_Valid__c: ' + approvals[0].Is_Valid__c);
System.debug('Approved_Until__c: ' + approvals[0].Approved_Until__c);
}

// Custom logging for EvaluationTime, RelatedEventIdentifier, PolicyOutcome, and PolicyId
System.debug('EvaluationTime: ' + System.now());
System.debug('RelatedEventIdentifier: ' + loginEvent.EventIdentifier);
System.debug('PolicyOutcome: ' + (approvals.isEmpty() ? 'Blocked' : 'Allowed'));
System.debug('PolicyId: ' + 'YourPolicyIdHere'); // Replace with actual Policy ID if available

// Check if the approval exists, if Is_Valid__c is true, and if Approved_Until__c is in the future
if (!approvals.isEmpty() && approvals[0].Is_Valid__c && approvals[0].Approved_Until__c > System.now()) {
System.debug('LoginAsRequest is valid and approved.');
return false; // Do not block
}

System.debug('LoginAsRequest is not valid or not approved.');
return true; // Block
}
}