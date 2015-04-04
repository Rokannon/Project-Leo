package com.rokannon.project.ProjectLeo.system.dataLibrary
{
    import com.rokannon.data.DataLibrary;

    public class ApplicationDataLibrary extends DataLibrary
    {
        protected var _dataSystem:ApplicationDataSystem;

        public function ApplicationDataLibrary(dataType:String)
        {
            super(dataType);
        }

        override public function initFromJSON(json:Object):void
        {
            for (var key:String in json)
                _jsonByName[key] = json[key];
        }

        public function connect(dataSystem:ApplicationDataSystem):void
        {
            _dataSystem = dataSystem;
        }
    }
}