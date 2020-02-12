require('zip')

local zip, assert, io, table, string, package = zip, assert, io, table, string, package

module("resource")

local PROPEXT = ".properties"
local DEFRES = "META-INF/default"

local function openzip(a,f)
	a = a or string.gsub(package.defaultlar,"%.lar","")
	if (a==nil or f==nil) then
		return nil
	end			
	local h, err = zip.openfile(a.."/"..f, {"zip","lar","jar"})	
	return h,err
end

function listzip(a, assertfunc)
	a = a or package.defaultlar..".lar"
	if (a==nil) then
		return nil
	end			
	local zfile, err = zip.open(a, {"zip","lar","jar"})
	if (zfile==nil) then
		if (assertfunc) then assertfunc(zfile, err) else return nil end
	end	
	local list = {}
	for file in zfile:files() do
		table.insert(list, file)
	end
	zfile:close()
	return list
end


function getproperty(key, resourcefile, archive, assertfunc)
	local zfile,err = openzip(archive, (resourcefile or DEFRES)..PROPEXT)
	local s = nil
	if (zfile==nil) then
		if (assertfunc) then assertfunc(zfile, err) else return nil end
	end	
	local l = zfile:read()
	while l ~= nil do
		_, _, k, v = string.find(l, "(%a+)%s*=%s*(.*)")
		if k == key then 
			l = v
			break
		end
		l = zfile:read()
	end
	zfile:close()
	return l
end

function getproperties(resourcefile, archive, assertfunc)
	local zfile,err = openzip(archive, (resourcefile or DEFRES)..PROPEXT)
	local s = nil
	if (zfile==nil) then
		if (assertfunc) then assertfunc(zfile, err) else return nil end
	end	
	t = {}
	local l = zfile:read()
	while l ~= nil do
		_, _, k, v = string.find(l, "(%a+)%s*=%s*(.*)")
		t[k]=v
		l = zfile:read()
	end
	zfile:close()
	return t
end

function gettextfile(file, archive, assertfunc)
    local t = {}
	local zfile,err = openzip(archive, file)
	if (zfile==nil) then
		if (assertfunc) then assertfunc(zfile, err) else return nil end
	end		
	local l = zfile:read()
	while l ~= nil do
		table.insert(t,l)
		l = zfile:read()
	end
	zfile:close()
	return t
end

function getfile(file, archive, assertfunc)
	local zfile,err = openzip(archive, file)
	if (zfile==nil) then
		if (assertfunc) then assertfunc(zfile, err) else return nil end
	end		
	local b = zfile:read("*a")
	local n = zfile:seek("end")
	zfile:close()	
	return b,n
end
