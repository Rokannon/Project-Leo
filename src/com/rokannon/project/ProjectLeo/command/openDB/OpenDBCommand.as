package com.rokannon.project.ProjectLeo.command.openDB
{
    import com.rokannon.project.ProjectLeo.command.core.AsyncCommand;

    import flash.events.SQLErrorEvent;
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
            _data.dbSystem.connection.addEventListener(SQLErrorEvent.ERROR, onDBConnectionOpenError);
            var dbFile:File = File.applicationDirectory.resolvePath(_data.dbFilename);
            _data.dbSystem.connection.openAsync(dbFile, _data.openMode);
        }

        private function onDBConnectionOpenError(event:SQLErrorEvent):void
        {
            _data.dbSystem.connection.removeEventListener(SQLEvent.OPEN, onDBConnectionOpened);
            _data.dbSystem.connection.removeEventListener(SQLErrorEvent.ERROR, onDBConnectionOpenError);
            _data.dbSystem.eventDatabaseOpenError.broadcast();
            _eventComplete.broadcast();
        }

        private function onDBConnectionOpened(event:SQLEvent):void
        {
            _data.dbSystem.connection.removeEventListener(SQLEvent.OPEN, onDBConnectionOpened);
            _data.dbSystem.connection.removeEventListener(SQLErrorEvent.ERROR, onDBConnectionOpenError);
            _data.dbSystem.eventDatabaseOpenComplete.broadcast();
            _eventComplete.broadcast();
        }
    }
}