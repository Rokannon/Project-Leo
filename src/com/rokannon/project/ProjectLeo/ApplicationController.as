package com.rokannon.project.ProjectLeo
{
    import com.rokannon.project.ProjectLeo.command.requestDB.DBRequest;
    import com.rokannon.project.ProjectLeo.command.requestDB.DBRequestType;
    import com.rokannon.project.ProjectLeo.command.requestDB.RequestDBCommand;
    import com.rokannon.project.ProjectLeo.command.requestDB.RequestDBCommandData;
    import com.rokannon.project.ProjectLeo.command.selectDepartment.SelectDepartmentCommand;
    import com.rokannon.project.ProjectLeo.command.selectDepartment.SelectDepartmentCommandData;
    import com.rokannon.project.ProjectLeo.command.showScreen.ShowScreenCommand;
    import com.rokannon.project.ProjectLeo.command.showScreen.ShowScreenCommandData;
    import com.rokannon.project.ProjectLeo.data.EmployeeData;
    import com.rokannon.project.ProjectLeo.view.StarlingRoot;

    public class ApplicationController
    {
        private var _appModel:ApplicationModel;

        public function ApplicationController()
        {
        }

        public function connect(appModel:ApplicationModel):void
        {
            _appModel = appModel;
        }

        public function goToDepartments():void
        {
            var requestDBCommandData:RequestDBCommandData = new RequestDBCommandData();
            requestDBCommandData.dbSystem = _appModel.dbSystem;
            requestDBCommandData.request = new DBRequest(DBRequestType.DEPARTMENTS);
            _appModel.commandExecutor.pushCommand(new RequestDBCommand(requestDBCommandData));

            //var traceDBResultCommandData:TraceDBResultCommandData = new TraceDBResultCommandData();
            //traceDBResultCommandData.dbSystem = _appModel.dbSystem;
            //_appModel.commandExecutor.pushCommand(new TraceDBResultCommand(traceDBResultCommandData));

            var showScreenCommandData:ShowScreenCommandData = new ShowScreenCommandData();
            showScreenCommandData.navigator = _appModel.screenNavigator;
            showScreenCommandData.screenName = StarlingRoot.SCREEN_DEPARTMENTS;
            _appModel.commandExecutor.pushCommand(new ShowScreenCommand(showScreenCommandData));
        }

        public function goToMainMenu():void
        {
            var showScreenCommandData:ShowScreenCommandData = new ShowScreenCommandData();
            showScreenCommandData.navigator = _appModel.screenNavigator;
            showScreenCommandData.screenName = StarlingRoot.SCREEN_MAIN_MENU;
            _appModel.commandExecutor.pushCommand(new ShowScreenCommand(showScreenCommandData));
        }

        public function selectDepartment(departmentIndex:int):void
        {
            var selectDepartmentCommandData:SelectDepartmentCommandData = new SelectDepartmentCommandData();
            selectDepartmentCommandData.dbSystem = _appModel.dbSystem;
            selectDepartmentCommandData.departmentData = _appModel.selectedDepartment;
            selectDepartmentCommandData.departmentIndex = departmentIndex;
            _appModel.commandExecutor.pushCommand(new SelectDepartmentCommand(selectDepartmentCommandData));
        }

        public function goToEmployees():void
        {
            var requestDBCommandData:RequestDBCommandData = new RequestDBCommandData();
            requestDBCommandData.dbSystem = _appModel.dbSystem;
            requestDBCommandData.request = new DBRequest(DBRequestType.EMPLOYEES,
                                                         _appModel.selectedDepartment.departmentId);
            _appModel.commandExecutor.pushCommand(new RequestDBCommand(requestDBCommandData));

            var showScreenCommandData:ShowScreenCommandData = new ShowScreenCommandData();
            showScreenCommandData.navigator = _appModel.screenNavigator;
            showScreenCommandData.screenName = StarlingRoot.SCREEN_EMPLOYEES;
            _appModel.commandExecutor.pushCommand(new ShowScreenCommand(showScreenCommandData));
        }

        public function createDepartment(departmentName:String):void
        {
            var requestDBCommandData:RequestDBCommandData = new RequestDBCommandData();
            requestDBCommandData.dbSystem = _appModel.dbSystem;
            requestDBCommandData.request = new DBRequest(DBRequestType.ADD_DEPARTMENT, departmentName);
            _appModel.commandExecutor.pushCommand(new RequestDBCommand(requestDBCommandData));
        }

        public function deleteSelectedDepartment():void
        {
            var requestDBCommandData:RequestDBCommandData;

            requestDBCommandData = new RequestDBCommandData();
            requestDBCommandData.dbSystem = _appModel.dbSystem;
            requestDBCommandData.request = new DBRequest(DBRequestType.REMOVE_DEPARTMENT,
                                                         _appModel.selectedDepartment.departmentId);
            _appModel.commandExecutor.pushCommand(new RequestDBCommand(requestDBCommandData));

            requestDBCommandData = new RequestDBCommandData();
            requestDBCommandData.dbSystem = _appModel.dbSystem;
            requestDBCommandData.request = new DBRequest(DBRequestType.REMOVE_EMPLOYEES_BY_DEPARTMENT,
                                                         _appModel.selectedDepartment.departmentId);
            _appModel.commandExecutor.pushCommand(new RequestDBCommand(requestDBCommandData));
        }

        public function hireEmployeeToSelectedDepartment(employeeData:EmployeeData):void
        {
            var requestDBCommandData:RequestDBCommandData = new RequestDBCommandData();
            requestDBCommandData.dbSystem = _appModel.dbSystem;
            requestDBCommandData.request = new DBRequest(DBRequestType.HIRE_EMPLOYEE, employeeData.employeeFirstName,
                                                         employeeData.employeeLastName, employeeData.departmentId,
                                                         employeeData.employeePosition);
            _appModel.commandExecutor.pushCommand(new RequestDBCommand(requestDBCommandData));
        }
    }
}