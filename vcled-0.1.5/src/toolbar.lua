require "vcl"

local Form,mainActions,mainImages = Form,mainActions,mainImages

module "ToolBar"

Form.mainToolBar.Images = mainImages
Form.mainToolBar:LoadFromTable({
	{action=mainActions:Get("fileNewAction")},
	{action=mainActions:Get("fileOpenAction")},
	{action=mainActions:Get("fileSaveAction")},	
	{style="tbsDivider"},	
	{action=mainActions:Get("filePrintAction")},		
	{style="tbsDivider"},	
	{action=mainActions:Get("fileSaveAsAction")},
	{action=mainActions:Get("fileSaveAllAction")},
	{action=mainActions:Get("fileCloseAction")},
	{action=mainActions:Get("fileCloseAllAction")},	
	{style="tbsSeparator"},
	{action=mainActions:Get("editFindAction")},
	{action=mainActions:Get("editReplaceAction")},
	{action=mainActions:Get("editCopyAction")},  			
	{action=mainActions:Get("editCutAction")},
	{action=mainActions:Get("editPasteAction")}, 
	{action=mainActions:Get("editUndoAction")},	
	{action=mainActions:Get("editRedoAction")},	
	{style="tbsSeparator"},	
})
