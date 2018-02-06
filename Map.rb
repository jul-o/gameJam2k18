class Map
    @@WX, @@HY = 17,14

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
