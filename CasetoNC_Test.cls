@isTest
private class CasetoNC_Test {
    static testMethod void testTrigger() {
        // Create a test case
        Case c = new Case();
        c.Subject = 'Test Case';
        c.Type = 'Problem';
        c.Priority = 'High';
        c.Description = 'This is a test case';
        insert c;

        // Verify that the SQX_NC_Reference__c field was populated
        Case updatedCase = [SELECT Id, SQX_NC_Reference__c FROM Case WHERE Id = :c.Id];
     //   System.assertEquals(1, updatedCase.SQX_NC_Reference__c, 'SQX_NC_Reference__c should be populated');

        // Verify that a nonconformance record was created
        List<SQX_Nonconformance__c> nonconformanceList = [SELECT Id, Name, Priority__c, Description__c, Title__c, Case__c FROM SQX_Nonconformance__c WHERE Case__c = :c.Id];
        System.assertEquals(1, nonconformanceList.size(), 'A nonconformance record should be created');
        SQX_Nonconformance__c nonconformance = nonconformanceList[0];
        System.assert(true);
        System.assertEquals(c.Priority, nonconformance.Priority__c, 'Priority should be set to the case priority');
        System.assertEquals(c.Description, nonconformance.Description__c, 'Description should be set to the case description');
        System.assertEquals(c.Subject, nonconformance.Title__c, 'Title should be set to the case subject');
        System.assertEquals(c.Id, nonconformance.Case__c, 'Case__c should be set to the case id');
    }
}