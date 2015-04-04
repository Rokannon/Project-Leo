package com.rokannon.project.ProjectLeo.system.dataLibrary
{
    import com.rokannon.core.Broadcaster;
    import com.rokannon.data.DataLibraryManager;
    import com.rokannon.project.ProjectLeo.system.dataLibrary.table.TableDataLibrary;
    import com.rokannon.project.ProjectLeo.system.dataLibrary.tableField.TableFieldDataLibrary;

    public class ApplicationDataSystem
    {
        public const eventInitComplete:Broadcaster = new Broadcaster(this);
        public const eventInitError:Broadcaster = new Broadcaster(this);

        public const tableDataLibrary:TableDataLibrary = new TableDataLibrary();
        public const tableFieldDataLibrary:TableFieldDataLibrary = new TableFieldDataLibrary();

        private const _libraries:Vector.<ApplicationDataLibrary> = new <ApplicationDataLibrary>[];
        private const _libraryManager:DataLibraryManager = new DataLibraryManager();

        public function ApplicationDataSystem()
        {
            // Order is not important.

            registerLibrary(tableDataLibrary);
            registerLibrary(tableFieldDataLibrary);
        }

        private function registerLibrary(library:ApplicationDataLibrary):void
        {
            library.connect(this);
            _libraries.push(library);
            _libraryManager.addCustomLibrary(library);
        }

        public function initFromJSON(json:Object):void
        {
            _libraryManager.initFromJSON(json);
        }
    }
}