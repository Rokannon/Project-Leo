package com.rokannon.project.ProjectLeo.system
{
    import com.rokannon.core.Broadcaster;

    import flash.data.SQLConnection;

    public class DBSystem
    {
        public const eventRequestComplete:Broadcaster = new Broadcaster(this);
        public const connection:SQLConnection = new SQLConnection();
        public const requestResult:DBRequestResult = new DBRequestResult();

        public function DBSystem()
        {
        }
    }
}