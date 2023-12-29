require "methods.constants"
require "__HermiosLibs__.data"
require "prototypes.items"
require "prototypes.entities"
require "prototypes.recipes"
require "prototypes.technologies"

if not data.raw["custom-input"] or not data.raw["custom-input"][onTrainWhistled] then
  data:extend({
    {
      type = "custom-input",
      name = onTrainWhistled,
      key_sequence = "H"
    }
  })
end
