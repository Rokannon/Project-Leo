package com.rokannon.project.ProjectLeo.view.screen
{
    import com.rokannon.project.ProjectLeo.data.tableFieldItem.TableFieldCollection;
    import com.rokannon.project.ProjectLeo.system.dataLibrary.tableField.TableFieldData;

    public class SearchEmployeesScreen extends TableFieldCollectionEditScreen
    {
        override protected function getFreeFields(resultFields:Vector.<TableFieldData> = null):Vector.<TableFieldData>
        {
            return appModel.employeeFilterSystem.getUnfilteredFields(resultFields);
        }

        override protected function getTableFieldCollection():TableFieldCollection
        {
            return appModel.employeeFilterSystem.filterItemCollection;
        }

        override protected function getHeaderTitle():String
        {
            return "Create Search Query";
        }

        override protected function getCancelButtonLabel():String
        {
            return "To Main Menu";
        }

        override protected function getOkButtonLabel():String
        {
            return "Search";
        }
    }
}