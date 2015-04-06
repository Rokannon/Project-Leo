package com.rokannon.project.ProjectLeo
{
    import com.rokannon.core.utils.callOutStack;
    import com.rokannon.project.ProjectLeo.command.initDataSystem.InitDataSystemCommand;
    import com.rokannon.project.ProjectLeo.command.initDataSystem.InitDataSystemCommandData;
    import com.rokannon.project.ProjectLeo.command.openDB.OpenDBCommand;
    import com.rokannon.project.ProjectLeo.command.openDB.OpenDBCommandData;
    import com.rokannon.project.ProjectLeo.command.startStarling.StartStarlingCommand;
    import com.rokannon.project.ProjectLeo.command.startStarling.StartStarlingCommandData;
    import com.rokannon.project.ProjectLeo.view.StarlingRoot;

    import flash.data.SQLMode;
    import flash.display.Sprite;
    import flash.display.StageScaleMode;

    import starling.events.Event;

    public class Main extends Sprite
    {
        public const appModel:ApplicationModel = new ApplicationModel();
        public const appController:ApplicationController = new ApplicationController();

        public function Main()
        {
            appController.connect(appModel);

            if (stage == null)
                addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            else
                onAddedToStage();
        }

        private function onAddedToStage(event:Event = null):void
        {
            if (event != null)
                removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

            stage.scaleMode = StageScaleMode.NO_SCALE;

            callOutStack(startApplication);
        }

        private function startApplication():void
        {
            var startStarlingCommandData:StartStarlingCommandData = new StartStarlingCommandData();
            startStarlingCommandData.appModel = appModel;
            startStarlingCommandData.appController = appController;
            startStarlingCommandData.nativeStage = stage;
            startStarlingCommandData.rootClass = StarlingRoot;
            appModel.commandExecutor.pushCommand(new StartStarlingCommand(startStarlingCommandData));

            var initDataSystemCommandData:InitDataSystemCommandData = new InitDataSystemCommandData();
            initDataSystemCommandData.appDataSystem = appModel.appDataSystem;
            appModel.commandExecutor.pushCommand(new InitDataSystemCommand(initDataSystemCommandData));

            var openDBCommandData:OpenDBCommandData = new OpenDBCommandData();
            openDBCommandData.dbSystem = appModel.dbSystem;
            openDBCommandData.dbFilename = "staff.db";
            openDBCommandData.openMode = SQLMode.READ;
            appModel.commandExecutor.pushCommand(new OpenDBCommand(openDBCommandData));
        }
    }
}