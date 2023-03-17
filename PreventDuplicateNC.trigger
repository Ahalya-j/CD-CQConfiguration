trigger PreventDuplicateNC on SQX_Nonconformance__c (before insert,before update) {

   list<string> acc = new list<string>();
    for(SQX_Nonconformance__c a:Trigger.new)
    {
        acc.add(a.name);
    }
    list<SQX_Nonconformance__c> listOfDuplicate = [select id, Name from SQX_Nonconformance__c where Name in :acc];
    for(SQX_Nonconformance__c nc:trigger.new)
    {
        if(trigger.isInsert){
            if(listOfDuplicate.size()!=0)
            {
                nc.addError('Nonconformance already exists with this name');
            }
        }
       if(trigger.isUpdate)
        {
            for(SQX_Nonconformance__c oldnc :trigger.old)
            {
                if(nc.Name==oldnc.Name && listOfDuplicate.size()!=0)
                {
                    nc.addError('Nonconformance already exists with this name');
                }
            }
        }
    } 
}
