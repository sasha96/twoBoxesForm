({
    /*
        call when initialize component;
    */
    doInit: function (component, event, helper) {

        var action = component.get("c.getPicklistValues");

        var strRecords = component.get('v.selectedItems');
        strRecords = strRecords.replace(/;/gi, ',');
        strRecords = strRecords.substring(0, strRecords.length);

        action.setParams({
            objectApiName: component.get("v.objectName"),
            query: component.get('v.query'),
            listOfRecords: strRecords
        });

        action.setCallback(this, function (response) {

            var state = response.getState();
            if (state === "SUCCESS") {

                var result = response.getReturnValue();
                var returnedData = JSON.parse(result);

                var rightList = returnedData[1];
                component.set('v.rightItems', rightList);


                var mainResult = returnedData[0];
                var temporary = [];

                for (var item in mainResult) {

                    var isAdd = true;
                    for (var inner in rightList) {

                        if (rightList[inner].Id === mainResult[item].Id) {
                            isAdd = false;
                        }

                    }
                    if (isAdd) {
                        temporary.push(mainResult[item]);
                    }

                }

                component.set("v.baseListItems", temporary);
                component.set("v.items", temporary);
            }
            else {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: 'Error',
                    message: 'The error happened when you tried to load Two Box Form\'s list of elements',
                    duration: ' 3000',
                    type: 'error',
                    mode: 'dismissible'
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },

    /*
        call when click in element from list;
    */
    handleListClick: function (component, event, helper) {

        var id = event.currentTarget.id;

        var leftSide = component.get("v.items");
        var rightSide = component.get("v.rightItems");

        for (var item in leftSide) {
            leftSide[item].isSelected = false;
            if (leftSide[item].Id === id) {
                leftSide[item].isSelected = true;
            }
        }

        for (item in rightSide) {
            rightSide[item].isSelected = false;
            if (rightSide[item].Id === id) {
                rightSide[item].isSelected = true;
            }
        }

        component.set("v.items", leftSide);
        component.set("v.rightItems", rightSide);
        component.set("v.idSelectedElement", id);
    },

    /*
        call when click right button;
    */
    moveLeftToRight: function (component, event, helper) {

        var idSelectedElement = component.get("v.idSelectedElement");
        var leftSide = component.get("v.items");
        var rightSide = component.get("v.rightItems");

        var isAlreadyInRigth = false;

        for (var item in rightSide) {
            if (rightSide[item].Id === idSelectedElement) {
                isAlreadyInRigth = true;
            }
        }

        if (!isAlreadyInRigth) {
            var temp;
            for (var item in leftSide) {
                if (leftSide[item].Id === idSelectedElement) {

                    rightSide.push(leftSide[item]);

                    temp = leftSide.filter(function (elem) {
                        return elem.Id !== idSelectedElement;
                    });

                }
            }

            component.set("v.items", temp === undefined ? [] : helper.sortByName(temp));
            component.set("v.rightItems", rightSide === undefined ? [] : helper.sortByName(rightSide));
        }

        var res = component.get('v.selectedItems');
        res = res + ';' + idSelectedElement;
        component.set('v.selectedItems', res);
    },

    /*
        call when click left button;
    */
    moveRightToLeft: function (component, event, helper) {
        var idSelectedElement = component.get("v.idSelectedElement");
        var leftSide = component.get("v.items");
        var rightSide = component.get("v.rightItems");
        var temp;
        var isAlreadyInLeft = false;

        for (var item in leftSide) {
            if (leftSide[item].Id === idSelectedElement) {
                isAlreadyInLeft = true;
            }
        }

        if (!isAlreadyInLeft) {
            for (var item in rightSide) {
                if (rightSide[item].Id === idSelectedElement) {
                    leftSide.push(rightSide[item])
                    temp = rightSide.filter(function (elem) {
                        return elem.Id !== idSelectedElement;
                    });
                }
            }

            component.set("v.items", leftSide === undefined ? [] : helper.sortByName(leftSide));
            component.set("v.rightItems", temp === undefined ? [] : helper.sortByName(temp));
        }

        var res = component.get('v.selectedItems');
        if (res.includes(';' + idSelectedElement)) {
            res = res.replace(';' + idSelectedElement, '');
        } else if (res.includes(idSelectedElement + ';')) {
            res = res.replace(idSelectedElement + ';', '');
        } else {
            res = res.replace(idSelectedElement, '');
        }

        component.set('v.selectedItems', res);
    },

    /*
        call when use search input;
    */
    handleKeyUp: function (component, event, helper) {

        var queryTerm = component.find('enter-search').get('v.value');

        var baseListOfElements = component.get("v.baseListItems");
        var rightSide = component.get("v.rightItems");

        var temporary = [];
        for (var item in baseListOfElements) {
            var strTemr = baseListOfElements[item].Name.toLowerCase();
            if (strTemr.indexOf(queryTerm) !== -1) {
                var isAdd = true;
                for (var inner in rightSide) {

                    if (rightSide[inner].Id === baseListOfElements[item].Id) {
                        isAdd = false;
                    }

                }
                if (isAdd) {
                    temporary.push(baseListOfElements[item]);
                }

            }
        }

        component.set('v.items', helper.sortByName(temporary));
    },

})