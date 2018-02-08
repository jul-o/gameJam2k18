# Génère une image transformée par une couleur à partir d'une source
# Solution trouvée sur le forum Gosu
class Gosu::Image
    def silhouette(color)
        color = Gosu::Color.argb(color) if not color.is_a? Gosu::Color
        binary_data = self.to_blob
        binary_data.gsub! /...(.)/nm,
                        "#{color.red.chr}#{color.green.chr}#{color.blue.chr}\\1"
        binary_string_adapter = Struct.new(:columns, :rows, :to_blob)
        adapter = binary_string_adapter.new(self.width, self.height, binary_data)
        Gosu::Image.new(adapter)
    end
end

module BlinkEffect
    # Transforme un sprite d'origine en une version "blink"
    def self.blink spriteOrig
        spriteList = []
        spriteOrig.each do |sP|
            spriteList << sP.silhouette(Gosu::Color::RED)
        end

        return spriteList
    end
end