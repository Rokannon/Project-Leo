package com.rokannon.project.ProjectLeo.data.tableFieldItem
{
    import com.rokannon.core.utils.clearDictionary;

    import flash.utils.Dictionary;

    public class TableFieldCollection
    {
        public const fieldItems:Vector.<TableFieldItem> = new <TableFieldItem>[];
        public const fieldItemByFieldData:Dictionary = new Dictionary();

        public function TableFieldCollection()
        {
        }

        public function addItem(item:TableFieldItem):void
        {
            var index:int = fieldItems.indexOf(item);
            if (index != -1)
                return;
            fieldItems.push(item);
            fieldItemByFieldData[item.fieldData] = item;
        }

        public function removeItem(item:TableFieldItem):void
        {
            var index:int = fieldItems.indexOf(item);
            if (index == -1)
                return;
            fieldItems.splice(index, 1);
            delete fieldItemByFieldData[item.fieldData];
        }

        public function removeAllItems():void
        {
            fieldItems.length = 0;
            clearDictionary(fieldItemByFieldData);
        }
    }
}