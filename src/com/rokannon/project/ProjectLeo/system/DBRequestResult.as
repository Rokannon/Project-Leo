package com.rokannon.project.ProjectLeo.system
{
    import flash.data.SQLResult;

    public class DBRequestResult
    {
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
            result = null;
            errorFlag = false;
            errorMessage = null;
            errorDetails = null;
        }
    }
}