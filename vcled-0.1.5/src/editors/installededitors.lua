-- installed editors
require "vcled.common.file"

local file,string,pairs,table,getfenv = file,string,pairs,table,getfenv

module "InstalledEditors"

fileFilter={}
local installedEditors = {}
local defaultEditor = nil

function Register(edName, fFilter, fInfo)
	table.insert(installedEditors,{fileExt=fFilter,editorType=edName})
	table.insert(fileFilter,fInfo.."|"..fFilter)
end

function SetDefault(edName)
	defaultEditor = edName
end

function CreateEditor(n, f)
	local ext = nil
	if f then
		ext = string.upper(file.getext(f) or "") 		
		for k,t in pairs(installedEditors) do
			if string.find(string.upper(t.fileExt),"*."..string.upper(ext)) then
				getfenv(0)[t.editorType].New(n,f)
				return
			end
		end
	end
	-- default editor
	getfenv(0)[defaultEditor].New(n,f)
end

