package com.rokannon.project.ProjectLeo.view.screen
{
    import feathers.controls.ButtonGroup;
    import feathers.controls.PanelScreen;
    import feathers.data.ListCollection;
    import feathers.layout.AnchorLayout;
    import feathers.layout.AnchorLayoutData;

    import starling.events.Event;

    public class MainMenuScreen extends PanelScreen
    {
        public static const EVENT_SHOW_DEPARTMENTS:String = "eventShowDepartments";

        private var _buttonGroup:ButtonGroup;

        override public function dispose():void
        {
            if (_isInitialized)

                super.dispose();
        }

        override protected function initialize():void
        {
            super.initialize();

            headerProperties.title = "Main Menu";
            layout = new AnchorLayout();

            _buttonGroup = new ButtonGroup();
            _buttonGroup.dataProvider = new ListCollection([{
                label: "Show Departments", event: EVENT_SHOW_DEPARTMENTS
            }]);
            _buttonGroup.addEventListener(Event.TRIGGERED, buttonGroup_triggeredHandler);
            var buttonGroupLayoutData:AnchorLayoutData = new AnchorLayoutData();
            buttonGroupLayoutData.horizontalCenter = 0;
            buttonGroupLayoutData.verticalCenter = 0;
            _buttonGroup.layoutData = buttonGroupLayoutData;
            addChild(_buttonGroup);
        }

        private function buttonGroup_triggeredHandler(event:Event, data:Object):void
        {
            dispatchEventWith(data.event);
        }
    }
}