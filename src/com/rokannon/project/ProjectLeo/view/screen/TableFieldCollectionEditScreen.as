package com.rokannon.project.ProjectLeo.view.screen
{
    import com.rokannon.core.errors.AbstractMethodError;
    import com.rokannon.project.ProjectLeo.ApplicationModel;
    import com.rokannon.project.ProjectLeo.data.DepartmentData;
    import com.rokannon.project.ProjectLeo.data.tableFieldItem.TableFieldCollection;
    import com.rokannon.project.ProjectLeo.data.tableFieldItem.TableFieldItem;
    import com.rokannon.project.ProjectLeo.system.dataLibrary.tableField.TableFieldData;

    import feathers.controls.Button;
    import feathers.controls.Header;
    import feathers.controls.List;
    import feathers.controls.PanelScreen;
    import feathers.controls.PickerList;
    import feathers.controls.TextInput;
    import feathers.core.IFeathersControl;
    import feathers.data.ListCollection;
    import feathers.layout.AnchorLayout;
    import feathers.layout.AnchorLayoutData;

    import flash.utils.Dictionary;

    import starling.display.DisplayObject;
    import starling.events.Event;
    import starling.events.EventDispatcher;

    public class TableFieldCollectionEditScreen extends PanelScreen
    {
        public static const EVENT_CANCEL:String = "eventCancel";
        public static const EVENT_OK:String = "eventOk";

        private static const helperFields:Vector.<TableFieldData> = new <TableFieldData>[];

        public var appModel:ApplicationModel;

        protected const _itemByAccessory:Dictionary = new Dictionary();
        protected var _itemsListCollection:ListCollection;
        protected var _cancelButton:Button;
        protected var _removeItemButton:Button;
        protected var _itemsList:List;
        protected var _okButton:Button;
        protected var _addItemPickerList:PickerList;

        override protected function initialize():void
        {
            super.initialize();

            headerProperties.title = getHeaderTitle();
            layout = new AnchorLayout();
            footerFactory = function ():IFeathersControl
            {
                return new Header();
            };

            _itemsListCollection = new ListCollection();
            var items:Vector.<TableFieldItem> = getTableFieldCollection().fieldItems;
            for (var i:int = 0; i < items.length; ++i)
                addItemToListCollection(items[i]);

            _itemsList = new List();
            _itemsList.itemRendererProperties.labelField = "text";
            _itemsList.itemRendererProperties.accessoryField = "accessory";
            _itemsList.dataProvider = _itemsListCollection;
            _itemsList.layoutData = new AnchorLayoutData(0, 0, 0, 0);
            _itemsList.isSelectable = true;
            _itemsList.clipContent = false;
            _itemsList.autoHideBackground = true;
            _itemsList.hasElasticEdges = false;
            _itemsList.addEventListener(Event.CHANGE, itemsList_changeHandler);
            addChild(_itemsList);

            _cancelButton = new Button();
            _cancelButton.nameList.add(Button.ALTERNATE_NAME_BACK_BUTTON);
            _cancelButton.label = getCancelButtonLabel();
            _cancelButton.addEventListener(Event.TRIGGERED, toMainMenuButton_triggeredHandler);
            headerProperties.leftItems = new <DisplayObject> [_cancelButton];

            _removeItemButton = new Button();
            _removeItemButton.label = "Remove Item";
            _removeItemButton.addEventListener(Event.TRIGGERED, removeItemButton_triggeredHandler);
            _removeItemButton.nameList.add(Button.ALTERNATE_NAME_DANGER_BUTTON);
            footerProperties.leftItems = new <DisplayObject> [_removeItemButton];

            _addItemPickerList = new PickerList();
            _addItemPickerList.prompt = "Add Item";
            _addItemPickerList.dataProvider = new ListCollection(getFreeFields());
            _addItemPickerList.selectedIndex = -1;
            _addItemPickerList.addEventListener(Event.CHANGE, addItemPickerList_changeHandler);
            _addItemPickerList.listFactory = function ():List
            {
                var list:List = new List();
                list.itemRendererProperties.labelField = "labelName";
                return list;
            };
            footerProperties.rightItems = new <DisplayObject> [_addItemPickerList];

            _okButton = new Button();
            _okButton.label = getOkButtonLabel();
            _okButton.addEventListener(Event.TRIGGERED, doSearchButton_triggeredHandler);
            _okButton.nameList.add(Button.ALTERNATE_NAME_FORWARD_BUTTON);
            headerProperties.rightItems = new <DisplayObject> [_okButton];

            updateButtons();
        }

        private function addItemPickerList_changeHandler(event:Event):void
        {
            if (_addItemPickerList.selectedIndex == -1)
                return;
            var item:TableFieldItem = new TableFieldItem();
            item.fieldData = _addItemPickerList.selectedItem as TableFieldData;
            item.fieldValue = "";
            addItemToListCollection(item);
            getTableFieldCollection().addItem(item);
            updateButtons();
            _addItemPickerList.dataProvider.data = getFreeFields();
            _addItemPickerList.selectedIndex = -1;
        }

        private function doSearchButton_triggeredHandler(event:Event):void
        {
            dispatchEventWith(EVENT_OK);
        }

        private function itemsList_changeHandler(event:Event):void
        {
            updateButtons();
        }

        private function itemAccessory_changeHandler(event:Event):void
        {
            var item:TableFieldItem = _itemByAccessory[event.target];
            if (item.fieldData == appModel.appDataSystem.tableFieldDataLibrary.getTableFieldDataByKey("dept_field"))
            {
                var pickerList:PickerList = event.target as PickerList;
                var departmentData:DepartmentData = pickerList.dataProvider.getItemAt(pickerList.selectedIndex) as DepartmentData;
                item.fieldValue = departmentData.departmentId;
            }
            else
            {
                var textInput:TextInput = event.target as TextInput;
                item.fieldValue = textInput.text;
            }
        }

        private function removeItemButton_triggeredHandler(event:Event):void
        {
            var index:int = _itemsList.selectedIndex;
            var object:Object = _itemsListCollection.removeItemAt(index);
            var accessory:EventDispatcher = object.accessory;
            accessory.removeEventListener(Event.CHANGE, itemAccessory_changeHandler);
            delete _itemByAccessory[accessory];
            var item:TableFieldItem = getTableFieldCollection().fieldItems[index];
            getTableFieldCollection().removeItem(item);
            _itemsList.selectedIndex = _itemsListCollection.length - 1;
            _addItemPickerList.dataProvider.data = getFreeFields();
            _addItemPickerList.selectedIndex = -1;
            updateButtons();
        }

        private function toMainMenuButton_triggeredHandler(event:Event):void
        {
            dispatchEventWith(EVENT_CANCEL);
        }

        private function updateButtons():void
        {
            _removeItemButton.isEnabled = _itemsList.selectedIndex >= 0;
            getFreeFields(helperFields);
            helperFields.length = 0;
            _addItemPickerList.isEnabled = _addItemPickerList.dataProvider.length > 0;
            _okButton.isEnabled = getTableFieldCollection().fieldItems.length > 0;
        }

        private function addItemToListCollection(item:TableFieldItem):void
        {
            var dataItem:Object = {text: item.fieldData.labelName};
            if (item.fieldData == appModel.appDataSystem.tableFieldDataLibrary.getTableFieldDataByKey("dept_field"))
            {
                var pickerList:PickerList = new PickerList();
                _itemByAccessory[pickerList] = item;
                pickerList.labelField = "departmentName";
                pickerList.dataProvider = new ListCollection(appModel.departmentsSystem.departments);
                pickerList.selectedIndex = -1;
                pickerList.addEventListener(Event.CHANGE, itemAccessory_changeHandler);
                var departmentData:DepartmentData = appModel.departmentsSystem.departmentByDepartmentId[item.fieldValue];
                if (departmentData != null)
                    pickerList.selectedItem = departmentData;
                else
                    pickerList.selectedIndex = 0;
                pickerList.listFactory = function ():List
                {
                    var list:List = new List();
                    list.itemRendererProperties.labelField = "departmentName";
                    return list;
                };
                dataItem.accessory = pickerList;
            }
            else
            {
                var textInput:TextInput = new TextInput();
                textInput.restrict = "a-zA-Z0-9_ а-яА-Я";
                textInput.text = item.fieldValue;
                textInput.addEventListener(Event.CHANGE, itemAccessory_changeHandler);
                _itemByAccessory[textInput] = item;
                dataItem.accessory = textInput;
            }
            _itemsListCollection.push(dataItem);
        }

        protected function getFreeFields(resultFields:Vector.<TableFieldData> = null):Vector.<TableFieldData>
        {
            throw new AbstractMethodError();
        }

        protected function getTableFieldCollection():TableFieldCollection
        {
            throw new AbstractMethodError();
        }

        protected function getHeaderTitle():String
        {
            throw new AbstractMethodError();
        }

        protected function getCancelButtonLabel():String
        {
            throw new AbstractMethodError();
        }

        protected function getOkButtonLabel():String
        {
            throw new AbstractMethodError();
        }
    }
}