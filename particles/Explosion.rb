require_relative 'Fumee'

class Explosion

    # Constantes de classe
    # Diamètre initial
    BASE_D = 60
    
    # Diamètre maximal
    MAX_D = 350

    # Delta d'agrandissement du rayon
    DELTA_R = 9

    attr_reader :x,:y

    def initialize cX,cY,pereProj
        # Centre de l'explosion
        @cX = cX
        @cY = cY

        # Coordonnées de la particule
        @x = cX
        @y = cY

        # Point de collision
        @collX, @collY = cX,cY

        # Rayon courant
        @currentR = BASE_D/2

        # Projectile père
        @pereProj = pereProj

        @alpha = 255

        # Sprite de base
        @img = Gosu::Image.new('resources/particles/explo1.png', :retro => true)

        # Ratio de dessin courant
        @ratio = 1

        # Filtre RGB de base
        @colorFilter = [255,255,255]
    end

    def update
        # Animation terminée
        if (@currentR*2 >= MAX_D) then
            # L'effet doit être détruit : on appelle le projectile père
            @pereProj.deleteParticle
        else
            # On augmente le rayon jusqu'à atteindre END_RADIUS
            #       tout en diminuant le channel alpha
            @currentR += DELTA_R
            @alpha -= 8

            # On met à jour le ratio en conséquence
            @ratio = @currentR.to_f/(BASE_D/2)

            # On assombrit l'image si on est à la moitié de l'animation
            @colorFilter = [118,238,0] if (@currentR*2 >= MAX_D/2)

            # On met à jour la position du cercle
            @x -= DELTA_R
            @y -= DELTA_R
        end
    end

    def deleteParticle
        @pereProj.deleteParticle
    end

    def draw
        @img.draw @x,@y,0,@ratio,@ratio,Gosu::Color.new(@alpha,@colorFilter[0],@colorFilter[1],@colorFilter[2])
    end

    def self.MAX_D
        MAX_D
    end
end