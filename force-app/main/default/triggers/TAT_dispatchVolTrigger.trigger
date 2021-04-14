/**
  * @author         Salesforce TAT Team
  * @date           12 28, 2018
  * @description    Dispatch vol trigger
  * @history       
  *
  **/

trigger TAT_dispatchVolTrigger on Dispatch_Vol__c (before insert,
        before update,
        before delete,
        after insert,
        after update,
        after delete,
        after undelete) {
    new TAT_DispatchVolTriggerHandler().run();
}