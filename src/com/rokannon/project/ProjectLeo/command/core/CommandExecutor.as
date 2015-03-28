package com.rokannon.project.ProjectLeo.command.core
{
    import com.rokannon.core.Broadcaster;

    public class CommandExecutor
    {
        public const eventExecuteStart:Broadcaster = new Broadcaster(this);
        public const eventExecuteEnd:Broadcaster = new Broadcaster(this);

        private const _commands:Vector.<ICommand> = new <ICommand>[];
        private var _isExecuting:Boolean = false;

        public function CommandExecutor()
        {
        }

        public function pushCommand(command:ICommand):void
        {
            _commands.push(command);
            if (!_isExecuting)
                executeNext();
        }

        public function get isExecuting():Boolean
        {
            return _isExecuting;
        }

        private function executeNext():void
        {
            var command:ICommand = _commands.shift();
            command.eventComplete.add(onCommandComplete);
            if (!_isExecuting)
            {
                _isExecuting = true;
                eventExecuteStart.broadcast();
            }
            command.execute();
        }

        private function onCommandComplete(command:ICommand):void
        {
            command.eventComplete.remove(onCommandComplete);
            if (_commands.length > 0)
                executeNext();
            else
            {
                _isExecuting = false;
                eventExecuteEnd.broadcast();
            }
        }
    }
}