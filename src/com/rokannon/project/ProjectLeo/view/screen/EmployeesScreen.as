package com.rokannon.project.ProjectLeo.view.screen
{
    import com.rokannon.core.utils.string.stringFormat;
    import com.rokannon.project.ProjectLeo.ApplicationModel;
    import com.rokannon.project.ProjectLeo.command.requestDB.DBRequestType;
    import com.rokannon.project.ProjectLeo.system.database.DBSystem;
    import com.rokannon.project.ProjectLeo.system.employeeFilter.enum.FilterContext;

    import feathers.controls.Alert;
    import feathers.controls.Button;
    import feathers.controls.Header;
    import feathers.controls.List;
    import feathers.controls.PanelScreen;
    import feathers.core.IFeathersControl;
    import feathers.data.ListCollection;
    import feathers.layout.AnchorLayout;
    import feathers.layout.AnchorLayoutData;

    import starling.display.DisplayObject;
    import starling.events.Event;

    public class EmployeesScreen extends PanelScreen
    {
        public static const EVENT_TO_DEPARTMENTS:String = "eventToDepartments";
        public static const EVENT_HIRE_EMPLOYEE:String = "eventHireEmployee";
        public static const EVENT_FIRE_EMPLOYEE:String = "eventFireEmployee";
        public static const EVENT_SELECT_EMPLOYEE:String = "eventSelectEmployee";
        public static const EVENT_TO_FILTER:String = "eventToFilter";
        public static const EVENT_TO_MAIN_MENU:String = "eventToMainMenu";
        public static const EVENT_BATCH_UPDATE:String = "eventBatchUpdate";

        public var appModel:ApplicationModel;

        private var _employeesList:List;
        private var _backButton:Button;
        private var _hireEmployeeButton:Button;
        private var _fireEmployeeButton:Button;
        private var _batchUpdateButton:Button;

        override protected function initialize():void
        {
            super.initialize();

            if (appModel.employeeFilterSystem.filterContext == FilterContext.DEPARTMENT)
                headerProperties.title = stringFormat("Employees in '{0}'", appModel.selectedDepartment.departmentName);
            else
                headerProperties.title = "Employees";

            layout = new AnchorLayout();
            footerFactory = function ():IFeathersControl
            {
                return new Header();
            };

            _employeesList = new List();
            _employeesList.itemRendererProperties.labelField = "FullName";
            _employeesList.itemRendererProperties.accessoryLabelField = "Position";
            _employeesList.layoutData = new AnchorLayoutData(0, 0, 0, 0);
            _employeesList.isSelectable = true;
            _employeesList.clipContent = false;
            _employeesList.autoHideBackground = true;
            _employeesList.hasElasticEdges = false;
            _employeesList.addEventListener(Event.CHANGE, list_changeHandler);
            _employeesList.dataProvider = new ListCollection(appModel.dbSystem.requestResult.result.data);
            addChild(_employeesList);

            _backButton = new Button();
            _backButton.nameList.add(Button.ALTERNATE_NAME_BACK_BUTTON);
            if (appModel.employeeFilterSystem.filterContext == FilterContext.DEPARTMENT)
                _backButton.label = "To Departments";
            else if (appModel.employeeFilterSystem.filterContext == FilterContext.CUSTOM_FILTER)
                _backButton.label = "To Filter";
            else
                _backButton.label = "Back";
            _backButton.addEventListener(Event.TRIGGERED, toDepartmentsButton_triggeredHandler);
            headerProperties.leftItems = new <DisplayObject> [_backButton];

            if (appModel.employeeFilterSystem.filterContext == FilterContext.DEPARTMENT)
            {
                _hireEmployeeButton = new Button();
                _hireEmployeeButton.label = "Hire Employee";
                _hireEmployeeButton.addEventListener(Event.TRIGGERED, hireEmployeeButton_triggeredHandler);
                footerProperties.rightItems = new <DisplayObject> [_hireEmployeeButton];
            }
            else if (appModel.employeeFilterSystem.filterContext == FilterContext.CUSTOM_FILTER)
            {
                _batchUpdateButton = new Button();
                _batchUpdateButton.label = "Batch Update";
                _batchUpdateButton.addEventListener(Event.TRIGGERED, batchUpdateButton_triggeredHandler);
                footerProperties.rightItems = new <DisplayObject> [_batchUpdateButton];
            }

            _fireEmployeeButton = new Button();
            _fireEmployeeButton.nameList.add(Button.ALTERNATE_NAME_DANGER_BUTTON);
            _fireEmployeeButton.label = "Fire Employee";
            _fireEmployeeButton.addEventListener(Event.TRIGGERED, fireEmployeeButton_triggeredHandler);
            footerProperties.leftItems = new <DisplayObject> [_fireEmployeeButton];

            updateButtons();

            appModel.dbSystem.eventRequestComplete.add(onRequestComplete);
        }

        private function batchUpdateButton_triggeredHandler(event:Event):void
        {
            dispatchEventWith(EVENT_BATCH_UPDATE);
        }

        override public function dispose():void
        {
            appModel.dbSystem.eventRequestComplete.remove(onRequestComplete);
            super.dispose();
        }

        private function onRequestComplete(dbSystem:DBSystem):void
        {
            if (_isInitialized && dbSystem.requestResult.request.requestType == DBRequestType.EMPLOYEES)
            {
                _employeesList.selectedIndex = -1;
                _employeesList.dataProvider = new ListCollection(dbSystem.requestResult.result.data);
            }
        }

        private function fireEmployeeButton_triggeredHandler(event:Event):void
        {
            var buttonList:ListCollection = new ListCollection([{label: "Cancel"}, {
                label: "OK", triggered: fireEmployeeAlert_triggeredHandler
            }]);
            Alert.show("Are you sure?\nThis can not be undone.", "Alert", buttonList);
        }

        private function fireEmployeeAlert_triggeredHandler(event:Event):void
        {
            dispatchEventWith(EVENT_FIRE_EMPLOYEE);
        }

        private function hireEmployeeButton_triggeredHandler(event:Event):void
        {
            dispatchEventWith(EVENT_HIRE_EMPLOYEE);
        }

        private function list_changeHandler(event:Event):void
        {
            updateButtons();
            if (_employeesList.selectedIndex >= 0)
                dispatchEventWith(EVENT_SELECT_EMPLOYEE, false, _employeesList.selectedIndex);
        }

        private function toDepartmentsButton_triggeredHandler(event:Event):void
        {
            if (appModel.employeeFilterSystem.filterContext == FilterContext.DEPARTMENT)
                dispatchEventWith(EVENT_TO_DEPARTMENTS);
            else if (appModel.employeeFilterSystem.filterContext == FilterContext.CUSTOM_FILTER)
                dispatchEventWith(EVENT_TO_FILTER);
            else
                dispatchEventWith(EVENT_TO_MAIN_MENU);
        }

        private function updateButtons():void
        {
            _fireEmployeeButton.isEnabled = _employeesList.selectedIndex >= 0;
        }
    }
}