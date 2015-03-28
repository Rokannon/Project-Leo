package com.rokannon.project.ProjectLeo.view.screen
{
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

    public class DepartmentsScreen extends PanelScreen
    {
        public static const EVENT_TO_MAIN_MENU:String = "eventToMainMenu";

        public var appModel:ApplicationModel;

        private var _departmentsList:List;
        private var _toMainMenuButton:Button;

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
        }

        private function toMainMenuButton_triggeredHandler(event:Event):void
        {
            dispatchEventWith(EVENT_TO_MAIN_MENU);
        }

        private function list_changeHandler(event:Event):void
        {
            trace("List changed!");
        }
    }
}