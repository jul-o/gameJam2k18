class Fumee

    # Constantes de classe
    # Dimensions du cadre d'effet
    SIZE_X = 50
    SIZE_Y = 30

    # Diamètre de chaque particule
    SIZE_D = 15

    # Ratio maximum d'agrandissement 
    MAX_R = 2

    def initialize cX,cY,pereProj
        # Centre de l'effet de fumée
        @cX = cX
        @cY = cY

        # Coordonnées de la particule
        @x = cX + SIZE_X/2
        @y = cY + SIZE_Y/2

        # Projectile père
        @pereProj = pereProj

        # Création de l'array des sprites et rotation
        @allCoord = [[4,2],[10,9],[13,2],[26,13],[24,4],[33,0]]
        @allSp = []

        @allCoord.each do |coord|
            @allSp << [[coord[0]+@x, coord[1]+@y], rand(1..180),Gosu::Image.new('resources/particles/fumee.png', :retro=>true)]
        end

        @img = Gosu::Image.new('resources/particles/fumee.png', :retro=>true)

        # Ratio de dessin courant
        @ratio = 1
    end

    def update
        # Animation terminée
        if (@ratio >= MAX_R) then
            # L'effet doit être détruit : on appelle le projectile père
            @pereProj.deleteParticle
        else
            # On augmente le ratio de rendu jusqu'à atteindre MAX_R
            #       tout en diminuant le channel alpha
            @ratio += 0.1
            @alpha -= 8
        end
    end

    def draw
        # On dessine tous les sprites
        #@allSp.each do |spR|
        #    cX = spR[0][0] + SIZE_D/2
        #    cY = spR[0][1] + SIZE_D/2
        #    spR[2].draw_rot spR[0][0], spR[0][1], 1, spR[1], cX, cY, @ratio, @ratio
        #    #  color = 0xff_ffffff, mode = :default)
       # end
       @img.draw @x, @y, @ratio, @ratio
       #puts @allSp[0]
      # @allSp[2].draw @allSp[0][0], @allSp[0][1],1,@ratio,@ratio,Gosu::Color.new(@alpha,@colorFilter,@colorFilter,@colorFilter)
    end
end