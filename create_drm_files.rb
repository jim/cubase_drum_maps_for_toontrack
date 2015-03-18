require 'bundler'
Bundler.setup

require 'csv'
require 'erubis'

data = CSV.read("toontrack_kits.csv", headers: true)
erb = Erubis::Eruby.new(File.read("template.erb"))

kit_names = data.headers[4..-1]
kits = Hash[kit_names.zip(Array.new(kit_names.size) { Array.new })]

data.each do |row|
  kit_names.each do |kit_name|
    kits[kit_name] << {note: row["Note"], name: row[kit_name]}
  end
end

kits.each do |kit_name, items|
  drm = erb.result({kit_name: kit_name, items: items})
  filename = kit_name.tr("/:", "-")
  File.open("drum_maps/#{filename}.drm", "w") do |file|
    file.write(drm)
  end
end
