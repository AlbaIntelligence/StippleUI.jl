module API

using Stipple, StippleUI, Colors
import Genie.Renderer.Html: HTMLString, normal_element

export attributes, quasar, vue, quasar_pure, vue_pure, xelem, xelem_pure, csscolors, kw, @kw

const ATTRIBUTES_MAPPINGS = Dict{String,String}(
  "autoclose" => "auto-close",
  "bgcolor" => "bg-color",
  "bottomslots" => "bottom-slots",
  "checkedicon" => "checked-icon",
  "clearicon" => "clear-icon",
  "colorhalf" => "color-half",
  "colorselected" => "color-selected",
  "contentclass" => "content-class",
  "contentstyle" => "content-style",
  "contextmenu" => "context-menu",
  "darkpercentage" => "dark-percentage",
  "defaultyearmonth" => "default-year-month",
  "defaultview" => "default-view",
  "definitions" => ":definitions",
  "displayvalue" => "display-value",
  "dropnative" => "@drop.native",
  "dragonlyrange" => "drag-only-range",
  "dragrange" => "drag-range",
  "emitimmd" => "emit-immediately",
  "errormessage" => "error-message",
  "eventcolor" => "event-color",
  "expandicontoggle" => "expand-icon-toggle",
  "expandseparator" => "expand-separator",
  "falsevalue" => "false-value",
  "fieldname" => "v-model",
  "fillmask" => "fill-mask",
  "firstdayofweek" => "first-day-of-week",
  "fullheight" => "full-height",
  "fullwidth" => "full-width",
  "hidebottom" => "hide-bottom",
  "hidebottomspace" => "hide-bottom-space",
  "hideheader" => "hide-header",
  "hidehint" => "hide-hint",
  "iconcolor" => "icon-color",
  "iconhalf" => "icon-half",
  "iconremove" => "icon-remove",
  "iconright" => "icon-right",
  "iconselected" => "icon-selected",
  "imageclass" => "img-class",
  "imagestyle" => "img-style",
  "indeterminateicon" => "indeterminate-icon",
  "indeterminatevalue" => "indeterminate-value",
  "inputclass" => "input-class",
  "inputstyle" => "input-style",
  "insetlevel" => "inset-level",
  "itemaligned" => "item-aligned",
  "keepcolor" => "keep-color",
  "labelalways" => "label-always",
  "labelcolor" => "label-color",
  "labelslot" => "label-slot",
  "labelvalue" => "label-value",
  "labelvalueleft" => "left-label-value",
  "labelvalueright" => "right-label-value",
  "lazyrules" => "lazy-rules",
  "leftlabel" => "left-label",
  "manualfocus" => "manual-focus",
  "maxvalues" => "max-values",
  "minheight" => "min-height",
  "maxheight" => "max-height",
  "multiline" => "multi-line",
  "nativecontextmenu" => "native-context-menu",
  "navmaxyearmonth" => "navigation-max-year-month",
  "navminyearmonth" => "navigation-min-year-month",
  "newvaluemode" => "new-value-mode",
  "nobackdrop" => "no-backdrop-dismiss",
  "nocaps" => "no-caps",
  "nodefaultspinner" => "no-default-spinner",
  "nodimming" => "no-dimming",
  "noerrorfocus" => "no-error-focus",
  "noerroricon" => "no-error-icon",
  "noesc" => "no-esc-dismiss",
  "nofocus" => "no-focus",
  "noparentevent" => "no-parent-event",
  "norefocus" => "no-refocus",
  "noreset" => "no-reset",
  "noresetfocus" => "no-reset-focus",
  "nowrap" => "no-wrap",
  "nounset" => "no-unset",
  "pagination" => ":pagination.sync",
  "placeholdersrc" => "placeholder-src",
  "reactiverules" => "reactive-rules",
  "reversefillmask" => "reverse-fill-mask",
  "rules" => ":rules",
  "selected" => ":selected.sync",
  "shadowtext" => "shadow-text",
  "showifabove" => "show-if-above",
  "spinnercolor" => "spinner-color",
  "spinnersize" => "spinner-size",
  "stacked" => "stack",
  "stacklabel" => "stack-label",
  "textcolor" => "text-color",
  "todaybtn" => "today-btn",
  "toggleindeterminate" => "toggle-indeterminate",
  "toggleorder" => "toggle-order",
  "toolbar" => ":toolbar",
  "toolbartextcolor" => "toolbar-text-color",
  "toolbartogglecolor" => "toolbar-toggle-color",
  "toolbarbg" => "toolbar-bg",
  "pastenative" => "@paste.native",
  "transitionhide" => "transition-hide",
  "transitionshow" => "transition-show",
  "truevalue" => "true-value",
  "uncheckedicon" => "unchecked-icon",
  "unmaskedvalue" => "unmasked-value",
  "usechips" => "use-chips",
  "useinput" => "use-input",
  "vclosepopup" => "v-close-popup",
  "vripple" => "v-ripple",
  "yearsinmonthview" => "years-in-month-view"
);


function attributes(kwargs::Union{Vector{<:Pair}, Base.Iterators.Pairs, Dict},
                    mappings::Dict{String,String} = Dict{String,String}())::NamedTuple

  attrs = Stipple.OptDict()
  mapped = false

  for (k,v) in kwargs
    v === nothing && continue
    mapped = false

    if haskey(mappings, string(k))
      k = mappings[string(k)]
    end

    attr_key = string((isa(v, Symbol) && ! startswith(string(k), ":") &&
      ! ( startswith(string(k), "v-") || startswith(string(k), "v" * Genie.config.html_parser_char_dash) ) ? ":" : ""), "$k") |> Symbol
    attr_val = isa(v, Symbol) && ! startswith(string(k), ":") ? Stipple.julia_to_vue(v) : v

    attrs[attr_key] = attr_val
  end

  NamedTuple(attrs)
end

function kw(kwargs::Union{Vector{X}, Base.Iterators.Pairs, Dict}, 
  attributesmappings::Dict{String,String} = Dict{String,String}();
  merge::Bool = true) where X
  
  attributes(kwargs, merge ? ( isempty(attributesmappings) ? ATTRIBUTES_MAPPINGS : Base.merge(ATTRIBUTES_MAPPINGS, attributesmappings) ) : attributesmappings)
end

macro kw(kwargs)
  :( attributes($(esc(kwargs)), ATTRIBUTES_MAPPINGS) )
end

function q__elem(f::Function, elem::Symbol, args...; attrs...) :: HTMLString
  normal_element(f, string(elem), [args...], Pair{Symbol,Any}[attrs...])
end

function q__elem(elem::Symbol, children::Union{String,Vector{String}} = "", args...; attrs...) :: HTMLString
  normal_element(children, string(elem), [args...], Pair{Symbol,Any}[attrs...])
end

function q__elem(elem::Symbol, children::Any, args...; attrs...) :: HTMLString
  normal_element(string(children), string(elem), [args...], Pair{Symbol,Any}[attrs...])
end

function xelem(elem::Symbol, args...;
              attributesmappings::Dict{String, String} = Dict{String, String}(),
              mergemappings = true,
              kwargs...)
  q__elem(elem, args...; kw(kwargs, attributesmappings, merge = mergemappings)...)
end

function quasar(elem::Symbol, args...; kwargs...)
  xelem(Symbol("q-$elem"), args...; kwargs...)
end

function vue(elem::Symbol, args...; kwargs...)
  xelem(Symbol("q-$elem"), args...; kwargs...)
end

xelem_pure(elem::Symbol, args...; kwargs...) = xelem(elem, args...; kwargs...)
quasar_pure(elem::Symbol, args...; kwargs...) = quasar(elem, args...; kwargs...)
vue_pure(elem::Symbol, args...; kwargs...) = vue(elem, args...; kwargs...)

"""
    `csscolors(name, color)`
    `csscolors(names, colors)`
    `csscolors(prefix, colors)`

Construct a css string that defines colors to be used for styling quasar elements.
# Usage
css = styles(csscolors(:stipple, [RGB(0.2, 0.4, 0.8), "#123456", RGBA(0.1, 0.2, 0.3, 0.5)]))

ui() = css * dashboard(vm(model), class="container", [
  btn("Hit me", @click(:pressed), color="stipple-3")
])
"""
function csscolors(name, color::AbstractString)
  ".text-$name { color: $color }\n.bg-$name   { background: $color !important}"
end

csscolors(name, color::Colorant) = csscolors(name, "#" * hex(color, :auto))

csscolors(names::Vector, colors::Vector) = join([csscolors(n, c) for (n, c) in zip(names, colors)], "\n")

csscolors(prefix::Union{Symbol, AbstractString}, colors::Vector) = csscolors("$prefix-" .* string.(1:length(colors)), colors)

function __init__() :: Nothing
  Stipple.rendering_mappings(ATTRIBUTES_MAPPINGS)

  nothing
end

end
