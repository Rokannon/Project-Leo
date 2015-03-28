package com.rokannon.project.ProjectLeo.command.traceDBResult
{
    import com.rokannon.project.ProjectLeo.command.core.SyncCommand;

    public class TraceDBResultCommand extends SyncCommand
    {
        private var _data:TraceDBResultCommandData;

        public function TraceDBResultCommand(data:TraceDBResultCommandData)
        {
            _data = data;
        }

        override protected function doExecute():void
        {
            if (_data.dbSystem.requestResult.result == null)
            {
                trace(_data.dbSystem.requestResult.errorMessage);
                trace("Details: " + _data.dbSystem.requestResult.errorDetails);
            }
            else
            {
                for (var i:int = 0; i < _data.dbSystem.requestResult.result.data.length; ++i)
                    trace(JSON.stringify(_data.dbSystem.requestResult.result.data[i]));
            }
        }
    }
}