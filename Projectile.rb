require_relative 'particles/Explosion.rb'

class Projectile
    attr_reader :x, :y
    
    def initialize gun,id,x,y,tourneDroite,sprite,rY,sizeR,velocity,fadeOut,exploding,degatsProj

        # rY => radius de projection des balles
        @vY = rand(-rY..rY)

        # Coordonnées du projectile
        @x = x
        @y = y

        @tourneDroite = tourneDroite
        @gun = gun

        # Vélocité du projectile
        @velocity = velocity

        # Sprite du projectile
        @spriteT = sprite

        # Taille du projectile
        @sizeR = sizeR

        # Calcul des ratios x\y
        @ratioX = @sizeR.to_f/@spriteT.width

        # Vélocité courante
        @vX = @velocity

        # Indice
        @id = id

        # Fade Out
        @fadeOut = fadeOut

        # Alpha de l'image
        @alpha = 255

        # On récupère l'instance de map
        @map = Map.INST

        # Explosion à la fin ?
        @exploding = exploding
        @particleMode = false

        # Dégâts du projectile
        @degatsProj = degatsProj
    end

    def draw
        if @particleMode then
            @particle.draw 
        else            
            @spriteT.draw @x,@y, 1, @ratioX, @ratioX, Gosu::Color.new(@alpha,255,255,255)
        end
    end

    def update
        # Si le mode particule est activé, on ne met à jour que l'animation
        if @particleMode then 
            @particle.update
            return
        end

        @vX *= 0.95
        @vY *= 0.95

        # On vérifie s'il y a collision
        # Droite\Gauche    
        if ((
            (@map.obstAt_Project?([@x+@vX,@y],@sizeR)) or (!((0..(Game.WIDTH - @sizeR))===(@x + @vX)))
            )
        ) or (
            (@map.obstAt_Project?([@x,@vY+@y],@sizeR)) or (!((0..(Game.HEIGHT - @sizeR))===(@y + @vY)))
            ) then

            # L'animation doit être terminée !
            # On fait une explosion stylée si l'option est activée, sinon on en finit.

            @vX = 0
            @vY = 0

            if (@exploding) then
                # On fait exploser la particule
                explode
            else         
                @gun.deleteProj(@id)
            end
        end

        if @tourneDroite then
            @x += @vX + @velocity/4
        else
            @x -= @vX + @velocity/4
        end

        @y += @vY

        # On met à jour l'alpha du projectile, si l'option est activée
        @alpha *= 0.9 if (@fadeOut) 
    end

    # On détruit le projectile, et par la même la particule
    def deleteParticle
        @gun.deleteProj(@id)  
    end

    def sizeR
        if @particleMode
            Explosion.MAX_D
        else
            @sizeR
        end
    end

    def pos
        if @particleMode
            [@particle.x,@particle.y]
        else
            [@x,@y]
        end
    end

    # Renvoie les degats du projectile
    def degatsProj
        @degatsProj
    end

    # Fait exploser un projectile => renvoie vrai si la particule est sensée exploser
    def explode
        if @exploding
            return true if @particleMode

            @particleMode = true
            
            # On crée une particule animée aux coordonnées courantes de la collision
            @particle = Explosion.new(@x,@y,self)            

            return true
        else
            return false
        end
    end
end