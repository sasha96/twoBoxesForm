/**
*  JIRA        :   https://silverline.jira.com/browse/DYNAMO-243
*  Class name  :   SL_ctrl_TwoBoxesForm
*  Created by  :   Alex Zhurylo
*  Created on  :   07/05/2019
*  Description :   Apex class for SL_TwoBoxesForm component
**/
public class SL_ctrl_TwoBoxesForm {
   
   @AuraEnabled
   public static String getPicklistValues(String objectApiName,String query){ 

        List<sObject> lstRecords = Database.query(query);

        List<RecordsWrapper> lstWrappers = new List<RecordsWrapper>();

        for (Integer i = 0; i < lstRecords.size(); i++) {
            lstWrappers.add(new RecordsWrapper((String)lstRecords[i].get('id'), (String)lstRecords[i].get('Name'), false));
        }
        return JSON.serialize(lstWrappers);
    }

    public class RecordsWrapper {
        public String Id {get;set;}
        public String Name {get;set;}
        public Boolean isSelected {get;set;}

        public RecordsWrapper(String id, String Name, Boolean isSelected) {
            this.id = id;
            this.Name = Name;
            this.isSelected = isSelected;
        }
    } 
}