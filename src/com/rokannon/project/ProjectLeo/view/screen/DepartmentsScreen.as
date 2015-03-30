package com.rokannon.project.ProjectLeo.view.screen
{
    import com.rokannon.project.ProjectLeo.ApplicationModel;
    import com.rokannon.project.ProjectLeo.command.requestDB.DBRequestType;
    import com.rokannon.project.ProjectLeo.system.DBSystem;

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

    public class DepartmentsScreen extends PanelScreen
    {
        public static const EVENT_TO_MAIN_MENU:String = "eventToMainMenu";
        public static const EVENT_SELECT_DEPARTMENT:String = "eventSelectDepartment";
        public static const EVENT_BROWSE_EMPLOYEES:String = "eventBrowseEmployees";
        public static const EVENT_NEW_DEPARTMENT:String = "eventNewDepartment";
        public static const EVENT_DELETE_DEPARTMENT:String = "eventDeleteDepartment";

        public var appModel:ApplicationModel;

        private var _departmentsList:List;
        private var _toMainMenuButton:Button;
        private var _browseEmployeesButton:Button;
        private var _newDepartmentButton:Button;
        private var _deleteDepartmentButton:Button;

        override protected function initialize():void
        {
            super.initialize();

            headerProperties.title = "Departments";
            layout = new AnchorLayout();
            footerFactory = function ():IFeathersControl
            {
                return new Header();
            };

            _departmentsList = new List();
            _departmentsList.itemRendererProperties.labelField = "DeptName";
            _departmentsList.itemRendererProperties.accessoryLabelField = "EmplAmount";
            _departmentsList.layoutData = new AnchorLayoutData(0, 0, 0, 0);
            _departmentsList.isSelectable = true;
            _departmentsList.clipContent = false;
            _departmentsList.autoHideBackground = true;
            _departmentsList.hasElasticEdges = false;
            _departmentsList.addEventListener(Event.CHANGE, list_changeHandler);
            _departmentsList.dataProvider = new ListCollection(appModel.dbSystem.requestResult.result.data);
            addChild(_departmentsList);

            _toMainMenuButton = new Button();
            _toMainMenuButton.nameList.add(Button.ALTERNATE_NAME_BACK_BUTTON);
            _toMainMenuButton.label = "To Main Menu";
            _toMainMenuButton.addEventListener(Event.TRIGGERED, toMainMenuButton_triggeredHandler);
            headerProperties.leftItems = new <DisplayObject> [_toMainMenuButton];

            _browseEmployeesButton = new Button();
            _browseEmployeesButton.nameList.add(Button.ALTERNATE_NAME_FORWARD_BUTTON);
            _browseEmployeesButton.label = "Browse Employees";
            _browseEmployeesButton.addEventListener(Event.TRIGGERED, browseEmplotyeesButton_triggeredHandler);
            headerProperties.rightItems = new <DisplayObject> [_browseEmployeesButton];

            _newDepartmentButton = new Button();
            _newDepartmentButton.label = "New Department";
            _newDepartmentButton.addEventListener(Event.TRIGGERED, newDepartmentButton_triggeredHandler);
            footerProperties.rightItems = new <DisplayObject> [_newDepartmentButton];

            _deleteDepartmentButton = new Button();
            _deleteDepartmentButton.nameList.add(Button.ALTERNATE_NAME_DANGER_BUTTON);
            _deleteDepartmentButton.label = "Delete Department";
            _deleteDepartmentButton.addEventListener(Event.TRIGGERED, deleteDepartmentButton_triggeredHandler);
            footerProperties.leftItems = new <DisplayObject> [_deleteDepartmentButton];

            updateButtons();

            appModel.dbSystem.eventRequestComplete.add(onRequestComplete);
        }

        override public function dispose():void
        {
            appModel.dbSystem.eventRequestComplete.remove(onRequestComplete);
            super.dispose();
        }

        private function onRequestComplete(dbSystem:DBSystem):void
        {
            if (_isInitialized && dbSystem.requestResult.request.requestType == DBRequestType.DEPARTMENTS)
            {
                _departmentsList.selectedIndex = -1;
                _departmentsList.dataProvider = new ListCollection(appModel.dbSystem.requestResult.result.data);
            }
        }

        private function deleteDepartmentButton_triggeredHandler(event:Event):void
        {
            dispatchEventWith(EVENT_DELETE_DEPARTMENT);
        }

        private function newDepartmentButton_triggeredHandler(event:Event):void
        {
            dispatchEventWith(EVENT_NEW_DEPARTMENT);
        }

        private function browseEmplotyeesButton_triggeredHandler(event:Event):void
        {
            dispatchEventWith(EVENT_BROWSE_EMPLOYEES);
        }

        private function toMainMenuButton_triggeredHandler(event:Event):void
        {
            dispatchEventWith(EVENT_TO_MAIN_MENU);
        }

        private function list_changeHandler(event:Event):void
        {
            updateButtons();
            if (_departmentsList.selectedIndex >= 0)
                dispatchEventWith(EVENT_SELECT_DEPARTMENT, false, _departmentsList.selectedIndex);
        }

        private function updateButtons():void
        {
            _browseEmployeesButton.isEnabled = _departmentsList.selectedIndex >= 0;
            _deleteDepartmentButton.isEnabled = _departmentsList.selectedIndex >= 0;
        }
    }
}