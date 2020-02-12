-- Lazarus lfm parser 
-- 
-- 14/11/10 - first release
--
-- lfm.totable(string)
-- lfm.tolua(string)
--
-- example code: how to parse and execute a lazarus form
-- loadstring( "require \"vcl\"\n" .. lfm.tolua( testlfm ) .. "\nForm1:ShowModal()\n" )() 
--

require "vcl"

local string, table, pairs, ipairs, tonumber, tostring, type, assert = string, table, pairs, ipairs, tonumber, tostring, type, assert

module "lfm"

local function parseproperty(line,object)
	-- test subclass
	local k,p,v = nil
	k,p,v = line:match("(%w*)%.(%w*) = (.*)")
	-- remove quotes
	if v and v:find("'")==1 then
		v = v:gsub("'","")
	end
	-- add table property
	if p and v then
		if not object.properties[k] then
			object.properties[k]={}
		end
		object.properties[k][p]="\""..v.."\""				
	else
	-- normal property			
		k,v = line:match("(%w*) = (.*)")
		if v and v:find("'")==1 then
			v = v:gsub("'","")
		end				
		if v then
			object.properties[k]="\""..v.."\""
		end
	end
end

local function parse(lfm)
	local controls = nil
	local parent = {}
	local object = nil
	local k,p,v = nil
	local isitem = nil
	local isstrings = nil
	local stringsprop = nil
	local strings = nil
	local ispic = nil
	local picprop = nil
	local picdata = nil
	for line in lfm:gmatch("[^\r\n]+") do
		local name,obj = line:match("object ([_%a][_%w]*): (%w*)")
		-- object NAME: CLASS
		if name and obj then			
			local objectname = obj:match("T(%a*)")
			assert((objectname~="SynEdit"),"SynEdit not supported!")			
			object = {["type"]=objectname,["name"]=name,["parent"]=parent[table.getn(parent)],["properties"]={["Name"]=name}}
			if not controls then
				controls = {}
			end
			table.insert(controls,object)
			table.insert(parent,name)
		-- end
		elseif line:match("end") and not isitem then
			table.remove(parent)					
		-- properties
		else			
			if isstring then
				-- strings end
				if line:match("%)") then
					object.properties[stringsprop]=strings.."]]"
					isstring = nil
					stringsprop = nil
					strings = nil	
				else
				-- add string				
					local s = string.match(line:gsub("'",""),'^()%s*$') and '' or string.match(line:gsub("'",""),'^%s*(.*%S)')				
					strings = strings..s.."\n"					
				end				
			elseif isitem then
				-- skip items
				-- item end				
				if line:match("end>") then
					isitem = nil
				end
			elseif ispic then
				if line:match("}") then
					object.properties[picprop]=picdata.."]]"
					ispic = nil
					picdata = nil
					picprop = nil
				else
					-- add picture data				
					local s = string.match(line:gsub("'",""),'^()%s*$') and '' or string.match(line:gsub("'",""),'^%s*(.*%S)')				
					picdata = picdata..s
				end
			end
			
			-- test items/lines
			if line:match("(.*) = <") then
				isitem = true
			end
			k,v = line:match("(%w*).(%w*) =")
			if k and v=="Strings" then
				isstring = true
				strings = "[["
				stringsprop=k
			end
			-- test picture data
			if k and v=="Data" then
				ispic = true
				picdata = "[["
				picprop=k
			end
			
			if not isstring and not isitem and not ispic then
				parseproperty(line,object)
			end
		end
	end
	return controls
end

function totable(lfm)
	return parse(lfm)
end

function tolua(lfm)
	local t = parse(lfm)
	if not t then
		return nil
	end
	local luascript = nil
	for k,v in ipairs(t) do
		luascript = (luascript or "")..v.name.." = VCL."..v.type.."("..tostring(v.parent)..", {\n"
		for pk,pv in pairs(v.properties) do
			if type(pv)=="table" then
				luascript = luascript.."\t"..pk.." = {\n"
				for psk,psv in pairs(pv) do
					luascript = luascript.."\t\t"..psk.." = "..tostring(psv)..",".."\n"
				end
				luascript = luascript.."\t},\n"
			else
				luascript = luascript.."\t"..pk.." = "..tostring(pv)..",".."\n"
			end
		end
		luascript = luascript.."})\n"
	end
	return luascript
end