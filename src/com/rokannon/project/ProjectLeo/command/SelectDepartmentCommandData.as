package com.rokannon.project.ProjectLeo.command
{
    import com.rokannon.project.ProjectLeo.data.DepartmentData;
    import com.rokannon.project.ProjectLeo.system.DBSystem;

    public class SelectDepartmentCommandData
    {
        public var departmentIndex:int;
        public var dbSystem:DBSystem;
        public var departmentData:DepartmentData;
    }
}