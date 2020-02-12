require "vcl"
require "vcled.filemenu"
require "vcled.editmenu"
require "vcled.helpmenu"

mainMenu = VCL.MainMenu("mmmainmenu")

local mainActions, mainImages, mainMenu = mainActions, mainImages, mainMenu

module "Menu"

mainMenu.Images = mainImages
mainMenu.showhint=true
mainMenu:LoadFromTable({
	{name="mmfile", caption="&File",   
		submenu={
			{name="smnew", action=mainActions:Get("fileNewAction")},
			{name="smopen", action=mainActions:Get("fileOpenAction")},
			{name="smsave", action=mainActions:Get("fileSaveAction")},
			{name="smsaveas", action=mainActions:Get("fileSaveAsAction")},
			{name="smsaveall", action=mainActions:Get("fileSaveAllAction")},
			{name="smclose", action=mainActions:Get("fileCloseAction")},
			{name="smcloseall", action=mainActions:Get("fileCloseAllAction")},
			{caption="-",},
			{name="smprint", action=mainActions:Get("filePrintAction")},
			{caption="-",},
			{name="smprefs", action=mainActions:Get("optionsShowPreferences")},
			{caption="-",},			
			{name="smexit", action=mainActions:Get("fileExitAction")},  
		}
	},
	{name="mmedit", caption="&Edit",
		submenu={
			{name="smundo", action=mainActions:Get("editUndoAction")},
			{name="smredo", action=mainActions:Get("editRedoAction")},  			
			{caption="-",},
			{name="smcopy", action=mainActions:Get("editCopyAction")},  			
			{name="smcut", action=mainActions:Get("editCutAction")},
			{name="smpaste", action=mainActions:Get("editPasteAction")},  	
			{caption="-",},
			{name="smfind", action=mainActions:Get("editFindAction")},
			{name="smfindnext", action=mainActions:Get("editFindNextAction")},
			{name="smfindprev", action=mainActions:Get("editFindPrevAction")},
			{name="smreplace", action=mainActions:Get("editReplaceAction")},  
			{caption="-",},		
			{name="smgotoline", action=mainActions:Get("editGotoLineAction")},  
		}
	},
	{name="mmplugins", caption="&Plugins", 
		submenu={
			{name="smplugman", action=mainActions:Get("managePluginsAction")},
			{caption="-",},
		}
	},
	{name="mmhelp", caption="&Help", RightJustify=true, 
	    submenu =  {
			{name="mhabout", action=mainActions:Get("aboutAction")},
			-- {name="mhhelp", action=mainActions:Get("helpAction")},
			-- {caption="-",},
			-- {name="mhcontenthelp", action=mainActions:Get("contenthelpAction")},
			-- {caption="-",},						
		}
	}
})
