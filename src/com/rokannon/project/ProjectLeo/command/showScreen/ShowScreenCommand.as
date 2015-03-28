package com.rokannon.project.ProjectLeo.command.showScreen
{
    import com.rokannon.project.ProjectLeo.command.core.SyncCommand;

    public class ShowScreenCommand extends SyncCommand
    {
        private var _data:ShowScreenCommandData;

        public function ShowScreenCommand(data:ShowScreenCommandData)
        {
            super();
            _data = data;
        }

        override protected function doExecute():void
        {
            _data.navigator.showScreen(_data.screenName);
        }
    }
}