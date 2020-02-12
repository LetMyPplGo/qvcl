require "vcl"
require "vcled.editors.installededitors"

local VCL,Editors,InstalledEditors = VCL,Editors,InstalledEditors

module "NoEdit"

-- Editor Registration 
InstalledEditors.SetDefault("NoEdit")
InstalledEditors.Register("NoEdit","*.no","NoEdit Files")

function New(n, filename)
	local parent = Editors.openedPages[n].Sheet
	local noed = VCL.Memo(parent)
	Editors.openedPages[n].Editor = noed
	Editors.openedPages[n].Type = "NoEdit"
	Editors.openedPages[n].FileName = filename
	Editors.UID = Editors.UID + 1
	noed._ = {	
			-- set the editor properties here
			tag = Editors.UID,
			align = "alClient",
	}
	noed:Clear()
end

function onInfo(e)
end

function ProcessCommand(e,cmd)	
end

function onSave(e,filename)
end

function onFind(e)
end

function onFindNext(e)
end

function onFindPrev(e)
end

function onReplace(e)
end

function onGotoLine(e)
end

function onPrint(e)
end