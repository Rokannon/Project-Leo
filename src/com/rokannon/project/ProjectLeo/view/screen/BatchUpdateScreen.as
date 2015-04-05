package com.rokannon.project.ProjectLeo.view.screen
{
    import feathers.controls.List;
    import feathers.controls.PanelScreen;

    public class BatchUpdateScreen extends PanelScreen
    {
        public static const EVENT_MOVE_TO_DEPARTMENT:String = "eventMoveToDepartment";
        public static const EVENT_UPDATE_

        private var _operationsList:List = new List();

        override protected function initialize():void
        {
            super.initialize();
        }
    }
}