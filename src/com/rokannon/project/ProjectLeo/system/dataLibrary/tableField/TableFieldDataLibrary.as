package com.rokannon.project.ProjectLeo.system.dataLibrary.tableField
{
    import com.rokannon.core.utils.getProperty;
    import com.rokannon.core.utils.requireProperty;
    import com.rokannon.project.ProjectLeo.system.dataLibrary.ApplicationDataLibrary;
    import com.rokannon.project.ProjectLeo.system.dataLibrary.enum.DataType;

    public class TableFieldDataLibrary extends ApplicationDataLibrary
    {
        public const tableFieldDataArray:Vector.<TableFieldData> = new <TableFieldData>[];

        public function TableFieldDataLibrary()
        {
            super(DataType.TABLE_FIELD_DATA);
        }

        public function getTableFieldDataByKey(key:Object):TableFieldData
        {
            return getDataByKey(key) as TableFieldData;
        }

        override protected function createDataFromJSON(json:Object):Object
        {
            var data:TableFieldData = new TableFieldData();
            data.allowSearch = getProperty(json, "allowSearch", false);
            data.dataType = requireProperty(json, "dataType");
            data.enableAutoincrement = getProperty(json, "enableAutoincrement", false);
            data.fieldName = requireProperty(json, "fieldName");
            data.labelName = requireProperty(json, "labelName");
            tableFieldDataArray.push(data);
            return data;
        }
    }
}