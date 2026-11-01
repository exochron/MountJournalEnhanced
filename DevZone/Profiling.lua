local _, ADDON = ...

function ADDON:Measure(fn, ...)
    local results, a,b,c,d,e,f,g,h,i,j,k,l,m,n,p,p = C_AddOnProfiler.MeasureCall(fn, ...)

    print(
        results.elapsedMilliseconds.." ms",
        results.elapsedTicks.." ticks",
        results.allocatedBytes.." B alloc",
        results.deallocatedBytes.." B dealloc",
        #results.events.." events"
    )

    return a,b,c,d,e,f,g,h,i,j,k,l,m,n,p,p
end

function MJE_Profile_Filters()
    ADDON:Measure(ADDON.FilterMounts)
end
function MJE_Profile_Sort()
    ADDON:FilterMounts()
    local dp = ADDON.Api:GetDataProvider()

    print("Profiling Sort() with ".. dp:GetSize().." entries")
    ADDON:Measure(dp.Sort, dp)
end