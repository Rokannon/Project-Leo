package com.rokannon.project.ProjectLeo.command.showAlert
{
    import com.rokannon.project.ProjectLeo.command.core.SyncCommand;

    import feathers.controls.Alert;
    import feathers.data.ListCollection;

    public class ShowAlertCommand extends SyncCommand
    {
        private var _data:ShowAlertCommandData;

        public function ShowAlertCommand(data:ShowAlertCommandData)
        {
            super();
            _data = data;
        }

        override protected function doExecute():void
        {
            var buttonList:ListCollection = new ListCollection([{label: "OK"}]);
            Alert.show(_data.alertMessage, _data.alertTitle, buttonList);
        }
    }
}