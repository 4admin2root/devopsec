package.path = '/usr/local/share/lua/5.1/?.lua;/usr/local/openresty/lualib/resty/?.lua;'
package.cpath = '/usr/local/lib/lua/5.1/?.so;'

local upload = require "upload"

local chunk_size = 4096
local form = upload:new(chunk_size)
local file
local filelen=0
form:set_timeout(0) -- 1 sec
local filename

function get_filename(res)
    local filename = ngx.re.match(res,'(.+)filename="(.+)"(.*)')
    if filename then
        ngx.say(string.format("%s",filename[2]))
        return filename[2]
    end
end

local osfilepath = "/opt/xzx/data/upload/"
local i=0
while true do
    local typ, res, err = form:read()
    if not typ then
        ngx.say("failed to read: ", err)
        return
    end
    if typ == "header" then
        if res[1] ~= "Content-Type" then
            filename = get_filename(res[2])
            if filename then
        dir = ngx.req.get_uri_args()['dir']
                if dir then
            os.execute("mkdir -p "..osfilepath..dir )
            osfilepath =  osfilepath..dir
        end
                i=i+1
                filepath = osfilepath  .. filename
                file = io.open(filepath,"w+")
                if not file then
                    ngx.say("failed to open file ")
                    return
                end
            else
            end
        end
    elseif typ == "body" then
        if file then
            filelen= filelen + tonumber(string.len(res))
            file:write(res)
        else
        end
    elseif typ == "part_end" then
        if file then
            file:close()
            file = nil
            ngx.say("file upload success")
        end
    elseif typ == "eof" then
        break
    else
    end
end
if i==0 then
    ngx.say("please upload at least one file!")
    return
end
