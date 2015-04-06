package com.rokannon.project.ProjectLeo.system.employeeFilter
{
    import com.rokannon.core.utils.string.stringFormat;
    import com.rokannon.project.ProjectLeo.data.tableFieldItem.TableFieldCollection;
    import com.rokannon.project.ProjectLeo.data.tableFieldItem.TableFieldItem;
    import com.rokannon.project.ProjectLeo.system.dataLibrary.ApplicationDataSystem;
    import com.rokannon.project.ProjectLeo.system.dataLibrary.tableField.TableFieldData;
    import com.rokannon.project.ProjectLeo.system.departments.DepartmentsSystem;

    public class EmployeeFilterSystem
    {
        private static const helperStrings:Vector.<String> = new <String>[];

        public const filterItemCollection:TableFieldCollection = new TableFieldCollection();
        public var filterContext:String;

        private var _appDataSystem:ApplicationDataSystem;
        private var _departmentsSystem:DepartmentsSystem;

        public function EmployeeFilterSystem()
        {
        }

        public function connect(appDataSystem:ApplicationDataSystem, departmentsSystem:DepartmentsSystem):void
        {
            _appDataSystem = appDataSystem;
            _departmentsSystem = departmentsSystem;
        }

        public function getUnfilteredFields(resultFields:Vector.<TableFieldData> = null):Vector.<TableFieldData>
        {
            if (resultFields == null)
                resultFields = new <TableFieldData>[];
            for each (var fieldData:TableFieldData in _appDataSystem.tableFieldDataLibrary.tableFieldDataArray)
            {
                if (fieldData == _appDataSystem.tableFieldDataLibrary.getTableFieldDataByKey("dept_field") && _departmentsSystem.departments.length == 0)
                    continue;
                if (filterItemCollection.fieldItemByFieldData[fieldData] == null && fieldData.allowSearch)
                    resultFields.push(fieldData);
            }
            return resultFields;
        }

        public function createWhereClause():String
        {
            for (var i:int = 0; i < filterItemCollection.fieldItems.length; ++i)
            {
                var filterItem:TableFieldItem = filterItemCollection.fieldItems[i];
                var conditionTemplate:String = filterItem.fieldData.dataType == "integer" ? "{0}={1}" : "{0}='{1}'";
                helperStrings.push(stringFormat(conditionTemplate, filterItem.fieldData.fieldName,
                                                filterItem.fieldValue));
            }
            var result:String = helperStrings.join(" AND ");
            helperStrings.length = 0;
            return result;
        }
    }
}