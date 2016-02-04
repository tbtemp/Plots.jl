
# TODO: find/replace all [PkgName] with CamelCase, all [pkgname] with lowercase

# [WEBSITE]

function _initialize_backend(::[PkgName]Package; kw...)
  @eval begin
    import [PkgName]
    export [PkgName]
    # TODO: other initialization that needs to be eval-ed
  end
  # TODO: other initialization
end

# ---------------------------------------------------------------------------

function _create_plot(pkg::[PkgName]Package; kw...)
  d = Dict(kw)
  # TODO: create the window/canvas/context that is the plot within the backend (call it `o`)
  # TODO: initialize the plot... title, xlabel, bgcolor, etc
  Plot(nothing, pkg, 0, d, Dict[])
end


function _add_series(::[PkgName]Package, plt::Plot; kw...)
  d = Dict(kw)
  # TODO: add one series to the underlying package
  push!(plt.seriesargs, d)
  plt
end

function _add_annotations{X,Y,V}(plt::Plot{[PkgName]Package}, anns::AVec{@compat(Tuple{X,Y,V})})
  for ann in anns
    # TODO: add the annotation to the plot
  end
end

# ----------------------------------------------------------------

function _before_update_plot(plt::Plot{[PkgName]Package})
end

# TODO: override this to update plot items (title, xlabel, etc) after creation
function _update_plot(plt::Plot{[PkgName]Package}, d::Dict)
end

function _update_plot_pos_size(plt::PlottingObject{[PkgName]Package}, d::Dict)
end

# ----------------------------------------------------------------

# accessors for x/y data

function Base.getindex(plt::Plot{[PkgName]Package}, i::Int)
  # TODO: return a tuple of (x, y) vectors
end

function Base.setindex!(plt::Plot{[PkgName]Package}, xy::Tuple, i::Integer)
  # TODO: set the plot data from the (x,y) tuple
  plt
end

# ----------------------------------------------------------------

function _create_subplot(subplt::Subplot{[PkgName]Package}, isbefore::Bool)
  # TODO: build the underlying Subplot object.  this is where you might layout the panes within a GUI window, for example
end

function _expand_limits(lims, plt::Plot{[PkgName]Package}, isx::Bool)
  # TODO: call expand limits for each plot data
end

function _remove_axis(plt::Plot{[PkgName]Package}, isx::Bool)
  # TODO: if plot is inner subplot, might need to remove ticks or axis labels
end

# ----------------------------------------------------------------

function Base.writemime(io::IO, ::MIME"image/png", plt::PlottingObject{[PkgName]Package})
  # TODO: write a png to io
end

function Base.display(::PlotsDisplay, plt::Plot{[PkgName]Package})
  # TODO: display/show the plot
end

function Base.display(::PlotsDisplay, plt::Subplot{[PkgName]Package})
  # TODO: display/show the subplot
end
