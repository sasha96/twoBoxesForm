/**
*  JIRA        :   https://silverline.jira.com/browse/DYNAMO-243
*  Class name  :   SL_ctrl_TwoBoxesForm
*  Created by  :   Alex Zhurylo
*  Created on  :   07/05/2019
*  Description :   Apex class for SL_TwoBoxesForm component
**/
public class SL_ctrl_TwoBoxesForm {
   
   @AuraEnabled
   public static String getPicklistValues(String objectApiName,String query, String listOfRecords){ 

        List<sObject> lstRecords = Database.query(query);

        List<RecordsWrapper> lstWrappers = new List<RecordsWrapper>();

        for (Integer i = 0; i < lstRecords.size(); i++) {
            lstWrappers.add(new RecordsWrapper((String)lstRecords[i].get('id'), (String)lstRecords[i].get('Name'), false));
        }
        
        List<RecordsWrapper> lstWrappersRight = null;
        if(listOfRecords != null || listOfRecords != ''){
            
            List<String> lstResult = new List<String>();
            Boolean isTrue = true;
            while(isTrue && listOfRecords != null){
                if (listOfRecords.contains(',') == true){
                    lstResult.add(listOfRecords.substring(0, listOfRecords.substringBefore(',').length()));
                    listOfRecords = listOfRecords.substring(listOfRecords.substringBefore(',').length() + 1);
                } else{
                    lstResult.add(listOfRecords);
                    isTrue = false;
                }                
            }
            
            String queryRight = 'SELECT id, Name FROM ' + objectApiName + ' WHERE id IN :  lstResult ';

            List<sObject> lstRecordsRight = Database.query(queryRight);
            
            lstWrappersRight = new List<RecordsWrapper>();
        
            for (Integer i = 0; i < lstRecordsRight.size(); i++) {
                lstWrappersRight.add(new RecordsWrapper((String)lstRecordsRight[i].get('id'), (String)lstRecordsRight[i].get('Name'), false));
            }
        }
        List<List<RecordsWrapper>> wrapper = new List<List<RecordsWrapper>>();
        wrapper.add(lstWrappers);
        wrapper.add(lstWrappersRight);

        return JSON.serialize(wrapper);
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