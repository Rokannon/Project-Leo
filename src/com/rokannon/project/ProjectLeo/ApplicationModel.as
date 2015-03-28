package com.rokannon.project.ProjectLeo
{
    import com.rokannon.project.ProjectLeo.command.core.CommandExecutor;
    import com.rokannon.project.ProjectLeo.data.DepartmentData;
    import com.rokannon.project.ProjectLeo.system.DBSystem;

    import feathers.controls.ScreenNavigator;

    import starling.core.Starling;

    public class ApplicationModel
    {
        public const commandExecutor:CommandExecutor = new CommandExecutor();
        public const dbSystem:DBSystem = new DBSystem();
        public const selectedDepartment:DepartmentData = new DepartmentData();
        public var starlingInstance:Starling;
        public var screenNavigator:ScreenNavigator;

        public function ApplicationModel()
        {
        }
    }
}