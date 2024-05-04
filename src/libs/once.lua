libOnce = {}

-- A quick and dirty, and thread-unsafe library for call once

function libOnce.initFlag()
    return {true}
end

function libOnce.call(flag, f, ...)
    if flag[1] then
        f(...)
        flag[1] = false
    end
end

return libOnce