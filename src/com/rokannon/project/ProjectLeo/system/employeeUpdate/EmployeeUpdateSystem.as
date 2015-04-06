package com.rokannon.project.ProjectLeo.system.employeeUpdate
{
    import com.rokannon.core.utils.string.stringFormat;
    import com.rokannon.project.ProjectLeo.data.tableFieldItem.TableFieldCollection;
    import com.rokannon.project.ProjectLeo.data.tableFieldItem.TableFieldItem;
    import com.rokannon.project.ProjectLeo.system.dataLibrary.ApplicationDataSystem;
    import com.rokannon.project.ProjectLeo.system.dataLibrary.tableField.TableFieldData;

    public class EmployeeUpdateSystem
    {
        private static const helperStrings:Vector.<String> = new <String>[];

        public const updateItemsCollection:TableFieldCollection = new TableFieldCollection();

        private var _appDataSystem:ApplicationDataSystem;

        public function EmployeeUpdateSystem()
        {
        }

        public function connect(appDataSystem:ApplicationDataSystem):void
        {
            _appDataSystem = appDataSystem;
        }

        public function getUnupdatedFields(resultFields:Vector.<TableFieldData> = null):Vector.<TableFieldData>
        {
            if (resultFields == null)
                resultFields = new <TableFieldData>[];
            for each (var fieldData:TableFieldData in _appDataSystem.tableFieldDataLibrary.tableFieldDataArray)
            {
                if (updateItemsCollection.fieldItemByFieldData[fieldData] == null && fieldData.allowSearch)
                    resultFields.push(fieldData);
            }
            return resultFields;
        }

        public function createUpdateClause():String
        {
            for (var i:int = 0; i < updateItemsCollection.fieldItems.length; ++i)
            {
                var filterItem:TableFieldItem = updateItemsCollection.fieldItems[i];
                var conditionTemplate:String = filterItem.fieldData.dataType == "integer" ? "{0}={1}" : "{0}='{1}'";
                helperStrings.push(stringFormat(conditionTemplate, filterItem.fieldData.fieldName,
                                                filterItem.fieldValue));
            }
            var result:String = helperStrings.join(", ");
            helperStrings.length = 0;
            return result;
        }
    }
}