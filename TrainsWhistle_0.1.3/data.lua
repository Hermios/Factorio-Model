require "constants"
require "libs.dataLibs"
require "prototypes.items"
require "prototypes.entities"
require "prototypes.recipes"
require "prototypes.technologies"

if not data.raw["custom-input"] or not data.raw["custom-input"][whistleTrainControl] then
  data:extend({
    {
      type = "custom-input",
      name = whistleTrainControl,
      key_sequence = "H"
    }
  })
end
