package com.rokannon.project.ProjectLeo.command.selectEmployee
{
    import com.rokannon.project.ProjectLeo.data.EmployeeData;
    import com.rokannon.project.ProjectLeo.system.database.DBSystem;

    public class SelectEmployeeCommandData
    {
        public var employeeIndex:int;
        public var dbSystem:DBSystem;
        public var employeeData:EmployeeData;
    }
}