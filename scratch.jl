for year in 2012:2021
    df = DataFrame()
    fl = filter( !contains(".DS"), readdir( joinpath(pwd(), "data/raw/$year/") ) )
    @showprogress for file in fl
        append!( df, CSV.read( joinpath(pwd(), "data/raw/$year/", file), DataFrame ) ) 
        try
            df.lat = allowmissing(df.lat)
            df.lon = allowmissing(df.lon)
        catch e
        end
    end
    for col in eachcol(df) replace!( col, NaN => missing ) end
    @transform! df @byrow :Timestamp=:Timestamp[1:19]
    Arrow.write( joinpath(pwd(),"data/raw/yearly/$(year).arrow"), df )
end



df = CSV.read("./data/raw/cdc/MORT85.PUB", delim=" ", ignorerepeated=true, DataFrame)

lines = readlines("./data/raw/cdc/MORT85.PUB")