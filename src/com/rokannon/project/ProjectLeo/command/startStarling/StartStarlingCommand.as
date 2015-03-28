package com.rokannon.project.ProjectLeo.command.startStarling
{
    import com.rokannon.project.ProjectLeo.view.StarlingRoot;
    import com.rokannon.project.ProjectLeo.command.core.AsyncCommand;

    import starling.core.Starling;
    import starling.events.Event;

    public class StartStarlingCommand extends AsyncCommand
    {
        private var _data:StartStarlingCommandData;

        public function StartStarlingCommand(data:StartStarlingCommandData)
        {
            super();
            _data = data;
        }

        override public function execute():void
        {
            _data.appModel.starlingInstance = new Starling(_data.rootClass, _data.nativeStage);
            _data.appModel.starlingInstance.addEventListener(Event.ROOT_CREATED, onRootCreated);
            _data.appModel.starlingInstance.start();
            //_data.appModel.starlingInstance.showStats = true;
        }

        private function onRootCreated(event:Event):void
        {
            _data.appModel.starlingInstance.removeEventListener(Event.ROOT_CREATED, onRootCreated);
            var starlingRoot:StarlingRoot = _data.appModel.starlingInstance.root as StarlingRoot;
            starlingRoot.startApplication(_data.appModel, _data.appController);
            _eventComplete.broadcast();
        }
    }
}