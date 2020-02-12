-- xml form parser 
-- 
-- 08/06/09 - first release
--
-- xfm.parse(string)
--
-- requires lxp library ( http://www.keplerproject.org/luaexpat )
-- based on lxp's lom.lua
--

require "lxp"
require "vcl"

local tinsert, tremove, getn, tconcat = table.insert, table.remove, table.getn, table.concat
local assert, type, loadstring, getfenv, string = assert, type, loadstring, getfenv, string
local lxp = lxp
local vclenv = getfenv() 

module ("xfm")

local namespace = nil

local function starttag (p, tag, attr)
  local stack = p:getcallbacks().stack[1]
  local result = p:getcallbacks().stack[2]
  if tag=="property" then  
     local parent = stack[getn(stack)][1]
     local f = vclenv ["VCL"][attr.value]
     
     -- corrected     
     if f and string.lower(attr.name)~="caption" and string.lower(attr.name)~="text" then
     	parent[attr.name] = f
     else
     	parent[attr.name] = attr.value     
     end
     tinsert(stack,stack[getn(stack)])
  elseif tag=="event" then     
     local parent = stack[getn(stack)][1]
     parent[attr.name] = attr.value
     tinsert(stack,stack[getn(stack)])
  else
     local parent = nil
     local f = vclenv ["VCL"][tag]
     if getn(stack)>0 then
     	parent = stack[getn(stack)][1]
     end
     local child = nil
     if getn(stack)==0 then     	
     	local ns = namespace
     	if ns then ns=ns.."_" else ns="" end
     	child = f(parent,ns..attr.name)
  		tinsert(result,{child})			-- root element as result
  	 elseif parent then  	    
  	 	child = f(parent,attr.name)
  	    parent[attr.name] = child   -- add as child
     end
     tinsert(stack,{child})				-- save next "parent" onstack
  end   
end

local function endtag (p, tag)
  local stack = p:getcallbacks().stack[1]  
  -- save result  
  tremove(stack,getn(stack))
end

local function text (p, txt)
  local stack = p:getcallbacks().stack[1]
  -- trim
  txt = string.gsub(txt, "^%s*(.-)%s*$", "%1")
  if string.len(txt)>0 then
    	loadstring(txt)()
  end

end

function  parse (o)
   
  local c = { StartElement = starttag,
              EndElement = endtag,
              CharacterData = text,
              _nonstrict = true,
              stack = {{},{}},
            }
  local p = lxp.new(c)
  local status, err
  if type(o) == "string" then
    status, err = p:parse(o)
    if not status then return nil, err end
  else
    for l in o do
      status, err = p:parse(l)
      if not status then return nil, err end
    end
  end
  status, err = p:parse()
  if not status then return nil, err end
  p:close()  
   
  return c.stack[2][1][1]
  
end
