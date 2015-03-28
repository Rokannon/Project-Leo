package com.rokannon.project.ProjectLeo.view
{
    import com.rokannon.project.ProjectLeo.ApplicationController;
    import com.rokannon.project.ProjectLeo.ApplicationModel;
    import com.rokannon.project.ProjectLeo.command.core.CommandExecutor;
    import com.rokannon.project.ProjectLeo.view.screen.DepartmentsScreen;
    import com.rokannon.project.ProjectLeo.view.screen.MainMenuScreen;

    import feathers.controls.Label;
    import feathers.controls.ScreenNavigator;
    import feathers.controls.ScreenNavigatorItem;
    import feathers.core.PopUpManager;
    import feathers.themes.MetalWorksDesktopTheme;

    import starling.display.Sprite;

    public class StarlingRoot extends Sprite
    {
        public static const SCREEN_MAIN_MENU:String = "screenMainMenu";
        public static const SCREEN_DEPARTMENTS:String = "screenDepartments";

        private var _navigator:ScreenNavigator;
        private var _workingLabel:Label;
        private var _workingPopupAdded:Boolean = false;

        public function StarlingRoot()
        {
            super();
        }

        public function startApplication(appModel:ApplicationModel, appController:ApplicationController):void
        {
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
            _navigator.addScreen(SCREEN_MAIN_MENU, new ScreenNavigatorItem(MainMenuScreen, events));

            events = new Object();
            events[DepartmentsScreen.EVENT_TO_MAIN_MENU] = appController.goToMainMenu;
            _navigator.addScreen(SCREEN_DEPARTMENTS, new ScreenNavigatorItem(DepartmentsScreen, events, propertiesObject));

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
    }
}