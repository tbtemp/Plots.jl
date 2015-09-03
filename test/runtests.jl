module PlotsTests

using Plots
using FactCheck


facts("Qwt") do
  @fact plotter!(:qwt) --> nothing
  @fact plotter() --> Plots.QwtPackage()
  @fact typeof(plot(1:10, show=false)) --> Plot

  # plot(y::AVec; kw...)                       # one line... x = 1:length(y)
  @fact plot(1:10, show=false) --> not(nothing)
  @fact length(currentPlot().o.lines) --> 1

  # plot(x::AVec, y::AVec; kw...)              # one line (will assert length(x) == length(y))
  @fact plot(Int[1,2,3], rand(3); show=false) --> not(nothing)
  @fact_throws plot(1:5, 1:4)
  
  # plot(y::AMat; kw...)                       # multiple lines (one per column of x), all sharing x = 1:size(y,1)
  @fact plot!(rand(10,2)) --> not(nothing)
  @fact length(currentPlot().o.lines) --> 3

  # plot(x::AVec, y::AMat; kw...)              # multiple lines (one per column of x), all sharing x (will assert length(x) == size(y,1))
  @fact plot(sort(rand(10)), rand(Int, 10, 3)) --> not(nothing)

  # plot(x::AMat, y::AMat; kw...)              # multiple lines (one per column of x/y... will assert size(x) == size(y))
  # plot(x::AVec, f::Function; kw...)          # one line, y = f(x)
  # plot(x::AMat, f::Function; kw...)          # multiple lines, yᵢⱼ = f(xᵢⱼ)
  # plot(x::AVec, fs::AVec{Function}; kw...)   # multiple lines, yᵢⱼ = fⱼ(xᵢ)
  # plot(y::AVec{AVec}; kw...)                 # multiple lines, each with x = 1:length(y[i])
  # plot(x::AVec, y::AVec{AVec}; kw...)        # multiple lines, will assert length(x) == length(y[i])
  # plot(x::AVec{AVec}, y::AVec{AVec}; kw...)  # multiple lines, will assert length(x[i]) == length(y[i])
  # plot(n::Integer; kw...)                    # n lines, all empty (for updating plots)
end

facts("Gadfly") do
  @fact plotter!(:gadfly) --> nothing
  @fact plotter() --> Plots.GadflyPackage()
  @fact typeof(plot(1:10, show=false)) --> Plot
end

FactCheck.exitstatus()
end # module
