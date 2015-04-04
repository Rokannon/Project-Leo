package com.rokannon.project.ProjectLeo.command.selectDepartment
{
    import com.rokannon.project.ProjectLeo.data.DepartmentData;
    import com.rokannon.project.ProjectLeo.system.database.DBSystem;

    public class SelectDepartmentCommandData
    {
        public var departmentIndex:int;
        public var dbSystem:DBSystem;
        public var departmentData:DepartmentData;
    }
}