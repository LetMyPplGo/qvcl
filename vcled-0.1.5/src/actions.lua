require "vcl"

mainActions = VCL.ActionList()

local mainActions,mainImages=mainActions,mainImages

module "Actions"

mainActions.Images = mainImages
mainActions:LoadFromTable({

	-- file
	{name="fileNewAction", hint="New Lua script", caption="New", shortcut="Ctrl+N", imageIndex=2, onexecute="File.New" },
	{name="fileOpenAction", hint="Open Lua script", caption="&Open...", shortcut="Ctrl+O", imageIndex=3, onexecute="File.Open" },
	{name="fileSaveAction", hint="Save Lua script", caption="&Save", shortcut="Ctrl+S", imageIndex=4, onexecute="File.Save" },
	{name="fileSaveAsAction", hint="Save Lua script as", caption="Save &as...", shortcut="Ctrl+Alt+S", imageIndex=5, onexecute="File.SaveAs" },
	{name="fileSaveAllAction", hint="Save all opened Lua scripts", caption="Save all", shortcut="Ctrl+Shift+S", imageIndex=6, onexecute="File.SaveAll" },
	{name="fileCloseAction", hint="Close Lua script", caption="&Close", shortcut="Ctrl+W", imageIndex=7, onexecute="File.Close" },
	{name="fileCloseAllAction", hint="Close all opened Lua scripts", caption="Close all", imageIndex=8, onexecute="File.CloseAll" },
	
	{name="fileCloseAllButMeAction", hint="Close all but not this page", caption="Close all but me", onexecute="File.CloseAllButMe" },
	
	{name="filePrintAction", hint="Print Lua script", caption="&Print", shortcut="Ctrl+P", imageIndex=9, onexecute="File.Print" },
	{name="fileExitAction", hint="Exit editor", caption="&Exit", shortcut="Alt+F4", imageIndex = 10, onexecute="File.Exit" },
	
    {name="optionsShowPreferences", caption="Preferences...", imageindex=21, onexecute="Preferences.Show"},	
	
	-- edit
	{name="editCopyAction", hint="Copy", caption="Copy", shortcut="Ctrl+C", imageIndex=11,onexecute="Edit.Copy"},
	{name="editCutAction", hint="Cut", caption="Cut", shortcut="Ctrl+X", imageIndex=12,onexecute="Edit.Cut"},
	{name="editPasteAction", hint="Paste", caption="Paste", shortcut="Ctrl+V", imageIndex=13,onexecute="Edit.Paste"},
	{name="editUndoAction", hint="Undo", caption="Undo", shortcut="Ctrl+Z", imageIndex=14,onexecute="Edit.Undo"},
	{name="editRedoAction", hint="Redo", caption="Redo", shortcut="Ctrl+Y", imageIndex=15,onexecute="Edit.Redo"},	
	{name="editFindAction", hint="Find text", caption="Find...", shortcut="Ctrl+F", imageIndex=16, onexecute="Edit.Find"},
	{name="editFindNextAction", hint="Find next occurence", caption="Find Next", shortcut="F3", imageIndex=17, onexecute="Edit.FindNext"},
	{name="editFindPrevAction", hint="Find previous occurence", caption="Find Previous", shortcut="Shift+F3", imageIndex=18, onexecute="Edit.FindPrev"},
	{name="editReplaceAction", hint="Replace text", caption="Replace...", shortcut="Ctrl+R", imageIndex=19, onexecute="Edit.Replace"},	
	{name="editGotoLineAction", hint="Goto line", caption="Goto line...", shortcut="Ctrl+G", imageIndex=20, onexecute="Edit.GotoLine"},
	
	-- plugins 
	{name="managePluginsAction", caption="Manager...", imageindex=22, onexecute="Plugins.onManagePlugins"},
	
	-- help events
	{name="aboutAction", caption="About VCLed...", imageindex=0, onexecute="Help.onAbout"},
	{name="helpAction", caption="Help", shortcut="F1", imageindex=1, onexecute="Help.onHelp"},
	{name="contenthelpAction", caption="Content help", shortcut="Shift+F1", onexecute="Help.onContentHelp"},
		
})

function Disable()
	mainActions:Get("fileSaveAction").enabled = false
	mainActions:Get("fileSaveAsAction").enabled = false
	mainActions:Get("fileSaveAllAction").enabled = false
	mainActions:Get("fileCloseAction").enabled = false
	mainActions:Get("fileCloseAllAction").enabled = false
	mainActions:Get("filePrintAction").enabled = false

	mainActions:Get("editCopyAction").enabled = false
	mainActions:Get("editCutAction").enabled = false
	mainActions:Get("editPasteAction").enabled = false
	mainActions:Get("editUndoAction").enabled = false
	mainActions:Get("editRedoAction").enabled = false
	mainActions:Get("editFindAction").enabled = false
	mainActions:Get("editFindNextAction").enabled = false
	mainActions:Get("editFindPrevAction").enabled = false
	mainActions:Get("editReplaceAction").enabled = false
	mainActions:Get("editGotoLineAction").enabled = false
end

function EnableFileEvents()
	mainActions:Get("fileSaveAction").enabled = true
	mainActions:Get("fileSaveAsAction").enabled = true
	mainActions:Get("fileSaveAllAction").enabled = true
	mainActions:Get("fileCloseAction").enabled = true
	mainActions:Get("fileCloseAllAction").enabled = true
	mainActions:Get("filePrintAction").enabled = true
	mainActions:Get("editCopyAction").enabled = true
	mainActions:Get("editCutAction").enabled = true
	mainActions:Get("editPasteAction").enabled = true
	mainActions:Get("editFindAction").enabled = true
	mainActions:Get("editReplaceAction").enabled = true
	mainActions:Get("editUndoAction").enabled = true
	mainActions:Get("editRedoAction").enabled = true
	mainActions:Get("editGotoLineAction").enabled = true
end
