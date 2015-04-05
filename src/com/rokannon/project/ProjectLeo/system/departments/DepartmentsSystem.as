package com.rokannon.project.ProjectLeo.system.departments
{
    import com.rokannon.core.utils.clearDictionary;
    import com.rokannon.project.ProjectLeo.data.DepartmentData;

    import flash.utils.Dictionary;

    public class DepartmentsSystem
    {
        public const departments:Vector.<DepartmentData> = new <DepartmentData>[];
        public const departmentByDepartmentId:Dictionary = new Dictionary();

        public function DepartmentsSystem()
        {
        }

        public function addDepartment(departmentData:DepartmentData):void
        {
            var index:int = departments.indexOf(departmentData);
            if (index != -1)
                return;
            departments.push(departmentData);
            departmentByDepartmentId[departmentData.departmentId] = departmentData;
        }

        public function removeAllDepartments():void
        {
            departments.length = 0;
            clearDictionary(departmentByDepartmentId);
        }
    }
}