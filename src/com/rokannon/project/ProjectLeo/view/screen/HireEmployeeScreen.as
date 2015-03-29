package com.rokannon.project.ProjectLeo.view.screen
{
    import com.rokannon.core.utils.string.stringFormat;
    import com.rokannon.project.ProjectLeo.ApplicationModel;
    import com.rokannon.project.ProjectLeo.data.EmployeeData;

    import feathers.controls.Button;
    import feathers.controls.Header;
    import feathers.controls.List;
    import feathers.controls.PanelScreen;
    import feathers.controls.TextInput;
    import feathers.core.IFeathersControl;
    import feathers.data.ListCollection;
    import feathers.layout.AnchorLayout;
    import feathers.layout.AnchorLayoutData;

    import starling.display.DisplayObject;
    import starling.events.Event;

    public class HireEmployeeScreen extends PanelScreen
    {
        public static const EVENT_CANCEL:String = "eventCancel";
        public static const EVENT_HIRE:String = "eventHire";

        public var appModel:ApplicationModel;

        private var _cancelButton:Button;
        private var _firstNameInput:TextInput;
        private var _lastNameInput:TextInput;
        private var _positionInput:TextInput;
        private var _hireButton:Button;
        private var _list:List;

        override protected function initialize():void
        {
            super.initialize();

            headerProperties.title = stringFormat("Hire employee to '{0}'",
                                                  appModel.selectedDepartment.departmentName);
            layout = new AnchorLayout();
            footerFactory = function ():IFeathersControl
            {
                return new Header();
            };

            _cancelButton = new Button();
            _cancelButton.nameList.add(Button.ALTERNATE_NAME_BACK_BUTTON);
            _cancelButton.label = "Cancel";
            _cancelButton.addEventListener(Event.TRIGGERED, cancelButton_triggeredHandler);
            headerProperties.leftItems = new <DisplayObject> [_cancelButton];

            _hireButton = new Button();
            _hireButton.nameList.add(Button.ALTERNATE_NAME_FORWARD_BUTTON);
            _hireButton.label = "Create";
            _hireButton.addEventListener(Event.TRIGGERED, hireButton_triggeredHandler);
            headerProperties.rightItems = new <DisplayObject> [_hireButton];

            _firstNameInput = new TextInput();
            _firstNameInput.restrict = "a-zA-Z0-9_ а-яА-Я";
            _firstNameInput.addEventListener(Event.CHANGE, firstNameInput_changeHandler);

            _lastNameInput = new TextInput();
            _lastNameInput.restrict = "a-zA-Z0-9_ а-яА-Я";
            _lastNameInput.addEventListener(Event.CHANGE, lastNameInput_changeHandler);

            _positionInput = new TextInput();
            _positionInput.restrict = "a-zA-Z0-9_ а-яА-Я";
            _positionInput.addEventListener(Event.CHANGE, positionInput_changeHandler);

            _list = new List();
            _list.itemRendererProperties.labelField = "text";
            _list.dataProvider = new ListCollection([{
                text: "Employee First Name", accessory: _firstNameInput
            },{
                text: "Employee Last Name", accessory: _lastNameInput
            }, {
                text: "Employee Position", accessory: _positionInput
            }]);
            _list.layoutData = new AnchorLayoutData(0, 0, 0, 0);
            _list.isSelectable = false;
            _list.clipContent = false;
            _list.autoHideBackground = true;
            _list.hasElasticEdges = false;
            addChild(_list);

            updateButtons();
        }

        private function lastNameInput_changeHandler(event:Event):void
        {
            updateButtons();
        }

        private function positionInput_changeHandler(event:Event):void
        {
            updateButtons();
        }

        private function firstNameInput_changeHandler(event:Event):void
        {
            updateButtons();
        }

        private function cancelButton_triggeredHandler(event:Event):void
        {
            dispatchEventWith(EVENT_CANCEL);
        }

        private function hireButton_triggeredHandler(event:Event):void
        {
            var employeeData:EmployeeData = new EmployeeData();
            employeeData.employeeFirstName = _firstNameInput.text;
            employeeData.employeeLastName = _lastNameInput.text;
            employeeData.employeePosition = _positionInput.text;
            employeeData.departmentId = appModel.selectedDepartment.departmentId;
            dispatchEventWith(EVENT_HIRE, false, employeeData);
        }

        private function updateButtons():void
        {
            _hireButton.isEnabled = _firstNameInput.text.length > 0 && _positionInput.text.length > 0;
        }
    }
}