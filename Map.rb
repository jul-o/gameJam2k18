class Map
    @@WX, @@HY = 17,14

    CELLSIZE = 45

    def initialize
        # Définition du contenu de la map
        @grid = [[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                 [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                 [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                 [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                 [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                 [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                 [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                 [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                 [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                 [0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0],
                 [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                 [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                 [0,0,0,0,1,0,0,0,1,1,1,1,0,0,0,0,0],
                 [0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0]]
        # 0 : vide
        # 1 : obstacle
    end

    # Renvoie une array des directions dans lesquelles se trouvent un obstacle
    # => [] si walou
    # => [indiceDir, coordObst] si obstacle trouvé
    def obstacleAround(coord)
        # Directions haut, bas, droite, gauche
        dL = [[0,-1],[0,1], [1,0],[-1,0]]

        # Array des directions
        dirObst =  []
        ind = 0

        dL.each do |shift|
            testC = [coord[0]+shift[0], coord[1]+shift[1]]
            if (getCase(testC) == 1) then
                dirObst << [ind,testC]
            end
            ind = ind+1
        end

        return dirObst
    end

    # Renvoie vrai s'il y a collison aux coordonnées pixel coord
    def obstAt?(coordPx)
        # Pour chaque obstacle on vérifie les collisions
        x = 0
        y = 0

        @grid.each do |line|
            line.each do |cell|
                if (cell==1) then
                    obstCoordPx = [x*CELLSIZE, y*CELLSIZE]
                    return true if (isHit?(obstCoordPx, coordPx))    
                end
                x=x+1
            end
            x=0
            y=y+1
        end

        return false
    end

    # Renvoie true s'il y a collision entre l'obstacle (oX,oY)
    # et le personnage en coordPx
    def isHit?(coordOb, coordPl)
        # Coordonnées de l'obstacle en pixels
        oX = coordOb[0]
        oY = coordOb[1]

        # Coordonnées du personnage
        x = coordPl[0].to_i
        y = coordPl[1].to_i

        rect1 = [x, y, Heros.SIZE[0], Heros.SIZE[1]]
        rect2 = [oX, oY, CELLSIZE, CELLSIZE]
    
        #puts "HitboxO : "
        #puts rect2

        return ((rect1[0] < rect2[0] + rect2[2] && rect1[0] + rect1[2] > rect2[0]) &&
                (rect1[1] < rect2[1] + rect2[3] && rect1[3] + rect1[1] > rect2[1])) 
    end

    # Récupérer une case aux coordonnées coord
    def getCase(coord)

        # Si les coordonnées sortent de la map => obstacle
        if ((coord[0]>@@WX-1 || coord[0]<0) || (coord[1]>@@HY-1 || coord[1]<0))
            return 1
        end

        return @grid[coord[1]][coord[0]]
    end

    # Getters statiques
    def self.WX
        @@WX
    end

    def self.HY
        @@HY
    end
end
