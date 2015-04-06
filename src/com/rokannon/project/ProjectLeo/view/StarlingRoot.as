package com.rokannon.project.ProjectLeo.view
{
    import com.rokannon.project.ProjectLeo.ApplicationController;
    import com.rokannon.project.ProjectLeo.ApplicationModel;
    import com.rokannon.project.ProjectLeo.command.core.CommandExecutor;
    import com.rokannon.project.ProjectLeo.data.EmployeeData;
    import com.rokannon.project.ProjectLeo.system.database.DBSystem;
    import com.rokannon.project.ProjectLeo.view.screen.DepartmentsScreen;
    import com.rokannon.project.ProjectLeo.view.screen.EmployeesScreen;
    import com.rokannon.project.ProjectLeo.view.screen.HireEmployeeScreen;
    import com.rokannon.project.ProjectLeo.view.screen.MainMenuScreen;
    import com.rokannon.project.ProjectLeo.view.screen.NewDepartmentScreen;
    import com.rokannon.project.ProjectLeo.view.screen.SearchEmployeesScreen;
    import com.rokannon.project.ProjectLeo.view.screen.TableFieldCollectionEditScreen;
    import com.rokannon.project.ProjectLeo.view.screen.UpdateEmployeesScreen;

    import feathers.controls.Label;
    import feathers.controls.ScreenNavigator;
    import feathers.controls.ScreenNavigatorItem;
    import feathers.core.PopUpManager;
    import feathers.themes.MetalWorksDesktopTheme;

    import starling.display.Sprite;
    import starling.events.Event;

    public class StarlingRoot extends Sprite
    {
        public static const SCREEN_MAIN_MENU:String = "screenMainMenu";
        public static const SCREEN_DEPARTMENTS:String = "screenDepartments";
        public static const SCREEN_EMPLOYEES:String = "screenEmployees";
        public static const SCREEN_NEW_DEPARTMENT:String = "screenNewDepartment";
        public static const SCREEN_HIRE_EMPLOYEE:String = "screenHireEmployee";
        public static const SCREEN_SEARCH_EMPLOYEES:String = "screenSearchEmployees";
        public static const SCREEN_UPDATE_EMPLOYEES:String = "screenUpdateEmployees";

        private var _navigator:ScreenNavigator;
        private var _workingLabel:Label;
        private var _workingPopupAdded:Boolean = false;
        private var _appModel:ApplicationModel;
        private var _appController:ApplicationController;

        public function StarlingRoot()
        {
            super();
        }

        public function startApplication(appModel:ApplicationModel, appController:ApplicationController):void
        {
            _appModel = appModel;
            _appController = appController;

            var events:Object;
            new MetalWorksDesktopTheme();
            _navigator = new ScreenNavigator();

            appModel.screenNavigator = _navigator;

            _workingLabel = new Label();
            _workingLabel.text = "Working...";

            appModel.commandExecutor.eventExecuteStart.add(onExecuteStart);
            appModel.commandExecutor.eventExecuteEnd.add(onExecuteEnd);

            var propertiesObject:Object = {
                appModel: appModel
            };

            events = {};
            events[MainMenuScreen.EVENT_SHOW_DEPARTMENTS] = appController.goToDepartments;
            events[MainMenuScreen.EVENT_SEARCH_EMPLOYEES] = appController.startNewSearch;
            _navigator.addScreen(SCREEN_MAIN_MENU, new ScreenNavigatorItem(MainMenuScreen, events, propertiesObject));

            events = {};
            events[DepartmentsScreen.EVENT_TO_MAIN_MENU] = SCREEN_MAIN_MENU;
            events[DepartmentsScreen.EVENT_SELECT_DEPARTMENT] = onDepartmentSelect;
            events[DepartmentsScreen.EVENT_BROWSE_EMPLOYEES] = appController.goToEmployeesOfSelectedDepartment;
            events[DepartmentsScreen.EVENT_NEW_DEPARTMENT] = SCREEN_NEW_DEPARTMENT;
            events[DepartmentsScreen.EVENT_DELETE_DEPARTMENT] = onDepartmentDelete;
            _navigator.addScreen(SCREEN_DEPARTMENTS,
                                 new ScreenNavigatorItem(DepartmentsScreen, events, propertiesObject));

            events = {};
            events[EmployeesScreen.EVENT_TO_DEPARTMENTS] = appController.goToDepartments;
            events[EmployeesScreen.EVENT_TO_FILTER] = SCREEN_SEARCH_EMPLOYEES;
            events[EmployeesScreen.EVENT_TO_MAIN_MENU] = SCREEN_MAIN_MENU;
            events[EmployeesScreen.EVENT_HIRE_EMPLOYEE] = SCREEN_HIRE_EMPLOYEE;
            events[EmployeesScreen.EVENT_FIRE_EMPLOYEE] = onEmployeeFire;
            events[EmployeesScreen.EVENT_SELECT_EMPLOYEE] = onEmployeeSelect;
            events[EmployeesScreen.EVENT_BATCH_UPDATE] = appController.startBatchUpdate;
            _navigator.addScreen(SCREEN_EMPLOYEES, new ScreenNavigatorItem(EmployeesScreen, events, propertiesObject));

            events = {};
            events[NewDepartmentScreen.EVENT_CANCEL] = appController.goToDepartments;
            events[NewDepartmentScreen.EVENT_CREATE] = onDepartmentCreate;
            _navigator.addScreen(SCREEN_NEW_DEPARTMENT,
                                 new ScreenNavigatorItem(NewDepartmentScreen, events, propertiesObject));

            events = {};
            events[HireEmployeeScreen.EVENT_CANCEL] = appController.goToEmployeesOfSelectedDepartment;
            events[HireEmployeeScreen.EVENT_HIRE] = onEmployeeHire;
            _navigator.addScreen(SCREEN_HIRE_EMPLOYEE,
                                 new ScreenNavigatorItem(HireEmployeeScreen, events, propertiesObject));

            events = {};
            events[TableFieldCollectionEditScreen.EVENT_CANCEL] = SCREEN_MAIN_MENU;
            events[TableFieldCollectionEditScreen.EVENT_OK] = appController.goToEmployeesFiltered;
            _navigator.addScreen(SCREEN_SEARCH_EMPLOYEES,
                                 new ScreenNavigatorItem(SearchEmployeesScreen, events, propertiesObject));

            events = {};
            events[TableFieldCollectionEditScreen.EVENT_CANCEL] = onUpdateEmployeesCancel;
            events[TableFieldCollectionEditScreen.EVENT_OK] = appController.updateEmployees;
            _navigator.addScreen(SCREEN_UPDATE_EMPLOYEES,
                                 new ScreenNavigatorItem(UpdateEmployeesScreen, events, propertiesObject));

            addChild(_navigator);
            _navigator.showScreen(SCREEN_MAIN_MENU);

            _appModel.dbSystem.eventDatabaseOpenError.add(onDatabaseOpenError);
        }

        private function onDatabaseOpenError(dbSystem:DBSystem):void
        {
            _appController.createEmptyDatabase();
            _appController.showAlert("Application was unable to find and open database file.\nEmpty database was created.");
        }

        private function onExecuteStart(executor:CommandExecutor):void
        {
            if (_workingPopupAdded)
                return;
            _workingPopupAdded = true;
            PopUpManager.addPopUp(_workingLabel);
        }

        private function onExecuteEnd(executor:CommandExecutor):void
        {
            if (!_workingPopupAdded)
                return;
            _workingPopupAdded = false;
            PopUpManager.removePopUp(_workingLabel, false);
        }

        private function onDepartmentSelect(event:Event):void
        {
            _appController.selectDepartment(int(event.data));
        }

        private function onDepartmentCreate(event:Event):void
        {
            _appController.createDepartment(event.data as String);
            _appController.goToDepartments();
        }

        private function onDepartmentDelete(event:Event):void
        {
            _appController.deleteSelectedDepartment();
            _appController.goToDepartments();
        }

        private function onEmployeeHire(event:Event):void
        {
            var employeeData:EmployeeData = event.data as EmployeeData;
            _appController.hireEmployee(employeeData);
            _appController.goToEmployees();
        }

        private function onEmployeeFire(event:Event):void
        {
            _appController.fireSelectedEmployee();
            _appController.goToEmployees();
        }

        private function onEmployeeSelect(event:Event):void
        {
            _appController.selectEmployee(int(event.data));
        }

        private function onUpdateEmployeesCancel(event:Event):void
        {
            _appController.goToEmployees();
        }
    }
}