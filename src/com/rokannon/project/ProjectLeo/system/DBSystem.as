package com.rokannon.project.ProjectLeo.system
{
    import flash.data.SQLConnection;

    public class DBSystem
    {
        public const connection:SQLConnection = new SQLConnection();
        public const requestResult:DBRequestResult = new DBRequestResult();

        public function DBSystem()
        {
        }
    }
}