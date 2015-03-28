package com.rokannon.project.ProjectLeo
{
    import com.rokannon.project.ProjectLeo.command.enum.DBRequestText;
    import com.rokannon.project.ProjectLeo.command.requestDB.RequestDBCommand;
    import com.rokannon.project.ProjectLeo.command.requestDB.RequestDBCommandData;
    import com.rokannon.project.ProjectLeo.command.showScreen.ShowScreenCommand;
    import com.rokannon.project.ProjectLeo.command.showScreen.ShowScreenCommandData;
    import com.rokannon.project.ProjectLeo.command.traceDBResult.TraceDBResultCommand;
    import com.rokannon.project.ProjectLeo.command.traceDBResult.TraceDBResultCommandData;
    import com.rokannon.project.ProjectLeo.view.StarlingRoot;

    public class ApplicationController
    {
        private var _appModel:ApplicationModel;

        public function ApplicationController()
        {
        }

        public function connect(appModel:ApplicationModel):void
        {
            _appModel = appModel;
        }

        public function goToDepartments():void
        {
            var requestDBCommandData:RequestDBCommandData = new RequestDBCommandData();
            requestDBCommandData.dbSystem = _appModel.dbSystem;
            requestDBCommandData.requestText = DBRequestText.DEPARTMENTS;
            _appModel.commandExecutor.pushCommand(new RequestDBCommand(requestDBCommandData));

            //var traceDBResultCommandData:TraceDBResultCommandData = new TraceDBResultCommandData();
            //traceDBResultCommandData.dbSystem = _appModel.dbSystem;
            //_appModel.commandExecutor.pushCommand(new TraceDBResultCommand(traceDBResultCommandData));

            var showScreenCommandData:ShowScreenCommandData = new ShowScreenCommandData();
            showScreenCommandData.navigator = _appModel.screenNavigator;
            showScreenCommandData.screenName = StarlingRoot.SCREEN_DEPARTMENTS;
            _appModel.commandExecutor.pushCommand(new ShowScreenCommand(showScreenCommandData));
        }

        public function goToMainMenu():void
        {
            var showScreenCommandData:ShowScreenCommandData = new ShowScreenCommandData();
            showScreenCommandData.navigator = _appModel.screenNavigator;
            showScreenCommandData.screenName = StarlingRoot.SCREEN_MAIN_MENU;
            _appModel.commandExecutor.pushCommand(new ShowScreenCommand(showScreenCommandData));
        }
    }
}