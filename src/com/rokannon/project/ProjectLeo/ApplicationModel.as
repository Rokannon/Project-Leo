package com.rokannon.project.ProjectLeo
{
    import com.rokannon.project.ProjectLeo.command.core.CommandExecutor;
    import com.rokannon.project.ProjectLeo.data.DepartmentData;
    import com.rokannon.project.ProjectLeo.data.EmployeeData;
    import com.rokannon.project.ProjectLeo.system.dataLibrary.ApplicationDataSystem;
    import com.rokannon.project.ProjectLeo.system.database.DBSystem;
    import com.rokannon.project.ProjectLeo.system.departments.DepartmentsSystem;
    import com.rokannon.project.ProjectLeo.system.employeeFilter.EmployeeFilterSystem;

    import feathers.controls.ScreenNavigator;

    import starling.core.Starling;

    public class ApplicationModel
    {
        public const commandExecutor:CommandExecutor = new CommandExecutor();
        public const dbSystem:DBSystem = new DBSystem();
        public const appDataSystem:ApplicationDataSystem = new ApplicationDataSystem();
        public const selectedDepartment:DepartmentData = new DepartmentData();
        public const selectedEmployee:EmployeeData = new EmployeeData();
        public const employeeFilterSystem:EmployeeFilterSystem = new EmployeeFilterSystem();
        public const departmentsSystem:DepartmentsSystem = new DepartmentsSystem();
        public var starlingInstance:Starling;
        public var screenNavigator:ScreenNavigator;

        public function ApplicationModel()
        {
            employeeFilterSystem.connect(appDataSystem);
        }
    }
}