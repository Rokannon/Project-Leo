package com.rokannon.project.ProjectLeo.system.dataLibrary.table
{
    import com.rokannon.core.utils.requireProperty;
    import com.rokannon.project.ProjectLeo.system.dataLibrary.ApplicationDataLibrary;
    import com.rokannon.project.ProjectLeo.system.dataLibrary.enum.DataType;
    import com.rokannon.project.ProjectLeo.system.dataLibrary.tableField.TableFieldData;

    public class TableDataLibrary extends ApplicationDataLibrary
    {
        public function TableDataLibrary()
        {
            super(DataType.TABLE_DATA);
        }

        override protected function createDataFromJSON(json:Object):Object
        {
            var data:TableData = new TableData();
            data.primaryKeyName = requireProperty(json, "primaryKeyName");
            var tableFields:Array = requireProperty(json, "tableFields");
            for (var i:int = 0; i < tableFields.length; ++i)
            {
                var tableFieldData:TableFieldData = _dataSystem.tableFieldDataLibrary.getTableFieldDataByKey(tableFields[i]);
                data.tableFields[i] = tableFieldData;
            }
            return data;
        }
    }
}