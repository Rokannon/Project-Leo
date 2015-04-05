package com.rokannon.project.ProjectLeo
{
    import com.rokannon.core.utils.string.stringFormat;
    import com.rokannon.project.ProjectLeo.command.requestDB.DBRequest;
    import com.rokannon.project.ProjectLeo.command.requestDB.DBRequestType;
    import com.rokannon.project.ProjectLeo.command.requestDB.RequestDBCommand;
    import com.rokannon.project.ProjectLeo.command.requestDB.RequestDBCommandData;
    import com.rokannon.project.ProjectLeo.command.selectDepartment.SelectDepartmentCommand;
    import com.rokannon.project.ProjectLeo.command.selectDepartment.SelectDepartmentCommandData;
    import com.rokannon.project.ProjectLeo.command.selectEmployee.SelectEmployeeCommand;
    import com.rokannon.project.ProjectLeo.command.selectEmployee.SelectEmployeeCommandData;
    import com.rokannon.project.ProjectLeo.command.showScreen.ShowScreenCommand;
    import com.rokannon.project.ProjectLeo.command.showScreen.ShowScreenCommandData;
    import com.rokannon.project.ProjectLeo.data.EmployeeData;
    import com.rokannon.project.ProjectLeo.system.employeeFilter.EmployeeFilterItem;
    import com.rokannon.project.ProjectLeo.system.employeeFilter.enum.FilterContext;
    import com.rokannon.project.ProjectLeo.view.StarlingRoot;

    public class ApplicationController
    {
        private static const helperStrings:Vector.<String> = new <String>[];

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

        public function selectDepartment(departmentIndex:int):void
        {
            var selectDepartmentCommandData:SelectDepartmentCommandData = new SelectDepartmentCommandData();
            selectDepartmentCommandData.dbSystem = _appModel.dbSystem;
            selectDepartmentCommandData.departmentData = _appModel.selectedDepartment;
            selectDepartmentCommandData.departmentIndex = departmentIndex;
            _appModel.commandExecutor.pushCommand(new SelectDepartmentCommand(selectDepartmentCommandData));
        }

        public function goToEmployeesOfSelectedDepartment():void
        {
            var filterItem:EmployeeFilterItem = new EmployeeFilterItem();
            filterItem.fieldData = _appModel.appDataSystem.tableFieldDataLibrary.getTableFieldDataByKey("dept_field");
            filterItem.filterValue = _appModel.selectedDepartment.departmentId;
            _appModel.employeeFilterSystem.removeAllFilterItems();
            _appModel.employeeFilterSystem.addFilterItem(filterItem);
            goToEmployees(FilterContext.DEPARTMENT);
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

        public function hireEmployee(employeeData:EmployeeData):void
        {
            var requestDBCommandData:RequestDBCommandData = new RequestDBCommandData();
            requestDBCommandData.dbSystem = _appModel.dbSystem;
            requestDBCommandData.request = new DBRequest(DBRequestType.HIRE_EMPLOYEE, employeeData.employeeFirstName,
                                                         employeeData.employeeLastName, employeeData.departmentId,
                                                         employeeData.employeePosition);
            _appModel.commandExecutor.pushCommand(new RequestDBCommand(requestDBCommandData));
        }

        public function selectEmployee(employeeIndex:int):void
        {
            var selectEmployeeCommandData:SelectEmployeeCommandData = new SelectEmployeeCommandData();
            selectEmployeeCommandData.employeeIndex = employeeIndex;
            selectEmployeeCommandData.dbSystem = _appModel.dbSystem;
            selectEmployeeCommandData.employeeData = _appModel.selectedEmployee;
            _appModel.commandExecutor.pushCommand(new SelectEmployeeCommand(selectEmployeeCommandData));
        }

        public function fireSelectedEmployee():void
        {
            var requestDBCommandData:RequestDBCommandData = new RequestDBCommandData();
            requestDBCommandData.dbSystem = _appModel.dbSystem;
            requestDBCommandData.request = new DBRequest(DBRequestType.FIRE_EMPLOYEE,
                                                         _appModel.selectedEmployee.employeeId);
            _appModel.commandExecutor.pushCommand(new RequestDBCommand(requestDBCommandData));
        }

        public function goToEmployeesFiltered():void
        {
            goToEmployees(FilterContext.CUSTOM_FILTER);
        }

        public function goToEmployees(filterContext:String = null):void
        {
            if (filterContext != null)
                _appModel.employeeFilterSystem.filterContext = filterContext;
            var filterItems:Vector.<EmployeeFilterItem> = _appModel.employeeFilterSystem.filterItems;
            for (var i:int = 0; i < filterItems.length; ++i)
            {
                var filterItem:EmployeeFilterItem = filterItems[i];
                var conditionTemplate = filterItem.fieldData.dataType == "integer" ? "{0}={1}" : "{0}='{1}'";
                helperStrings.push(stringFormat(conditionTemplate, filterItem.fieldData.fieldName,
                                                filterItem.filterValue));
            }
            var whereClause:String = helperStrings.join(" AND ");
            helperStrings.length = 0;
            var requestDBCommandData:RequestDBCommandData = new RequestDBCommandData();
            requestDBCommandData.dbSystem = _appModel.dbSystem;
            requestDBCommandData.request = new DBRequest(DBRequestType.EMPLOYEES, whereClause);
            _appModel.commandExecutor.pushCommand(new RequestDBCommand(requestDBCommandData));

            var showScreenCommandData:ShowScreenCommandData = new ShowScreenCommandData();
            showScreenCommandData.navigator = _appModel.screenNavigator;
            showScreenCommandData.screenName = StarlingRoot.SCREEN_EMPLOYEES;
            _appModel.commandExecutor.pushCommand(new ShowScreenCommand(showScreenCommandData));
        }

        public function startNewSearch():void
        {
            _appModel.employeeFilterSystem.removeAllFilterItems();

            var showScreenCommandData:ShowScreenCommandData = new ShowScreenCommandData();
            showScreenCommandData.navigator = _appModel.screenNavigator;
            showScreenCommandData.screenName = StarlingRoot.SCREEN_SEARCH_EMPLOYEES;
            _appModel.commandExecutor.pushCommand(new ShowScreenCommand(showScreenCommandData));
        }
    }
}