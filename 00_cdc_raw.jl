using Arrow, CSV, DataFrames, DataFramesMeta, Dates
using ProgressMeter
if occursin("heatwaves", pwd()) == false cd("heatwaves") else end

########################################  process fixed with cdc data to arrow ################################################# 

ranges = (26:28, 28:31, 31:33, 33:35, 42:44)  

out = DataFrame()
@showprogress for year in 1968:1989

    df = DataFrame(state = String[], county = String[], month = String[], day = String[], age = String[])
    lines = readlines("./data/raw/cdc/Mort$(year)")

    if year < 1979 
        ranges = (25:27, 28:31, 31:33, 33:35, 42:44)
    elseif year == 1979 
        ranges = (26:28, 28:31, 31:33, 33:35, 42:44)
    elseif year == 1980 
        ranges = (26:28, 28:31, 31:33, 33:35, 42:44)
    else 
        ranges = (26:28, 28:31, 31:33, 33:35, 42:44)
    end

    for row in lines push!(df, [ strip(row[r]) for r in ranges ]) end  
    @transform! df :year=year
    append!(out, df)
end

for col in eachcol(out) replace!( col, NaN => missing ) end
Arrow.write( joinpath(pwd(),"data/processed/cdc_all_1968_1989.arrow"), out )








#for years 1979-1980
mod = i[54:56]
FIPSstate = i[20:22]
FIPScounty  = i[22:25]
#for years 1982-1995 uncomment below
year = i[0:2]
mod = i[54:56]
FIPSstate = i[118:120]  
FIPScounty = i[120:123]


lines = readlines("./data/raw/cdc/Mort1968")
for row in lines push!(df, [ strip(row[r]) for r in ranges ]) end  


df = DataFrame(state = String[], county = String[]) #, month = String[], day = String[], age = String[])
