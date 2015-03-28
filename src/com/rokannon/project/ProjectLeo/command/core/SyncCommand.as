package com.rokannon.project.ProjectLeo.command.core
{
    import com.rokannon.core.Broadcaster;
    import com.rokannon.core.errors.AbstractMethodError;

    public class SyncCommand implements ICommand
    {
        private const _eventComplete:Broadcaster = new Broadcaster(this);

        public function SyncCommand()
        {
        }

        public final function execute():void
        {
            doExecute();
            _eventComplete.broadcast();
        }

        protected function doExecute():void
        {
            throw new AbstractMethodError();
        }

        public final function get eventComplete():Broadcaster
        {
            return _eventComplete;
        }
    }
}