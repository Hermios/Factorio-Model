require "methods.constants"
require "libs.dataLibs"
require "prototypes.items"
require "prototypes.entities"
require "prototypes.recipes"
require "prototypes.technologies"

if not data.raw["custom-input"] or not data.raw["custom-input"][onChangeVisibility] then
  data:extend({
    {
      type = "custom-input",
      name = onChangeVisibility,
      key_sequence = "SHIFT + I"
    }
  })
end