local io = require "io"
local table = require "table"
local string = require "string"

module "file"

-- file exists ------------------------
function exists(filename)
  if not filename then return false	end
  local f = io.open(filename, "r")
  if f==nil then 
  	return false 
  else
    f:close()
    return true  
  end	
end

-- file saver -------------------------
function save(filename, rbuf)
  if rbuf==nil then return false end
  local f = io.open(filename, "w+b")
  if f==nil then return false end
  f:write(rbuf)
  f:flush()
  f:close()
  return true
end

-- file loader ------------------------
function load(filename)
  local f = io.open(filename, "r")
  if f==nil then return nil end  
  local cmdbuf = f:read("*all")
  local n = f:seek("end") 
  f:close()
  return cmdbuf,n
end

function loadastable(filename)
  local f = io.open(filename, "r")
  if f==nil then return nil end
  local cmdbuf  = {}
  while true do
  	local line = f:read("*l")  
  	if line == nil then break end
  	table.insert(cmdbuf,line)
  end
  f:close()
  return cmdbuf, table.getn(cmdbuf)
end

-- file name ---------------------
function getname(filename)
    if not filename then return end
	local fsep1 = "\\"
	local fsep2 = "/"
	local n=0
	while string.find(filename,fsep1,n+1) do
		n = string.find(filename,fsep1,n+1)
	end
	if n==0 then
		while string.find(filename,fsep2,n+1) do
			n = string.find(filename,fsep2,n+1)
		end
	end
	return string.sub(filename,n+1,string.len(filename))
end

-- file extension ---------------------
function getext(filename)
	if not filename then return end
    filename = getname(filename)
	local file_ext = nil
    for w in string.gfind(filename,"(%.%a*)") do
   		file_ext = string.lower(string.sub(w,2,10))
	end 
	return file_ext
end

-- file changeext ----------------------
function changeext(filename,ext)
	if not filename then return end
	local extsep = "%."
	local n=0
	local l=nil
	while string.find(filename,extsep,n+1) do
		n,l = string.find(filename,extsep,n+1)
	end
	if ext and string.len(ext)>0 then ext="."..ext else ext="" end
	if l then
		return string.sub(filename,1,l-1)..ext
	else
		return filename..ext
	end
end

-- file getpath --------------------------
function getpath(filename)
	if not filename or string.len(filename)==0 then
		return "./"
	end
	local n=1
	while string.find(filename,getname(filename),n+1) do
		n,l = string.find(filename,getname(filename),n+1)
	end
	return string.sub(filename,1,n-1)
end