class Fumee

    # Constantes de classe
    # Dimensions du cadre d'effet
    SIZE_X = 50
    SIZE_Y = 30

    # Diamètre de chaque particule
    SIZE_D = 30

    # Ratio maximum d'agrandissement 
    MAX_R = 4

    # Frames d'animation
    FRM_X = 8000

    def initialize cX,cY,pereProj
        # Centre de l'effet de fumée
        @x = cX - SIZE_X/2
        @y = cY - SIZE_Y/2

        # Projectile père
        @pereProj = pereProj

        # Création de l'array des sprites et rotation
        @img = Gosu::Image.new('resources/particles/fumee.png', :retro=>true)
        @allSp = []
        allCoord = [[48,17],[32,17],[16,17],[0,17],
                    [48, 0],[32, 0],[16, 0],[0, 0]]

        allCoord.each do |coord|
            @allSp << @img.subimage(coord[0], coord[1],16,17)
        end

        # Ratio de dessin courant
        @ratio = 2

        @alpha = 255

        @i = 0
    end

    def update
        # Animation terminée
        if (@ratio >= MAX_R) then
            # L'effet doit être détruit : on appelle le projectile père
            @pereProj.deleteParticle
        else
            # On augmente le ratio de rendu jusqu'à atteindre MAX_R
            #       tout en diminuant le channel alpha
            @alpha -= 8
        end
    end

    def draw
        # On dessine tous les sprites
        @allSp[(@i%FRM_X) % @allSp.length].draw @x, @y, 1, @ratio, @ratio, Gosu::Color.new(@alpha,255,255,255)

        @i += 1
    end
end