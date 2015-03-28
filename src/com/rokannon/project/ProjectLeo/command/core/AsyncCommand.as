package com.rokannon.project.ProjectLeo.command.core
{
    import com.rokannon.core.Broadcaster;
    import com.rokannon.core.errors.AbstractMethodError;

    public class AsyncCommand implements ICommand
    {
        protected const _eventComplete:Broadcaster = new Broadcaster(this);

        public function AsyncCommand()
        {
        }

        public function get eventComplete():Broadcaster
        {
            return _eventComplete;
        }

        public function execute():void
        {
            throw new AbstractMethodError();
        }
    }
}