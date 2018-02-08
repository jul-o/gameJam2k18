require_relative 'Projectile'

# Types de gun
# et définition de leurs projectiles
module Guns
    # Ind   :   0   -     1       -     2
    # Forme : indice, spriteDroit, spriteGauche
    #-    3     -    4    -        5         -     6
    # projectile, radiusY, delaiRechargementMS, reculPx,
    # -          7         -     8   -   9   -    10     -    11   -     12      -  13
    # rayon du projectile, vélocité, fadeOut, exploding, degatsProj,  shakeForce   idSon
    VIEUX_FUSIL = [0, "resources/guns/gunsD/shotgun.png",          "resources/guns/gunsG/shotgun.png",
                      "resources/guns/projectiles/vieuxFusil.png",  5, 500, 5, 18, 20, false,  false,  40, 7,  4]
    BAZOOKA     = [1, "resources/guns/gunsD/bazooka.png",          "resources/guns/gunsG/bazooka.png",
                      "resources/guns/projectiles/bazooka.png",     0, 1500,  8, 18, 30, false, true,  15, 13, 3]
    REVOLVER    = [2, "resources/guns/gunsD/revolver.png",         "resources/guns/gunsG/revolver.png",
                      "resources/guns/projectiles/revolver.png",    0, 500,  6, 20, 25, false, false, 100, 5,  2]
    MACHINE_GUN = [3, "resources/guns/gunsD/minigun.png",          "resources/guns/gunsG/minigun.png",
                      "resources/guns/projectiles/machineGun.png",  7,  10,  7, 15, 18, false, false,  15, 6,  1]
    # DART_GUN    = [3, "resources/guns/machineGunG.png",             "resources/guns/machineGunD.png",
    #                 "resources/guns/projectiles/machineGun.png",  7,  10,  7, 15, 18, false, false,  10]
end

class Gun

    # Constantes de classe
    SIZE_X = 20
    SIZE_Y = 9
    NB_WEAPONS = 4

    attr_reader :bullets, :allGuns, :currentGun

    def initialize
        @allGuns = [Guns::VIEUX_FUSIL, Guns::BAZOOKA, Guns::REVOLVER, Guns::MACHINE_GUN]

        # Création des images gun
        @images = []
        @allGuns.each do |spFile|
            # Création du sprite droite\gauche
            @images << [Gosu::Image.new(spFile[1], :retro => true), Gosu::Image.new(spFile[2], :retro => true)]
        end

        # Chargement des projectiles
        @projectiles = []
        @allGuns.each do |spFile|
            @projectiles << Gosu::Image.new(spFile[3], :retro => true)
        end

        # Calcul des ratios x\y
        @ratioX = 3
        @ratioY = 3

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
        offsetY = Heros.SIZE[1]/2 - 15

        currentImg(tourneDroite).draw pX+offsetX, pY+offsetY, 1, @ratioX, @ratioY

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
                        @currentGun[9],@currentGun[10],@currentGun[11], 15, 10

                        @bullets[id] = newBullet
                        id = id+1
                    end

                    # On joue le son
                    Son.INST.playSon(@currentGun[13])

                    Game.INSTANCE.shake(@currentGun[12],@currentGun[12])
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

                    # On joue le son
                    Son.INST.playSon(@currentGun[13])

                    Game.INSTANCE.shake(@currentGun[12],@currentGun[12])
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

                    # On joue le son
                    Son.INST.playSon(@currentGun[13])

                    Game.INSTANCE.shake(@currentGun[12],@currentGun[12])
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
                    @currentGun[9],@currentGun[10],@currentGun[11], 200

                    @bullets[id] = newBullet

                    # On joue le son
                    Son.INST.playSon(@currentGun[13])

                    Game.INSTANCE.shake(@currentGun[12],@currentGun[12])
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
    def currentImg tournerDroit
        @images[currentGun[0]][tournerDroit ? 0 : 1]
    end

    # Renvoie le sprite du projectile courant
    def currentProject
        @projectiles[@currentGun[0]]
    end

    # Définit l'arme utilisée par le personnage
    def setWeapon(indice)
        @currentGun = @allGuns[indice]
        @delayT = 0
        return indice
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
