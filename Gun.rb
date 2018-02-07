require_relative 'Projectile'

# Types de gun
# et définition de leurs projectiles
module Guns
    # Ind   :   0   -     1       -     2       
    # Forme : indice, spriteGauche, spriteDroit
    #-    3     -    4    -        5         -     6     
    # projectile, radiusY, delaiRechargementMS, reculPx, 
    # -          7         -     8   -   9   -    10     -    11   -
    # rayon du projectile, vélocité, fadeOut, exploding, degatsProj

    VIEUX_FUSIL = [0, "resources/guns/vieuxFusilG.png",             "resources/guns/vieuxFusilD.png",
                      "resources/guns/projectiles/vieuxFusil.png",  5, 1000, 5, 18, 20, true,  false,  10]
    BAZOOKA     = [1, "resources/guns/bazookG.png",                 "resources/guns/bazookD.png",    
                      "resources/guns/projectiles/bazooka.png",     0, 750,  8, 18, 30, false, true,  100]
    REVOLVER    = [2, "resources/guns/revolverG.png",               "resources/guns/revolverD.png",
                      "resources/guns/projectiles/revolver.png",    0, 600,  6, 20, 25, false, false, 100]
    MACHINE_GUN = [3, "resources/guns/machineGunG.png",             "resources/guns/machineGunD.png",
                      "resources/guns/projectiles/machineGun.png",  7,  10,  7, 15, 18, false, false,  10]
    # DART_GUN    = [3, "resources/guns/machineGunG.png",             "resources/guns/machineGunD.png",
    #                 "resources/guns/projectiles/machineGun.png",  7,  10,  7, 15, 18, false, false,  10]
end

class Gun

    # Constantes de classe
    SIZE_X = 30
    SIZE_Y = 7
    NB_WEAPONS = 4

    attr_reader :bullets

    def initialize
        @allGuns = [Guns::VIEUX_FUSIL, Guns::BAZOOKA, Guns::REVOLVER, Guns::MACHINE_GUN]

        # Création des images gun
        @images = []        
        @allGuns.each do |spFile|
            @images << Gosu::Image.new(spFile[1], :retro => true)            
        end

        # Chargement des projectiles
        @projectiles = []
        @allGuns.each do |spFile|
            @projectiles << Gosu::Image.new(spFile[3], :retro => true)            
        end

        # Calcul des ratios x\y
        @ratioX = SIZE_X.to_f/210
        @ratioY = SIZE_Y.to_f/50

        # Gun courant
        @currentGun = Guns::VIEUX_FUSIL

        # Projectiles lancés
        @bullets = {}

        @tourneDroit = false

        # Délai temporel entre chaque tir
        @delayT = 0
    end

    # Dessine le gun aux coordonnées du personnage x,y
    def draw pX,pY,tourneDroite
        # Calcul des offsets
        offsetX = tourneDroite ? +SIZE_X : -SIZE_X
        offsetY = Heros.SIZE[1]/2

        currentImg.draw pX+offsetX, pY+offsetY, 1, @ratioX, @ratioY

        # Dessin des projectiles
        @bullets.each do |key, bullet|
            bullet.update
            bullet.draw
        end

        # Mise à jour
        @tourneDroit = tourneDroite
    end

    # Réalise l'animation de shoot du gun
    def shoot pX,pY,tourneDroite
        # Calcul des offsets
        offsetX = tourneDroite ? +SIZE_X : -SIZE_X
        offsetY = Heros.SIZE[1]/2

        # Comportement différent selon le gun équipé
        case @currentGun[0]
            when 0 # VIEUX_FUSIL       
                # Le vieux fusil tire cinq balles simultanément, toutes les secondes
                if (@delayT == 0) then
                    @delayT = Gosu.milliseconds 

                    id = @delayT                   
                    for i in 1..5 do
                        # On crée la balle et on l'ajoute au hash
                        newBullet = Projectile.new self,id,pX+offsetX,pY+offsetY,tourneDroite,
                        currentProject,@currentGun[4],@currentGun[7],@currentGun[8],
                        @currentGun[9],@currentGun[10],@currentGun[11]

                        @bullets[id] = newBullet
                        id = id+1
                    end
                else
                    # On reset le compteur si on atteint la seconde
                    @delayT = 0 if (Gosu.milliseconds - @delayT >= @currentGun[5])
                end                
            when 1 # BAZOOKA
                # Le bazooka tire toutes les 750ms, un projectile unique avec un radius d'explosion
                if (@delayT == 0) then
                    @delayT = Gosu.milliseconds 

                    id = @delayT

                    # On crée la balle et on l'ajoute au hash
                    newBullet = Projectile.new self,id,pX+offsetX,pY+offsetY,tourneDroite,
                    currentProject,@currentGun[4],@currentGun[7],@currentGun[8],
                    @currentGun[9],@currentGun[10],@currentGun[11]

                    @bullets[id] = newBullet
                else
                    # On reset le compteur si on atteint 750ms
                    @delayT = 0 if (Gosu.milliseconds - @delayT >= @currentGun[5])
                end             
            when 2 # REVOLVER
                if (@delayT == 0) then
                    @delayT = Gosu.milliseconds 

                    id = @delayT

                    # On crée la balle et on l'ajoute au hash
                    newBullet = Projectile.new self,id,pX+offsetX,pY+offsetY,tourneDroite,
                    currentProject,@currentGun[4],@currentGun[7],@currentGun[8],
                    @currentGun[9],@currentGun[10],@currentGun[11]

                    @bullets[id] = newBullet
                else
                    @delayT = 0 if (Gosu.milliseconds - @delayT >= @currentGun[5])
                end          
            when 3 # MACHINE GUN
                if (@delayT == 0) then
                    @delayT = Gosu.milliseconds 

                    id = @delayT

                    # On crée la balle et on l'ajoute au hash
                    newBullet = Projectile.new self,id,pX+offsetX,pY+offsetY,tourneDroite,
                    currentProject,@currentGun[4],@currentGun[7],@currentGun[8],
                    @currentGun[9],@currentGun[10],@currentGun[11]

                    @bullets[id] = newBullet
                else
                    @delayT = 0 if (Gosu.milliseconds - @delayT >= @currentGun[5])
                end 
        end
    end

    # Supprime le projectile du hash identifié par id
    def deleteProj id
        @bullets.delete(id)
    end

    # Renvoie l'image du gun courant
    def currentImg
        @images[@currentGun[0]]
    end

    # Renvoie le sprite du projectile courant
    def currentProject
        @projectiles[@currentGun[0]]
    end

    # Définit l'arme utilisée par le personnage
    def setWeapon(indice)
        @currentGun = @allGuns[indice]
    end

    # Renvoie true si l'arme vient d'être tirée
    def pullBack
        elapsedT = Gosu.milliseconds - @delayT
        return ((1...150) === elapsedT)
    end

    # Renvoie le pull back courant de l'arme équipée
    def getPullBack
        @currentGun[6]
    end

    def self.NB_WEAPONS
        NB_WEAPONS
    end
end