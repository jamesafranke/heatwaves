using CSV, DataFrames, DataFramesMeta, Dates
using Arrow


df = CSV("./data/raw/cdc/MORT85.PUB", DataFrame)
