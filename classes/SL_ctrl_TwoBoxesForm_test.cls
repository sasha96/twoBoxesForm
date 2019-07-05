/**
*  JIRA        :   https://silverline.jira.com/browse/DYNAMO-243
*  Class name  :   SL_ctrl_TwoBoxesForm_test
*  Created by  :   Alex Zhurylo
*  Created on  :   07/05/2019
*  Description :   Apex test for SL_ctrl_TwoBoxesForm
**/
@isTest
public class SL_ctrl_TwoBoxesForm_test {
    
    @isTest
    public static void getPicklistValues_test(){
        
        Test.startTest();
        Profile p = [SELECT id FROM Profile WHERE name = 'System Administrator'];
        User usr = new User();
            usr.alias = 'utest';
            usr.email='Unit.Test@unittest.com';
            usr.emailencodingkey='UTF-8'; 
            usr.firstName='First29'; 
            usr.lastname='Last';
            usr.languagelocalekey='en_US';
            usr.localesidkey='en_US'; 
            usr.profileid = p.id;
            usr.timezonesidkey='Europe/London';
            usr.username='test29t@ukr.com';
        insert usr;

        String listOfRecords = usr.id + ',' + usr.id;
        String query = 'SELECT id, name FROM User WHERE username = \'test29t@ukr.com\'';
        String returnedResult = SL_ctrl_TwoBoxesForm.getPicklistValues('User', query, listOfRecords);

        List<sObject> lstRecords = Database.query(query);
        List<SL_ctrl_TwoBoxesForm.RecordsWrapper> lstWrappers = new List<SL_ctrl_TwoBoxesForm.RecordsWrapper>();

        for (Integer i = 0; i < lstRecords.size(); i++) {
            lstWrappers.add(new SL_ctrl_TwoBoxesForm.RecordsWrapper((String)lstRecords[i].get('id'), (String)lstRecords[i].get('Name'), false));
        }

        List<SL_ctrl_TwoBoxesForm.RecordsWrapper> lstWrappersRight = null;
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
            
            String queryRight = 'SELECT id, Name FROM User WHERE id IN :  lstResult ';

            List<sObject> lstRecordsRight = Database.query(queryRight);
            
            lstWrappersRight = new List<SL_ctrl_TwoBoxesForm.RecordsWrapper>();
        
            for (Integer i = 0; i < lstRecordsRight.size(); i++) {
                lstWrappersRight.add(new SL_ctrl_TwoBoxesForm.RecordsWrapper((String)lstRecordsRight[i].get('id'), (String)lstRecordsRight[i].get('Name'), false));
            }
        }
        List<List<SL_ctrl_TwoBoxesForm.RecordsWrapper>> wrapper = new List<List<SL_ctrl_TwoBoxesForm.RecordsWrapper>>();
        wrapper.add(lstWrappers);
        wrapper.add(lstWrappersRight);


        String expectedResult = JSON.serialize(wrapper);

        System.assertEquals(expectedResult, returnedResult);

        Test.stopTest();
    }
}