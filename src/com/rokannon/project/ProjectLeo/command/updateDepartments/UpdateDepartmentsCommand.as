package com.rokannon.project.ProjectLeo.command.updateDepartments
{
    import com.rokannon.project.ProjectLeo.command.core.SyncCommand;
    import com.rokannon.project.ProjectLeo.command.selectDepartment.SelectDepartmentCommand;
    import com.rokannon.project.ProjectLeo.command.selectDepartment.SelectDepartmentCommandData;
    import com.rokannon.project.ProjectLeo.data.DepartmentData;

    public class UpdateDepartmentsCommand extends SyncCommand
    {
        private var _data:UpdateDepartmentsCommandData;

        public function UpdateDepartmentsCommand(data:UpdateDepartmentsCommandData)
        {
            super();
            _data = data;
        }

        override protected function doExecute():void
        {
            _data.departmentsSystem.removeAllDepartments();
            var numDepartments:int = _data.dbSystem.requestResult.result.data.length;
            for (var i:int = 0; i < numDepartments; ++i)
            {
                var departmentData:DepartmentData = new DepartmentData();
                var selectDepartmentCommandData:SelectDepartmentCommandData = new SelectDepartmentCommandData();
                selectDepartmentCommandData.dbSystem = _data.dbSystem;
                selectDepartmentCommandData.departmentData = departmentData;
                selectDepartmentCommandData.departmentIndex = i;
                new SelectDepartmentCommand(selectDepartmentCommandData).execute();
                _data.departmentsSystem.addDepartment(departmentData);
            }
        }
    }
}