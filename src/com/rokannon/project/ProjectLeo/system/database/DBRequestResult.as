package com.rokannon.project.ProjectLeo.system.database
{
    import com.rokannon.project.ProjectLeo.command.requestDB.DBRequest;

    import flash.data.SQLResult;

    public class DBRequestResult
    {
        public var request:DBRequest;
        public var result:SQLResult;
        public var errorFlag:Boolean;
        public var errorMessage:String;
        public var errorDetails:String;

        public function DBRequestResult()
        {
            clearRequest();
        }

        public function clearRequest():void
        {
            request = null;
            result = null;
            errorFlag = false;
            errorMessage = null;
            errorDetails = null;
        }
    }
}