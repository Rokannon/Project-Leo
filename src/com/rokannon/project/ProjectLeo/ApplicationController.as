package com.rokannon.project.ProjectLeo
{
    import com.rokannon.project.ProjectLeo.command.openDB.OpenDBCommand;
    import com.rokannon.project.ProjectLeo.command.openDB.OpenDBCommandData;
    import com.rokannon.project.ProjectLeo.command.requestDB.DBRequest;
    import com.rokannon.project.ProjectLeo.command.requestDB.DBRequestType;
    import com.rokannon.project.ProjectLeo.command.requestDB.RequestDBCommand;
    import com.rokannon.project.ProjectLeo.command.requestDB.RequestDBCommandData;
    import com.rokannon.project.ProjectLeo.command.selectDepartment.SelectDepartmentCommand;
    import com.rokannon.project.ProjectLeo.command.selectDepartment.SelectDepartmentCommandData;
    import com.rokannon.project.ProjectLeo.command.selectEmployee.SelectEmployeeCommand;
    import com.rokannon.project.ProjectLeo.command.selectEmployee.SelectEmployeeCommandData;
    import com.rokannon.project.ProjectLeo.command.showAlert.ShowAlertCommand;
    import com.rokannon.project.ProjectLeo.command.showAlert.ShowAlertCommandData;
    import com.rokannon.project.ProjectLeo.command.showScreen.ShowScreenCommand;
    import com.rokannon.project.ProjectLeo.command.showScreen.ShowScreenCommandData;
    import com.rokannon.project.ProjectLeo.command.updateDepartments.UpdateDepartmentsCommand;
    import com.rokannon.project.ProjectLeo.command.updateDepartments.UpdateDepartmentsCommandData;
    import com.rokannon.project.ProjectLeo.data.EmployeeData;
    import com.rokannon.project.ProjectLeo.data.tableFieldItem.TableFieldItem;
    import com.rokannon.project.ProjectLeo.system.dataLibrary.table.TableData;
    import com.rokannon.project.ProjectLeo.system.dataLibrary.tableField.TableFieldData;
    import com.rokannon.project.ProjectLeo.system.employeeFilter.enum.FilterContext;
    import com.rokannon.project.ProjectLeo.view.StarlingRoot;

    import flash.data.SQLMode;

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
            var fieldItem:TableFieldItem = new TableFieldItem();
            fieldItem.fieldData = _appModel.appDataSystem.tableFieldDataLibrary.getTableFieldDataByKey("dept_field");
            fieldItem.fieldValue = _appModel.selectedDepartment.departmentId;
            _appModel.employeeFilterSystem.filterItemCollection.removeAllItems();
            _appModel.employeeFilterSystem.filterItemCollection.addItem(fieldItem);
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
            var whereClause:String = _appModel.employeeFilterSystem.createWhereClause();
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
            _appModel.employeeFilterSystem.filterItemCollection.removeAllItems();

            updateDepartments();

            var showScreenCommandData:ShowScreenCommandData = new ShowScreenCommandData();
            showScreenCommandData.navigator = _appModel.screenNavigator;
            showScreenCommandData.screenName = StarlingRoot.SCREEN_SEARCH_EMPLOYEES;
            _appModel.commandExecutor.pushCommand(new ShowScreenCommand(showScreenCommandData));
        }

        public function updateDepartments():void
        {
            var requestDBCommandData:RequestDBCommandData = new RequestDBCommandData();
            requestDBCommandData.dbSystem = _appModel.dbSystem;
            requestDBCommandData.request = new DBRequest(DBRequestType.GET_DEPARTMENTS);
            _appModel.commandExecutor.pushCommand(new RequestDBCommand(requestDBCommandData));

            var updateDepartmentsCommandData:UpdateDepartmentsCommandData = new UpdateDepartmentsCommandData();
            updateDepartmentsCommandData.dbSystem = _appModel.dbSystem;
            updateDepartmentsCommandData.departmentsSystem = _appModel.departmentsSystem;
            _appModel.commandExecutor.pushCommand(new UpdateDepartmentsCommand(updateDepartmentsCommandData));
        }

        public function startBatchUpdate():void
        {
            _appModel.employeeUpdateSystem.updateItemsCollection.removeAllItems();

            var showScreenCommandData:ShowScreenCommandData = new ShowScreenCommandData();
            showScreenCommandData.navigator = _appModel.screenNavigator;
            showScreenCommandData.screenName = StarlingRoot.SCREEN_UPDATE_EMPLOYEES;
            _appModel.commandExecutor.pushCommand(new ShowScreenCommand(showScreenCommandData));
        }

        public function updateEmployees():void
        {
            var whereClause:String = _appModel.employeeFilterSystem.createWhereClause();
            var setClause:String = _appModel.employeeUpdateSystem.createUpdateClause();
            var requestDBCommandData:RequestDBCommandData = new RequestDBCommandData();
            requestDBCommandData.dbSystem = _appModel.dbSystem;
            requestDBCommandData.request = new DBRequest(DBRequestType.UPDATE_EMPLOYEES, setClause, whereClause);
            _appModel.commandExecutor.pushCommand(new RequestDBCommand(requestDBCommandData));

            var showScreenCommandData:ShowScreenCommandData = new ShowScreenCommandData();
            showScreenCommandData.navigator = _appModel.screenNavigator;
            showScreenCommandData.screenName = StarlingRoot.SCREEN_MAIN_MENU;
            _appModel.commandExecutor.pushCommand(new ShowScreenCommand(showScreenCommandData));

            showAlert("Batch update complete.");
        }

        public function createEmptyDatabase():void
        {
            var openDBCommandData:OpenDBCommandData = new OpenDBCommandData();
            openDBCommandData.dbSystem = _appModel.dbSystem;
            openDBCommandData.dbFilename = "_staff.db";
            openDBCommandData.openMode = SQLMode.CREATE;
            _appModel.commandExecutor.pushCommand(new OpenDBCommand(openDBCommandData));

            for each (var tableData:TableData in _appModel.appDataSystem.tableDataLibrary.tableDataArray)
            {
                var requestDBCommandData:RequestDBCommandData = new RequestDBCommandData();
                requestDBCommandData.dbSystem = _appModel.dbSystem;
                requestDBCommandData.request = createTableDBRequest(tableData);
                _appModel.commandExecutor.pushCommand(new RequestDBCommand(requestDBCommandData));
            }
        }

        public function showAlert(message:String):void
        {
            var showAlertCommandData:ShowAlertCommandData = new ShowAlertCommandData();
            showAlertCommandData.alertTitle = "Alert";
            showAlertCommandData.alertMessage = message;
            _appModel.commandExecutor.pushCommand(new ShowAlertCommand(showAlertCommandData));
        }

        private function createTableDBRequest(tableData:TableData):DBRequest
        {
            for (var i:int = 0; i < tableData.tableFields.length; ++i)
            {
                var tableField:TableFieldData = tableData.tableFields[i];
                var tableFieldString:String = tableField.fieldName + " " + tableField.dataType;
                if (tableField.fieldName == tableData.primaryKeyName)
                    tableFieldString += " PRIMARY KEY";
                helperStrings.push(tableFieldString);
            }
            var dbRequest:DBRequest = new DBRequest(DBRequestType.CREATE_TABLE, tableData.tableName,
                                                    helperStrings.join(", "));
            helperStrings.length = 0;
            return dbRequest;
        }
    }
}