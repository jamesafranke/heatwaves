using Plots; gr(); theme(:dark) #unicodeplots() 
#using UnicodePlots
#using VegaLite, VegaDatasets
using Query, DataFrames, CSV, Dates
using Statistics
using NPZ
using TSne, Clustering, Distances

#### show plots of VAE success ####
y = npzread("data/train_stack_12.npy")
y = y[1:100,:,:,1]
heatmap( reverse(y[93,:,:], dims = 1), c=:balance, border =:none, colorbar=:none)
png("figures/test.png")

y2 = npzread("data/output_img.npy")
heatmap( reverse(y2[93,:,:], dims = 1), c=:balance, border =:none, colorbar=:none)
png("figures/test1.png")

### Clustering ###
x = npzread("data/output.npy") 
x = permutedims(x[1,:,:], [2,1])

R = kmeans(x, 300; maxiter=500, display=:iter)
a = assignments(R)  # get the assignments of points to clusters
c = counts(R)       # get the cluster sizes
M = R.centers       # get the cluster centers

df = CSV.read("data/times.csv", DataFrame, header=0 )
rename!(df,:Column1 => :date)
df[!, :clust] = assignments(R)

temp = df |> @filter(_.clust == 213 )  |> DataFrame


X = x[:,1:2000]
P = pairwise(Euclidean(), X, dims=2)

R = hclust(P, linkage=:ward)

R = kmedoids(x, 100)
R = affinityprop(x, 100)

#### TSNE ####
x = npzread("data/output.npy") 
x = x[1,:,:]

Y = tsne(x, 2)


#### OLD TESTS #####
#### OLD TESTS #####
#### OLD TESTS #####

time_range = Date(1959,1,1):Day(1):Date(2022,9,30)

heatmap(y[1,:,:], xfact=.1, yfact=.1, colormap=:inferno)

y = npzread("data/times12.npy")
heatmap(y[1,1:120,1:250], xscale=.1, yscale=.1,  colormap=:inferno, border=:none)

heatmap(collect(0:30) * collect(0:30)', colormap=:inferno)

i = 100
if i % 100 == 0
    print(i)
end 

x = "World!"
y = 42
"Hello $x, $(y^2) !"

df |> 
    @dropna() |>
    @groupby( _.Label ) |>
    @map( { Label = key(_), 
            Count = length(_), 
            opti = mean( _.Cloud_Optical_Thickness_mean ),
            infr = mean( _.Cloud_Phase_Infrared_liquid )  } )  |> 
    @vlplot(:bar,
        x = :Label,
        y = :Count,
        color = :opti,
        width = 600, height = 400,
        config = { view = { stroke=:transparent,  background="#333" } }
    )

    
#### OLD TESTS #####

df1 = DataFrame(name=repeat(["John", "Sally", "Kirk"],inner=[1],outer=[2]), 
     age=vcat([10., 20., 30.],[10., 20., 30.].+3), 
     children=repeat([3,2,2],inner=[1],outer=[2]),state=[:a,:a,:a,:b,:b,:b])

x = @from i in df1 begin
    @group i by i.state into g
    @select {group=key(g),mage=mean(g.age), oldest=maximum(g.age), youngest=minimum(g.age)}
    @collect DataFrame
end

df = DataFrame(a=[1,1,2,3], b=[4,5,6,8])

df2 = df |> 
    @groupby(_.a) |>
    @map({a=key(_), b=mean(_.b)}) |>
    @filter(_.b > 5) |>
    @orderby_descending(_.b) |>
    DataFrame

jim = 10


x = 1:10
y = 1:10
y2 = rand(10)

plot(x,y )
scatter!(x, y2 )

dataset("cars") |>
@vlplot(:point,
    x = :Horsepower,
    y = :Miles_per_Gallon,
    color = :Origin,
    width = 400, height = 400
    )

temp = dataset("cars");