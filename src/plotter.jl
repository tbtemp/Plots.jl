

include("backends/qwt.jl")
include("backends/gadfly.jl")
include("backends/unicodeplots.jl")
include("backends/pyplot.jl")
include("backends/immerse.jl")
include("backends/winston.jl")


# ---------------------------------------------------------


plot(pkg::PlottingPackage; kw...) = error("plot($pkg; kw...) is not implemented")
plot!(pkg::PlottingPackage, plt::Plot; kw...) = error("plot!($pkg, plt; kw...) is not implemented")
Base.display(pkg::PlottingPackage, plt::Plot) = error("display($pkg, plt) is not implemented")

subplot(pkg::PlottingPackage; kw...) = error("subplot($pkg; kw...) is not implemented")
subplot!(pkg::PlottingPackage, subplt::Subplot; kw...) = error("subplot!($pkg, subplt; kw...) is not implemented")
Base.display(pkg::PlottingPackage, subplt::Subplot) = error("display($pkg, subplt) is not implemented")

# ---------------------------------------------------------


const BACKENDS = [:qwt, :gadfly, :unicodeplots, :pyplot, :immerse, :winston]
const INITIALIZED_BACKENDS = Set{Symbol}()
backends() = BACKENDS


function backend(sym::Symbol)
  sym == :qwt && return QwtPackage()
  sym == :gadfly && return GadflyPackage()
  sym == :unicodeplots && return UnicodePlotsPackage()
  sym == :pyplot && return PyPlotPackage()
  sym == :immerse && return ImmersePackage()
  sym == :winston && return WinstonPackage()
  error("Unsupported backend $sym")
end 


type CurrentBackend
  sym::Symbol
  pkg::PlottingPackage
end
CurrentBackend(sym::Symbol) = CurrentBackend(sym, backend(sym))

# ---------------------------------------------------------

function pickDefaultBackend()
  try
    Pkg.installed("Immerse")
    return CurrentBackend(:immerse)
  end
  try
    Pkg.installed("Qwt")
    return CurrentBackend(:qwt)
  end
  try
    Pkg.installed("PyPlot")
    return CurrentBackend(:pyplot)
  end
  try
    Pkg.installed("Gadfly")
    return CurrentBackend(:gadfly)
  end
  try
    Pkg.installed("UnicodePlots")
    return CurrentBackend(:unicodeplots)
  end
  try
    Pkg.installed("Winston")
    return CurrentBackend(:winston)
  end
  warn("You don't have any of the supported backends installed!  Chose from ", backends())
  return CurrentBackend(:gadfly)
end
const CURRENT_BACKEND = pickDefaultBackend()
println("[Plots.jl] Default backend: ", CURRENT_BACKEND.sym)


# ---------------------------------------------------------

doc"""
Returns the current plotting package name.  Initializes package on first call.
"""
function plotter()

  currentBackendSymbol = CURRENT_BACKEND.sym
  if !(currentBackendSymbol in INITIALIZED_BACKENDS)

    # initialize
    println("[Plots.jl] Initializing backend: ", CURRENT_BACKEND.sym)
    if currentBackendSymbol == :qwt
      try
        @eval import Qwt
        @eval export Qwt
      catch
        error("Couldn't import Qwt.  Install it with: Pkg.clone(\"https://github.com/tbreloff/Qwt.jl.git\")\n  (Note: also requires pyqt and pyqwt)")
      end

    elseif currentBackendSymbol == :gadfly
      try
        @eval import Gadfly, Compose
        @eval export Gadfly, Compose
      catch
        error("Couldn't import Gadfly.  Install it with: Pkg.add(\"Gadfly\")")
      end

    elseif currentBackendSymbol == :unicodeplots
      try
        @eval import UnicodePlots
        @eval export UnicodePlots
      catch
        error("Couldn't import UnicodePlots.  Install it with: Pkg.add(\"UnicodePlots\")")
      end

    elseif currentBackendSymbol == :pyplot
      try
        @eval import PyPlot
        @eval export PyPlot
      catch
        error("Couldn't import PyPlot.  Install it with: Pkg.add(\"PyPlot\")")
      end

    elseif currentBackendSymbol == :immerse
      try
        @eval import Immerse, Gadfly, Compose, Gtk
        @eval export Immerse, Gadfly, Compose, Gtk
      catch
        error("Couldn't import Immerse.  Install it with: Pkg.add(\"Immerse\")")
      end

    elseif currentBackendSymbol == :winston
      try
        @eval import Winston, Gtk
        @eval export Winston, Gtk
      catch
        error("Couldn't import Winston.  Install it with: Pkg.add(\"Winston\")")
      end

    else
      error("Unknown plotter $currentBackendSymbol.  Choose from: $BACKENDS")
    end
    push!(INITIALIZED_BACKENDS, currentBackendSymbol)
    # println("[Plots.jl] done.")

  end
  CURRENT_BACKEND.pkg
end

doc"""
Set the plot backend.  Choose from:  :qwt, :gadfly, :unicodeplots
"""
function plotter!(modname)
  
  # set the PlottingPackage
  if modname == :qwt
    CURRENT_BACKEND.pkg = QwtPackage()
  elseif modname == :gadfly
    CURRENT_BACKEND.pkg = GadflyPackage()
  elseif modname == :unicodeplots
    CURRENT_BACKEND.pkg = UnicodePlotsPackage()
  elseif modname == :pyplot
    CURRENT_BACKEND.pkg = PyPlotPackage()
  elseif modname == :immerse
    CURRENT_BACKEND.pkg = ImmersePackage()
  elseif modname == :winston
    CURRENT_BACKEND.pkg = WinstonPackage()
  else
    error("Unknown plotter $modname.  Choose from: $BACKENDS")
  end

  # update the symbol
  CURRENT_BACKEND.sym = modname

  # return the package
  CURRENT_BACKEND.pkg
end
