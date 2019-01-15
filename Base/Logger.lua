Logger = {}

function Logger:Log(context, logLevel)
    if logLevel == nil then
        logLevel = 0
    end

    if not Controller._DEBUG and logLevel == 3 then
        return
    end

    print('[' .. logLevel .. '] [' .. os.date('%Y-%m-%d %H:%M:%S', os.time()) .. '] '  .. context)
end

return Logger