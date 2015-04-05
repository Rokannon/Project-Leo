package com.rokannon.project.ProjectLeo.system.employeeFilter
{
    import com.rokannon.core.utils.clearDictionary;
    import com.rokannon.project.ProjectLeo.system.dataLibrary.ApplicationDataSystem;
    import com.rokannon.project.ProjectLeo.system.dataLibrary.tableField.TableFieldData;

    import flash.utils.Dictionary;

    public class EmployeeFilterSystem
    {
        public const filterItems:Vector.<EmployeeFilterItem> = new <EmployeeFilterItem>[];
        public const filterItemByFieldData:Dictionary = new Dictionary();
        public var filterContext:String;

        private var _appDataSystem:ApplicationDataSystem;

        public function EmployeeFilterSystem()
        {
        }

        public function connect(appDataSystem:ApplicationDataSystem):void
        {
            _appDataSystem = appDataSystem;
        }

        public function addFilterItem(filterItem:EmployeeFilterItem):void
        {
            var index:int = filterItems.indexOf(filterItem);
            if (index != -1)
                return;
            filterItems.push(filterItem);
            filterItemByFieldData[filterItem.fieldData] = filterItem;
        }

        public function removeFilterItem(filterItem:EmployeeFilterItem):void
        {
            var index:int = filterItems.indexOf(filterItem);
            if (index == -1)
                return;
            filterItems.splice(index, 1);
            delete filterItemByFieldData[filterItem.fieldData];
        }

        public function getUnfilteredFields(resultFields:Vector.<TableFieldData> = null):Vector.<TableFieldData>
        {
            if (resultFields == null)
                resultFields = new <TableFieldData>[];
            for each (var fieldData:TableFieldData in _appDataSystem.tableFieldDataLibrary.tableFieldDataArray)
            {
                if (filterItemByFieldData[fieldData] == null && fieldData.allowSearch)
                    resultFields.push(fieldData);
            }
            return resultFields;
        }

        public function removeAllFilterItems():void
        {
            filterItems.length = 0;
            clearDictionary(filterItemByFieldData);
        }
    }
}