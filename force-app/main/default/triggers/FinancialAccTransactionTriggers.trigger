/**
 * @description       : 
 * @author            : Shubham Jaurat
 * @group             : 
 * @last modified on  : 10-24-2024
 * @last modified by  : Shubham Jaurat
**/
trigger FinancialAccTransactionTriggers on FinServ__FinancialAccountTransaction__c (after update, before insert , after insert) {

    if(trigger.isafter && trigger.isInsert)
    {
       FinancialAccTransactionTriggerController.updateLoanAccountOnFinancialAccTransaction(trigger.new );
    }
}