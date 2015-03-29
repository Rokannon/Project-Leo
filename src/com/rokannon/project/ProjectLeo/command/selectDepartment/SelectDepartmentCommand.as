package com.rokannon.project.ProjectLeo.command.selectDepartment
{
    import com.rokannon.core.utils.requireProperty;
    import com.rokannon.project.ProjectLeo.command.core.SyncCommand;

    public class SelectDepartmentCommand extends SyncCommand
    {
        private var _data:SelectDepartmentCommandData;

        public function SelectDepartmentCommand(data:SelectDepartmentCommandData)
        {
            super();
            _data = data;
        }

        override protected function doExecute():void
        {
            var object:Object = _data.dbSystem.requestResult.result.data[_data.departmentIndex];
            _data.departmentData.departmentId = requireProperty(object, "DeptID");
            _data.departmentData.departmentName = requireProperty(object, "DeptName");
            _data.departmentData.employeeCount = requireProperty(object, "EmplAmount");
        }
    }
}