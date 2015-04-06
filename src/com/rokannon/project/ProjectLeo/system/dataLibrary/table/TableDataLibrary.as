package com.rokannon.project.ProjectLeo.system.dataLibrary.table
{
    import com.rokannon.core.utils.requireProperty;
    import com.rokannon.project.ProjectLeo.system.dataLibrary.ApplicationDataLibrary;
    import com.rokannon.project.ProjectLeo.system.dataLibrary.enum.DataType;
    import com.rokannon.project.ProjectLeo.system.dataLibrary.tableField.TableFieldData;

    public class TableDataLibrary extends ApplicationDataLibrary
    {
        public const tableDataArray:Vector.<TableData> = new <TableData>[];

        public function TableDataLibrary()
        {
            super(DataType.TABLE_DATA);
        }

        public function getTableDataByKey(key:Object):TableData
        {
            return getDataByKey(key) as TableData;
        }

        override protected function createDataFromJSON(json:Object):Object
        {
            var data:TableData = new TableData();
            data.primaryKeyName = requireProperty(json, "primaryKeyName");
            data.tableName = requireProperty(json, "tableName");
            var tableFields:Array = requireProperty(json, "tableFields");
            for (var i:int = 0; i < tableFields.length; ++i)
            {
                var tableFieldData:TableFieldData = _dataSystem.tableFieldDataLibrary.getTableFieldDataByKey(tableFields[i]);
                data.tableFields[i] = tableFieldData;
            }
            tableDataArray.push(data);
            return data;
        }
    }
}