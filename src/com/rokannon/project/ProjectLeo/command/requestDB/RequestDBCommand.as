package com.rokannon.project.ProjectLeo.command.requestDB
{
    import com.rokannon.project.ProjectLeo.command.core.AsyncCommand;

    import flash.data.SQLStatement;
    import flash.events.SQLErrorEvent;
    import flash.events.SQLEvent;

    public class RequestDBCommand extends AsyncCommand
    {
        private const _statement:SQLStatement = new SQLStatement();
        private var _data:RequestDBCommandData;

        public function RequestDBCommand(data:RequestDBCommandData)
        {
            super();
            _data = data;
        }

        override public function execute():void
        {
            _data.dbSystem.requestResult.clearRequest();
            _data.dbSystem.requestResult.request = _data.request;
            _statement.sqlConnection = _data.dbSystem.connection;
            _statement.text = _data.request.requestText;
            _statement.addEventListener(SQLEvent.RESULT, onStatementResult);
            _statement.addEventListener(SQLErrorEvent.ERROR, onStatementError);
            _statement.execute();
        }

        private function onStatementError(event:SQLErrorEvent):void
        {
            _statement.removeEventListener(SQLEvent.RESULT, onStatementResult);
            _statement.removeEventListener(SQLErrorEvent.ERROR, onStatementError);
            _data.dbSystem.requestResult.errorFlag = true;
            _data.dbSystem.requestResult.errorMessage = event.error.message;
            _data.dbSystem.requestResult.errorDetails = event.error.details;
            _data.dbSystem.eventRequestComplete.broadcast();
            _eventComplete.broadcast();
        }

        private function onStatementResult(event:SQLEvent):void
        {
            _statement.removeEventListener(SQLEvent.RESULT, onStatementResult);
            _statement.removeEventListener(SQLErrorEvent.ERROR, onStatementError);
            _data.dbSystem.requestResult.result = _statement.getResult();
            _data.dbSystem.eventRequestComplete.broadcast();
            _eventComplete.broadcast();
        }
    }
}