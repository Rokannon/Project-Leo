package com.rokannon.project.ProjectLeo.command.openDB
{
    import com.rokannon.project.ProjectLeo.command.core.AsyncCommand;

    import flash.events.SQLEvent;
    import flash.filesystem.File;

    public class OpenDBCommand extends AsyncCommand
    {
        private var _data:OpenDBCommandData;

        public function OpenDBCommand(data:OpenDBCommandData)
        {
            super();
            _data = data;
        }

        override public function execute():void
        {
            _data.dbSystem.connection.addEventListener(SQLEvent.OPEN, onDBConnectionOpened);
            var dbFile:File = File.applicationDirectory.resolvePath(_data.dbFilename);
            _data.dbSystem.connection.openAsync(dbFile);
        }

        private function onDBConnectionOpened(event:SQLEvent):void
        {
            _data.dbSystem.connection.removeEventListener(SQLEvent.OPEN, onDBConnectionOpened);
            _eventComplete.broadcast();
        }
    }
}