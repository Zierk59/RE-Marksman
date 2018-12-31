Logger = {}

function Logger:Log(context, logLevel)
    if logLevel == nil then
        logLevel = 0
    end

    print('[' .. logLevel .. '] [' .. os.date('%Y-%m-%d %H:%M:%S', os.time()) .. '] '  .. context)
end

return Logger