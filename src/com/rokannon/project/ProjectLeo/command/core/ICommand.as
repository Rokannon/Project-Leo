package com.rokannon.project.ProjectLeo.command.core
{
    import com.rokannon.core.Broadcaster;

    public interface ICommand
    {
        function get eventComplete():Broadcaster;
        function execute():void;
    }
}