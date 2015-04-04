package com.rokannon.data
{
    import flash.utils.Dictionary;

    public class DataLibraryManager
    {
        private const _libraryByType:Dictionary = new Dictionary();
        private const _customLibraryByType:Dictionary = new Dictionary();

        public function DataLibraryManager()
        {
        }

        public function addCustomLibrary(library:DataLibrary):void
        {
            _libraryByType[library.dataType] = library;
            _customLibraryByType[library.dataType] = library;
        }

        /**
         * Automatically creates empty library if not found.
         */
        public function getLibraryByType(dataType:String):DataLibrary
        {
            if (_libraryByType[dataType] == null)
                _libraryByType[dataType] = new DataLibrary(dataType);
            return _libraryByType[dataType];
        }

        /**
         * Initializes all libraries.
         * @param json This is expected to be and object with
         * keys as data types and value as json-objects for
         * corresponding data library.
         */
        public function initFromJSON(json:Object):void
        {
            var dataType:String;

            // Init all libs.
            for (dataType in json)
                getLibraryByType(dataType).initFromJSON(json[dataType]);

            // Post init generic libs. Always safe because generic
            // libs can not have cross-dependencies.
            for (dataType in json)
            {
                if (!(dataType in _customLibraryByType))
                    getLibraryByType(dataType).postInit();
            }

            // Post init custom libs. This goes separately so that
            // some libs can access generic libs using dataByName
            // dictionary.
            for (dataType in _customLibraryByType)
                getLibraryByType(dataType).postInit();
        }
    }
}