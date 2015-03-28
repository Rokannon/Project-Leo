package com.rokannon.project.ProjectLeo.view
{
    import com.rokannon.project.ProjectLeo.ApplicationController;
    import com.rokannon.project.ProjectLeo.ApplicationModel;
    import com.rokannon.project.ProjectLeo.command.core.CommandExecutor;
    import com.rokannon.project.ProjectLeo.view.screen.DepartmentsScreen;
    import com.rokannon.project.ProjectLeo.view.screen.EmployeesScreen;
    import com.rokannon.project.ProjectLeo.view.screen.MainMenuScreen;

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

            events = new Object();
            events[MainMenuScreen.EVENT_SHOW_DEPARTMENTS] = appController.goToDepartments;
            _navigator.addScreen(SCREEN_MAIN_MENU, new ScreenNavigatorItem(MainMenuScreen, events, propertiesObject));

            events = new Object();
            events[DepartmentsScreen.EVENT_TO_MAIN_MENU] = appController.goToMainMenu;
            events[DepartmentsScreen.EVENT_SELECT_DEPARTMENT] = onDepartmentSelect;
            events[DepartmentsScreen.EVENT_BROWSE_EMPLOYEES] = appController.goToEmployees;
            _navigator.addScreen(SCREEN_DEPARTMENTS, new ScreenNavigatorItem(DepartmentsScreen, events, propertiesObject));

            events = new Object();
            events[EmployeesScreen.EVENT_TO_DEPARTMENTS] = appController.goToDepartments;
            _navigator.addScreen(SCREEN_EMPLOYEES, new ScreenNavigatorItem(EmployeesScreen, events, propertiesObject));

            addChild(_navigator);
            _navigator.showScreen(SCREEN_MAIN_MENU);
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
    }
}