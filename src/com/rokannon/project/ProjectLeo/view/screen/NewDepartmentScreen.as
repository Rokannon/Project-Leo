package com.rokannon.project.ProjectLeo.view.screen
{
    import com.rokannon.project.ProjectLeo.ApplicationModel;

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

    public class NewDepartmentScreen extends PanelScreen
    {
        public static const EVENT_CANCEL:String = "eventCancel";
        public static const EVENT_CREATE:String = "eventCreate";

        public var appModel:ApplicationModel;

        private var _cancelButton:Button;
        private var _nameInput:TextInput;
        private var _createButton:Button;
        private var _list:List;

        override protected function initialize():void
        {
            super.initialize();

            headerProperties.title = "New Department";
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

            _nameInput = new TextInput();
            _nameInput.restrict = "a-zA-Z0-9_ а-яА-Я";
            _nameInput.addEventListener(Event.CHANGE, nameInput_changeHandler);

            _createButton = new Button();
            _createButton.nameList.add(Button.ALTERNATE_NAME_FORWARD_BUTTON);
            _createButton.label = "Create";
            _createButton.addEventListener(Event.TRIGGERED, createButton_triggeredHandler);
            headerProperties.rightItems = new <DisplayObject> [_createButton];

            _list = new List();
            _list.itemRendererProperties.labelField = "text";
            _list.dataProvider = new ListCollection([{
                text: "Department Name", accessory: _nameInput
            }]);
            _list.layoutData = new AnchorLayoutData(0, 0, 0, 0);
            _list.isSelectable = false;
            _list.clipContent = false;
            _list.autoHideBackground = true;
            _list.hasElasticEdges = false;
            addChild(_list);

            updateButtons();
        }

        private function createButton_triggeredHandler(event:Event):void
        {
            dispatchEventWith(EVENT_CREATE, false, _nameInput.text);
        }

        private function nameInput_changeHandler(event:Event):void
        {
            updateButtons();
        }

        private function cancelButton_triggeredHandler(event:Event):void
        {
            dispatchEventWith(EVENT_CANCEL);
        }

        private function updateButtons():void
        {
            _createButton.isEnabled = _nameInput.text.length > 0;
        }
    }
}
