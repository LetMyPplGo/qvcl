require "vcl"

if package.larpath then
	require "vcled.common.resource"
end

mainImages = VCL.ImageList()

local VCL,mainImages,package,resource,ipairs = VCL,mainImages,package,resource,ipairs

module "Images"

function Load(fname)
	if package.larpath then
		local img = VCL.Image()
		local buff,size = resource.getfile(fname)
		img:LoadFromBuffer(buff,size,fname)
		return img
	else
		return fname
	end
end


local images = {
--main	
	"images/about.png", 
	"images/help.png", 
-- file	
	"images/new.png", 
	"images/open.png",
	"images/save.png",
	"images/saveas.png",
	"images/save_all.png",
	"images/close.png",
	"images/close_all.png",
	"images/file_print.png",	
	"images/exit.png",
-- edit	
	"images/copy.png", 
	"images/cut.png", 
	"images/paste.png",
	"images/undo.png", 
	"images/redo.png", 	
	"images/search_find.png", 
	"images/search_find_next.png", 
	"images/search_find_previous.png", 
	"images/search_replace.png",  
	"images/goto_line.png",  
 -- preference
	"images/preferences.png",
 -- plugins
	"images/packages.png",
 -- other
	"images/font.png",
}

if package.larpath then
	for i,fname in ipairs(images) do
		local buff,size = resource.getfile(fname)
		mainImages:LoadFromBuffer(buff,size,fname)
	end
else
	mainImages:LoadFromTable(images)
end
