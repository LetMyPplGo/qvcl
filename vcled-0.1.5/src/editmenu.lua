require "vcled.editors"

local Editors = Editors

module "Edit"

-- Search and Replace
function Find()
	Editors.CallFunc("onFind")
end

function FindNext()
	Editors.CallFunc("onFindNext")

end
function FindPrev()	
	Editors.CallFunc("onFindPrev")
end
function Replace()
	Editors.CallFunc("onReplace")
end

-- Goto line
function GotoLine()
	Editors.CallFunc("onGotoLine")
end

-- Copy Cut Paste etc
function Copy()
	Editors.CallFunc("ProcessCommand","ecCopy")
end

function Cut()
	Editors.CallFunc("ProcessCommand","ecCut")
end

function Paste()
	Editors.CallFunc("ProcessCommand","ecPaste")
end

function Undo()
	Editors.CallFunc("ProcessCommand","ecUndo")
end

function Redo()
	Editors.CallFunc("ProcessCommand","ecRedo")
end
