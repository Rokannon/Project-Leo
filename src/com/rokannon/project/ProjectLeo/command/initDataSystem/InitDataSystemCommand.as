package com.rokannon.project.ProjectLeo.command.initDataSystem
{
    import com.rokannon.core.utils.string.trimExtension;
    import com.rokannon.project.ProjectLeo.command.core.AsyncCommand;

    import flash.events.Event;
    import flash.events.FileListEvent;
    import flash.events.IOErrorEvent;
    import flash.filesystem.File;

    public class InitDataSystemCommand extends AsyncCommand
    {
        private const _dataBlob:Object = {};
        private const _filesQueue:Vector.<File> = new <File>[];
        private var _data:InitDataSystemCommandData;
        private var dataDirectory:File;

        public function InitDataSystemCommand(data:InitDataSystemCommandData)
        {
            super();
            _data = data;
        }

        override public function execute():void
        {
            dataDirectory = File.applicationDirectory.resolvePath("data");
            dataDirectory.addEventListener(IOErrorEvent.IO_ERROR, onDirectoryListingError);
            dataDirectory.addEventListener(FileListEvent.DIRECTORY_LISTING, onDirectoryListingComplete);
            dataDirectory.getDirectoryListingAsync();
        }

        private function loadNextFile():void
        {
            var file:File = _filesQueue.pop();
            file.addEventListener(Event.COMPLETE, onFileLoadComplete);
            file.addEventListener(IOErrorEvent.IO_ERROR, onFileLoadError);
            file.load();
        }

        private function onFileLoadError(event:IOErrorEvent):void
        {
            var file:File = event.target as File;
            file.removeEventListener(Event.COMPLETE, onFileLoadComplete);
            file.removeEventListener(IOErrorEvent.IO_ERROR, onFileLoadError);
            _data.appDataSystem.eventInitError.broadcast();
            _eventComplete.broadcast();
        }

        private function onFileLoadComplete(event:Event):void
        {
            var file:File = event.target as File;
            file.removeEventListener(Event.COMPLETE, onFileLoadComplete);
            file.removeEventListener(IOErrorEvent.IO_ERROR, onFileLoadError);
            var dataType:String = trimExtension(file.name);
            _dataBlob[dataType] = JSON.parse(file.data.toString());
            if (_filesQueue.length == 0)
                initDataSystem();
            else
                loadNextFile();
        }

        private function initDataSystem():void
        {
            _data.appDataSystem.initFromJSON(_dataBlob);
            _eventComplete.broadcast();
        }

        private function onDirectoryListingError(event:IOErrorEvent):void
        {
            dataDirectory.removeEventListener(IOErrorEvent.IO_ERROR, onDirectoryListingError);
            dataDirectory.removeEventListener(FileListEvent.DIRECTORY_LISTING, onDirectoryListingComplete);
            _data.appDataSystem.eventInitError.broadcast();
            _eventComplete.broadcast();
        }

        private function onDirectoryListingComplete(event:FileListEvent):void
        {
            dataDirectory.removeEventListener(IOErrorEvent.IO_ERROR, onDirectoryListingError);
            dataDirectory.removeEventListener(FileListEvent.DIRECTORY_LISTING, onDirectoryListingComplete);
            for each (var file:File in event.files)
                _filesQueue.push(file);
            if (_filesQueue.length == 0)
                initDataSystem();
            else
                loadNextFile();
        }
    }
}