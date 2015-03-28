package com.rokannon.project.ProjectLeo.view.screen
{
    import com.rokannon.core.utils.string.stringFormat;
    import com.rokannon.project.ProjectLeo.ApplicationModel;

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

        public var appModel:ApplicationModel;

        private var _employeesList:List;
        private var _toDepartmentsButton:Button;

        override protected function initialize():void
        {
            super.initialize();

            headerProperties.title = stringFormat("Employees in '{0}'", appModel.selectedDepartment.departmentName);
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

            _toDepartmentsButton = new Button();
            _toDepartmentsButton.nameList.add(Button.ALTERNATE_NAME_BACK_BUTTON);
            _toDepartmentsButton.label = "To Departments";
            _toDepartmentsButton.addEventListener(Event.TRIGGERED, toMainMenuButton_triggeredHandler);
            headerProperties.leftItems = new <DisplayObject> [_toDepartmentsButton];
        }

        private function list_changeHandler(event:Event):void
        {
            trace("List changed!");
        }

        private function toMainMenuButton_triggeredHandler(event:Event):void
        {
            dispatchEventWith(EVENT_TO_DEPARTMENTS);
        }
    }
}