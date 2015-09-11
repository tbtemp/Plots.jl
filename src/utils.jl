
calcMidpoints(edges::AbstractVector) = Float64[0.5 * (edges[i] + edges[i+1]) for i in 1:length(edges)-1]

doc"Make histogram-like bins of data"
function binData(data, nbins)
  lo, hi = extrema(data)
  edges = collect(linspace(lo, hi, nbins+1))
  midpoints = calcMidpoints(edges)
  buckets = Int[max(2, min(searchsortedfirst(edges, x), length(edges)))-1 for x in data]
  counts = zeros(Int, length(midpoints))
  for b in buckets
    counts[b] += 1
  end
  edges, midpoints, buckets, counts
end

doc"""
A hacky replacement for a histogram when the backend doesn't support histograms directly.
Convert it into a bar chart with the appropriate x/y values.
"""
function histogramHack(; kw...)
  d = Dict(kw)

  # we assume that the y kwarg is set with the data to be binned, and nbins is also defined
  edges, midpoints, buckets, counts = binData(d[:y], d[:nbins])
  d[:x] = midpoints
  d[:y] = float(counts)
  d[:linetype] = :bar
  d[:fillto] = d[:fillto] == nothing ? 0.0 : d[:fillto]
  d
end

doc"""
A hacky replacement for a bar graph when the backend doesn't support bars directly.
Convert it into a line chart with fillto set.
"""
function barHack(; kw...)
  d = Dict(kw)
  midpoints = d[:x]
  heights = d[:y]
  fillto = d[:fillto] == nothing ? 0.0 : d[:fillto]

  # estimate the edges
  dists = diff(midpoints) * 0.5
  edges = zeros(length(midpoints)+1)
  for i in 1:length(edges)
    if i == 1
      edge = midpoints[1] - dists[1]
    elseif i == length(edges)
      edge = midpoints[i-1] + dists[i-2]
    else
      edge = midpoints[i-1] + dists[i-1]
    end
    edges[i] = edge
  end

  x = Float64[]
  y = Float64[]
  for i in 1:length(heights)
    e1, e2 = edges[i:i+1]
    append!(x, [e1, e1, e2, e2])
    append!(y, [fillto, heights[i], heights[i], fillto])
  end

  d[:x] = x
  d[:y] = y
  d[:linetype] = :line
  d[:fillto] = fillto
  d
end

