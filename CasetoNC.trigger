trigger CasetoNC on Case (after insert, after update) {
    
   //Boolean hasPermission = FeatureManagement.checkPermission('Case_Admin');
if (PermissionHelper.hasCaseAdminPermission()) {


system.debug('hasCaseAdminPermission'+ PermissionHelper.hasCaseAdminPermission());
    
    List<SQX_Nonconformance__c> nonconformanceList = new List<SQX_Nonconformance__c>();
    List<Case> casetoUpdate = new List<Case>();
    Set<Id> caseIds = new Set<Id>();
  
  //  Integer count = [SELECT COUNT() FROM Case];
   // Integer count = 0;
   
     AggregateResult[] results = [
        SELECT Count(Id) cnt, Type
        FROM Case
        WHERE Type = 'Problem'
        GROUP BY Type
    ];

    Integer count = (Integer) results[0].get('cnt');
    for (Case c : Trigger.new) {
        if (c.Type == 'Problem') {
            caseIds.add(c.Id);
           count++;
        }
    }
    
    Map<Id, SQX_Nonconformance__c> existingNonconformanceMap = new Map<Id, SQX_Nonconformance__c>([
        SELECT Id, Case__c, QMS_Reference_Number__c
        FROM SQX_Nonconformance__c
        WHERE Case__c IN :caseIds
    ]);
    
    for (Case c : Trigger.new) {
        if (c.Type == 'Problem' && !existingNonconformanceMap.containsKey(c.Id) || existingNonconformanceMap.get(c.Id) == null) {
            SQX_Nonconformance__c nonconformance = new SQX_Nonconformance__c();
            nonconformance.Name = c.CaseNumber;
            nonconformance.Priority__c = c.Priority;
            nonconformance.Description__c = c.Description;
            nonconformance.Title__c = c.Subject;
            nonconformance.QMS_Reference_Number__c +=count;
            nonconformance.Case__c = c.Id;
            nonconformanceList.add(nonconformance);
        }
    }
    
    if (!nonconformanceList.isEmpty()) {
        insert nonconformanceList;
    }
    
    List<Case> caseList = [SELECT Id, SQX_NC_Reference__c FROM Case WHERE Id IN :caseIds];
    
    for (Case c : caseList) {
        for (SQX_Nonconformance__c nc : nonconformanceList) {
            if (nc != null) {
                c.SQX_NC_Reference__c = nc.Id;
                casetoUpdate.add(c);
            }
        }
    }
    
    if (!casetoUpdate.isEmpty()) {
        update casetoUpdate;
    } 
}
}
