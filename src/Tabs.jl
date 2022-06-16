module Tabs

using Genie, Stipple, StippleUI, StippleUI.API
import Genie.Renderer.Html: HTMLString, normal_element, register_normal_element

export tab

register_normal_element("q__tab", context = @__MODULE__)

"""
    tab()
Renders a tab layout element.
"""
function tab(args...;
              kwargs...)
  #q__tab(args..; kwargs...)
  q__tab(args...; attributes([kwargs...], StippleUI.API.ATTRIBUTES_MAPPINGS)...)
end

end