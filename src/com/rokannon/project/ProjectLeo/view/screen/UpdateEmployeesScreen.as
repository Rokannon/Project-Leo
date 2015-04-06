package com.rokannon.project.ProjectLeo.view.screen
{
    import com.rokannon.project.ProjectLeo.data.tableFieldItem.TableFieldCollection;
    import com.rokannon.project.ProjectLeo.system.dataLibrary.tableField.TableFieldData;

    public class UpdateEmployeesScreen extends TableFieldCollectionEditScreen
    {
        override protected function getFreeFields(resultFields:Vector.<TableFieldData> = null):Vector.<TableFieldData>
        {
            return appModel.employeeUpdateSystem.getUnupdatedFields(resultFields);
        }

        override protected function getTableFieldCollection():TableFieldCollection
        {
            return appModel.employeeUpdateSystem.updateItemsCollection;
        }

        override protected function getHeaderTitle():String
        {
            return "Set Fields to Update";
        }

        override protected function getOkButtonLabel():String
        {
            return "Update";
        }

        override protected function getCancelButtonLabel():String
        {
            return "Cancel";
        }
    }
}