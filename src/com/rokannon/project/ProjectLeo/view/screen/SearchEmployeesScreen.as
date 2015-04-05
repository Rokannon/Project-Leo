package com.rokannon.project.ProjectLeo.view.screen
{
    import com.rokannon.core.utils.string.stringFormat;
    import com.rokannon.project.ProjectLeo.ApplicationModel;
    import com.rokannon.project.ProjectLeo.data.DepartmentData;
    import com.rokannon.project.ProjectLeo.system.dataLibrary.tableField.TableFieldData;
    import com.rokannon.project.ProjectLeo.system.employeeFilter.EmployeeFilterItem;

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

    public class SearchEmployeesScreen extends PanelScreen
    {
        public static const EVENT_TO_MAIN_MENU:String = "eventToMainMenu";
        public static const EVENT_DO_SEARCH:String = "eventDoSearch";

        private static const helperFields:Vector.<TableFieldData> = new <TableFieldData>[];

        public var appModel:ApplicationModel;

        private const _filterItemByAccessory:Dictionary = new Dictionary();
        private var _filterListCollection:ListCollection;
        private var _toMainMenuButton:Button;
        private var _removeFilterButton:Button;
        private var _addFilterButton:Button;
        private var _filtersList:List;
        private var _doSearchButton:Button;

        override protected function initialize():void
        {
            super.initialize();

            headerProperties.title = stringFormat("Create Search Query");
            layout = new AnchorLayout();
            footerFactory = function ():IFeathersControl
            {
                return new Header();
            };

            _filterListCollection = new ListCollection();
            var filterItems:Vector.<EmployeeFilterItem> = appModel.employeeFilterSystem.filterItems;
            for (var i:int = 0; i < filterItems.length; ++i)
                addFilterItemToListCollection(filterItems[i]);

            _filtersList = new List();
            _filtersList.itemRendererProperties.labelField = "text";
            _filtersList.itemRendererProperties.accessoryField = "accessory";
            _filtersList.dataProvider = _filterListCollection;
            _filtersList.layoutData = new AnchorLayoutData(0, 0, 0, 0);
            _filtersList.isSelectable = true;
            _filtersList.clipContent = false;
            _filtersList.autoHideBackground = true;
            _filtersList.hasElasticEdges = false;
            _filtersList.addEventListener(Event.CHANGE, filtersList_changeHandler);
            addChild(_filtersList);

            _toMainMenuButton = new Button();
            _toMainMenuButton.nameList.add(Button.ALTERNATE_NAME_BACK_BUTTON);
            _toMainMenuButton.label = "To Main Menu";
            _toMainMenuButton.addEventListener(Event.TRIGGERED, toMainMenuButton_triggeredHandler);
            headerProperties.leftItems = new <DisplayObject> [_toMainMenuButton];

            _removeFilterButton = new Button();
            _removeFilterButton.label = "Remove Filter";
            _removeFilterButton.addEventListener(Event.TRIGGERED, removeFilterButton_triggeredHandler);
            _removeFilterButton.nameList.add(Button.ALTERNATE_NAME_DANGER_BUTTON);
            footerProperties.leftItems = new <DisplayObject> [_removeFilterButton];

            _addFilterButton = new Button();
            _addFilterButton.label = "Add Filter";
            _addFilterButton.addEventListener(Event.TRIGGERED, addFilterButton_triggeredHandler);
            footerProperties.rightItems = new <DisplayObject> [_addFilterButton];

            _doSearchButton = new Button();
            _doSearchButton.label = "Search";
            _doSearchButton.addEventListener(Event.TRIGGERED, doSearchButton_triggeredHandler);
            _doSearchButton.nameList.add(Button.ALTERNATE_NAME_FORWARD_BUTTON);
            headerProperties.rightItems = new <DisplayObject> [_doSearchButton];

            updateButtons();
        }

        private function doSearchButton_triggeredHandler(event:Event):void
        {
            dispatchEventWith(EVENT_DO_SEARCH);
        }

        private function filtersList_changeHandler(event:Event):void
        {
            updateButtons();
        }

        private function addFilterButton_triggeredHandler(event:Event):void
        {
            var filterItem:EmployeeFilterItem = new EmployeeFilterItem();
            appModel.employeeFilterSystem.getUnfilteredFields(helperFields);
            filterItem.fieldData = helperFields[0];
            helperFields.length = 0;
            filterItem.filterValue = "";
            addFilterItemToListCollection(filterItem);
            appModel.employeeFilterSystem.addFilterItem(filterItem);
            updateButtons();
        }

        private function filterItemAccessory_changeHandler(event:Event):void
        {
            var filterItem:EmployeeFilterItem = _filterItemByAccessory[event.target];
            if (filterItem.fieldData == appModel.appDataSystem.tableFieldDataLibrary.getTableFieldDataByKey("dept_field"))
            {
                var pickerList:PickerList = event.target as PickerList;
                var departmentData:DepartmentData = pickerList.dataProvider.getItemAt(pickerList.selectedIndex) as DepartmentData;
                filterItem.filterValue = departmentData.departmentId;
            }
            else
            {
                var textInput:TextInput = event.target as TextInput;
                filterItem.filterValue = textInput.text;
            }
        }

        private function removeFilterButton_triggeredHandler(event:Event):void
        {
            var index:int = _filtersList.selectedIndex;
            var object:Object = _filterListCollection.removeItemAt(index);
            var accessory:EventDispatcher = object.accessory;
            accessory.removeEventListener(Event.CHANGE, filterItemAccessory_changeHandler);
            delete _filterItemByAccessory[accessory];
            var filterItem:EmployeeFilterItem = appModel.employeeFilterSystem.filterItems[index];
            appModel.employeeFilterSystem.removeFilterItem(filterItem);
            _filtersList.selectedIndex = _filterListCollection.length - 1;
            updateButtons();
        }

        private function toMainMenuButton_triggeredHandler(event:Event):void
        {
            dispatchEventWith(EVENT_TO_MAIN_MENU);
        }

        private function updateButtons():void
        {
            _removeFilterButton.isEnabled = _filtersList.selectedIndex >= 0;
            appModel.employeeFilterSystem.getUnfilteredFields(helperFields);
            _addFilterButton.isEnabled = helperFields.length > 0;
            helperFields.length = 0;
            _doSearchButton.isEnabled = appModel.employeeFilterSystem.filterItems.length > 0;
        }

        private function addFilterItemToListCollection(filterItem:EmployeeFilterItem):void
        {
            var dataItem:Object = {text: filterItem.fieldData.labelName};
            if (filterItem.fieldData == appModel.appDataSystem.tableFieldDataLibrary.getTableFieldDataByKey("dept_field"))
            {
                var pickerList:PickerList = new PickerList();
                _filterItemByAccessory[pickerList] = filterItem;
                pickerList.labelField = "departmentName";
                pickerList.dataProvider = new ListCollection(appModel.departmentsSystem.departments);
                pickerList.selectedIndex = -1;
                pickerList.addEventListener(Event.CHANGE, filterItemAccessory_changeHandler);
                var departmentData:DepartmentData = appModel.departmentsSystem.departmentByDepartmentId[filterItem.filterValue];
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
                textInput.text = filterItem.filterValue;
                textInput.addEventListener(Event.CHANGE, filterItemAccessory_changeHandler);
                _filterItemByAccessory[textInput] = filterItem;
                dataItem.accessory = textInput;
            }
            _filterListCollection.push(dataItem);
        }
    }
}