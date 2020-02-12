require "vcl"

local VCL,loadstring=VCL,loadstring

module "Font"

editorFont = nil

function Initialize(font)
	-- Initialize editorFont
	editorFont=VCL.FontDlg()
	if font then loadstring(font)() end
end

function totable(font)
	if (font) then
		return {
			name = font.name,
			size = font.size,
			style = font.fontstyle or "",
			color = font.color,
			-- orientation = font.orientation,
			-- pitch = font.pitch,
		}
	else return {name = "default"}
	end
end

function tostring(font)
	if font then
		return font.name..", "..font.size
	else
		return "default"
	end
end

function totablestring(font)
	return "{name = '"..font.name.."', size = "..font.size..", style = '"..(font.fontstyle or "")..
		    "', color = "..font.color..
			--", orientation = "..font.orientation..", pitch = '"..font.pitch.."'"..
			"}"
end

