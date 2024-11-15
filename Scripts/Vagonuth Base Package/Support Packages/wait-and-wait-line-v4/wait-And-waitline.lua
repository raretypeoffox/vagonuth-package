-- Script: wait-And-waitline
-- Attribute: isActive

-- Script Code:
local threads = {}
function wait(seconds)
    local name = "wait_"..tostring(math.random(1000, 999999))
    threads[name] = coroutine.running()
    if threads[name] == nil then
        cecho("<red>wait(): your code needs to be inside coroutine.wrap\n")
        return false
    end
    tempTimer(seconds, "wait_resume('"..name.."')")
    return coroutine.yield()
end

function wait_resume(name)
    local thread = (threads or {})[name]
    if thread == nil then
        cecho("<red>wait(): coroutine thread not found, coroutine lost\n")
        return false
    end
    threads[name] = nil
    local success,msg = coroutine.resume(thread)
    if success == false then
        cecho("<red>wait(): "..msg.."\n")
        cecho("<orange>details: "..debug.traceback(thread).."\n")
        return false
    end
    return true
end

function wait_line(patterns, timeout, action)
    local name = "wait_line_"..tostring(math.random(1000, 999999))
    threads[name] = { coroutine.running() }
    if threads[name][1] == nil then
        cecho("<red>wait_line(): your code needs to be inside coroutine.wrap\n")
        return false
    end
    threads[name][2] = {}
    if type(patterns) == "table" and #patterns > 0 then
        threads[name][4] = {}
        for i=#patterns,1,-1 do
            threads[name][2][i] = tempRegexTrigger(patterns[i], "multi_line_trigger('"..name.."', "..i..", "..#patterns..")", 1)
            disableTrigger(threads[name][2][i])
        end
        enableTrigger(threads[name][2][1])
    elseif type(patterns) == "string" then
        threads[name][2][1] = { tempRegexTrigger(patterns, "single_line_trigger('"..name.."')", 1) }
    else
        cecho("<red>wait_line(): specified pattern type is incorrect\n")
        return false
    end
    if timeout > 0 then
        local timer_id = tempTimer(timeout, "wait_line_timer('"..name.."')")
        threads[name][3] = function() disableTimer(timer_id) killTimer(timer_id) end
    else
        threads[name][3] = function() end
    end
    if action then send(action) end
    return coroutine.yield() or false
end

function wait_line_resume(name)
    local thread = ((threads or {})[name] or {})[1]
    if thread == nil then
        cecho("<red>wait_line(): coroutine thread not found, coroutine lost\n")
        return false
    end
    if coroutine.status(thread) == "suspended" then
        local args = threads[name][4]
        threads[name] = nil
        local success,msg = coroutine.resume(thread, args)
        if success == false then
            cecho("<red>wait_line(): "..msg.."\n")
            cecho("<orange>details: "..debug.traceback(thread).."\n")
        end
    else
        tempTimer(0, "wait_line_resume('"..name.."')")
    end
end

function single_line_trigger(name)
    threads[name][3]()
    threads[name][4] = matches
    wait_line_resume(name)
end

function multi_line_trigger(name, n, m)
    if n == m then
        threads[name][3]()
        threads[name][4][n] = matches
        wait_line_resume(name)
    else
        threads[name][4][n] = matches
        enableTrigger(threads[name][2][n+1])
    end
end

function wait_line_timer(name)
    for _,v in ipairs(threads[name][2]) do
        for _,i in ipairs(v) do
            disableTrigger(i)
            killTrigger(i)
        end
    end
    wait_line_resume(name)
end