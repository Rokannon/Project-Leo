package com.rokannon.project.ProjectLeo.command.selectEmployee
{
    import com.rokannon.core.utils.requireProperty;
    import com.rokannon.project.ProjectLeo.command.core.SyncCommand;

    public class SelectEmployeeCommand extends SyncCommand
    {
        private var _data:SelectEmployeeCommandData;

        public function SelectEmployeeCommand(data:SelectEmployeeCommandData)
        {
            super();
            _data = data;
        }

        override protected function doExecute():void
        {
            var object:Object = _data.dbSystem.requestResult.result.data[_data.employeeIndex];
            _data.employeeData.employeeId = requireProperty(object, "EmplID");
            _data.employeeData.departmentId = requireProperty(object, "DeptID");
            _data.employeeData.employeeFirstName = requireProperty(object, "FirstName");
            _data.employeeData.employeeLastName = requireProperty(object, "LastName");
            _data.employeeData.employeePosition = requireProperty(object, "Position");
        }
    }
}