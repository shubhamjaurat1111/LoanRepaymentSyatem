/**
 * @description       : 
 * @author            : Shubham Jaurat
 * @group             : 
 * @last modified on  : 10-24-2024
 * @last modified by  : Shubham Jaurat
**/
public with sharing class FinancialAccTransactionTriggerController {
    
    public static void updateLoanAccountOnFinancialAccTransaction(List<FinServ__FinancialAccountTransaction__c> transactionList)
    {
        Map<Id, FinServ__FinancialAccountTransaction__c> MapWithKeyAsFinantialaccountId = new Map<Id, FinServ__FinancialAccountTransaction__c>();
        Map<Id, Datetime> DateMap = new Map<Id, Datetime>();
        List<ID> FinancialAccountIDs = new List<ID>();

        for( FinServ__FinancialAccountTransaction__c trans : transactionList )
        {
            if(trans.FinServ__FinancialAccount__c != null)
            {
                FinancialAccountIDs.add(trans.FinServ__FinancialAccount__c);

                Datetime transactionDate = trans.FinServ__TransactionDate__c;
                if (DateMap.containsKey(trans.FinServ__FinancialAccount__c))
                {
                    // Update only if the current trans date is more recent
                    if (transactionDate > DateMap.get(trans.FinServ__FinancialAccount__c))
                    {
                        DateMap.put(trans.FinServ__FinancialAccount__c, transactionDate);
                    }
                }
                else
                {
                    DateMap.put(trans.FinServ__FinancialAccount__c, transactionDate);
                }
            }
        }
        
      // List to hold FinServ__FinancialAccount__c records that need to be updated
        List<FinServ__FinancialAccount__c> accountsToUpdate = new List<FinServ__FinancialAccount__c>();
        accountsToUpdate  =[SELECT Id,FinServ__LastTransactionDate__c
                            FROM FinServ__FinancialAccount__c
                            WHERE Id IN : DateMap.keySet()];
        
        for( FinServ__FinancialAccount__c acc : accountsToUpdate )
        {
            if(DateMap.get(acc.Id)!= null)
            {
              acc.FinServ__LastTransactionDate__c = DateMap.get(acc.Id);
            } 
        }

        if (!accountsToUpdate.isEmpty()) 
        {
            update accountsToUpdate;
        }

    }

    

}