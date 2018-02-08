module Tiles
    VIDE = -1                                                 #  0
    BLOC_PIERRE1   = "resources/tileset/blocPierre1.png"      #  1 
    BLOC_PIERRE2   = "resources/tileset/blocPierre2.png"      #  2
    BLOC_PIERRE3   = "resources/tileset/blocPierre3.png"      #  3
    BLOC_PIERRE4   = "resources/tileset/blocPierre4.png"      #  4
    BLOC_PIERRE5   = "resources/tileset/blocPierre5.png"      #  5
    BLOC_PIERRE6   = "resources/tileset/blocPierre6.png"      #  6
    BRIQUE_GRISE1  = "resources/tileset/briqueGrise1.png"     #  7
    BRIQUE_GRISE2  = "resources/tileset/briqueGrise2.png"     #  8
    BRIQUE_MOUSSE1 = "resources/tileset/briqueMousse1.png"    #  9
    BRIQUE_MOUSSE2 = "resources/tileset/briqueMousse2.png"    # 10
    BLOC_BOIS1     = "resources/tileset/blocBois1.png"        # 11
    BLOC_LISSE     = "resources/tileset/blocLisse.png"        # 12
    BLOC_BRIQUE1   = "resources/tileset/blocBrique1.png"      # 13 
    BLOC_BRIQUE2   = "resources/tileset/blocBrique2.png"      # 14
    BLOC_BRIQUE3   = "resources/tileset/blocBrique3.png"      # 15
    BLOC_BRIQUE4   = "resources/tileset/blocBrique4.png"      # 16 
    BLOC_BRIQUE5   = "resources/tileset/blocBrique5.png"      # 17
    BLOC_BRIQUE6   = "resources/tileset/blocBrique6.png"      # 18
    BLOC_BRIQUE7   = "resources/tileset/blocBrique7.png"      # 19
end

class Map
    @@WX, @@HY = 17,14

    CELLSIZE = 45

    @@INSTANCE = nil

    def initialize

        # Définition des éléments visuels
        @tiles = [Tiles::VIDE,          Tiles::BLOC_PIERRE1,   Tiles::BLOC_PIERRE2,   Tiles::BLOC_PIERRE3,
                  Tiles::BLOC_PIERRE4,  Tiles::BLOC_PIERRE5,   Tiles::BLOC_PIERRE6,   Tiles::BRIQUE_GRISE1,
                  Tiles::BRIQUE_GRISE2, Tiles::BRIQUE_MOUSSE1, Tiles::BRIQUE_MOUSSE2, Tiles::BLOC_BOIS1,
                  Tiles::BLOC_LISSE,    Tiles::BLOC_BRIQUE1,   Tiles::BLOC_BRIQUE2,   Tiles::BLOC_BRIQUE3,                
                  Tiles::BLOC_BRIQUE4,  Tiles::BLOC_BRIQUE5,   Tiles::BLOC_BRIQUE6,   Tiles::BLOC_BRIQUE7]

        @tilesImg = []
        @tiles.each do |fileI|
            @tilesImg << Gosu::Image.new(fileI, :tileable => true) if (fileI != -1)
        end

        # Définition du contenu de la map
        @viewGrid = [[17,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,16],
                     [14,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,15],
                     [15,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,14],
                     [14,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,17],
                     [17,0,0,0,0,0,8,8,8,8,8,0,0,0,0,0,14],
                     [16,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,15],
                     [15,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,16],
                     [14,8,8,8,8,0,0,0,0,0,0,0,8,8,8,8,17],
                     [17,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,14],
                     [14,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,15],
                     [15,0,0,0,0,0,8,8,8,8,8,0,0,0,0,0,14],
                     [14,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,17],
                     [17,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,14],
                     [12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12]]

        @@INSTANCE = self
    end

    # Dessin de la map
    def draw
        x = 0
        y = 0

        @viewGrid.each do |line|
            #offSet = 0
            line.each do |cell|
                # Calcul des ratios x\y
                ratioX = CELLSIZE.to_f/@tilesImg[cell-1].width.to_f
                ratioY = CELLSIZE.to_f/@tilesImg[cell-1].height.to_f  

                @tilesImg[cell-1].draw x*CELLSIZE,y*CELLSIZE, 0, ratioX, ratioY if cell!=0
                x=x+1
                #offSet+=5
            end
            x=0
            y=y+1
        end
    end


    # Renvoie true s'il y a collision entre l'obstacle (oX,oY)
    # et l'élément en coordPx de dimension size
    def isHit?(coordOb, coordPl, size)
        # Coordonnées de l'obstacle en pixels
        oX = coordOb[0]
        oY = coordOb[1]

        # Coordonnées du personnage
        x = coordPl[0].to_i
        y = coordPl[1].to_i

        rect1 = [x, y, size[0], size[1]]
        rect2 = [oX, oY, CELLSIZE, CELLSIZE]

        return ((rect1[0] < rect2[0] + rect2[2] && rect1[0] + rect1[2] > rect2[0]) &&
                (rect1[1] < rect2[1] + rect2[3] && rect1[3] + rect1[1] > rect2[1])) 
    end


    # Collision du personnage
    # ==========================================================
    # Renvoie vrai s'il y a collison aux coordonnées pixel coord
    def obstAt?(coordPx)
        # Pour chaque obstacle on vérifie les collisions
        x = 0
        y = 0

        @viewGrid.each do |line|
            line.each do |cell|
                if (cell!=0) then
                    obstCoordPx = [x*CELLSIZE, y*CELLSIZE]
                    return true if (isHit?(obstCoordPx, coordPx, Heros.SIZE))    
                end
                x=x+1
            end
            x=0
            y=y+1
        end

        return false
    end

    # Collision des projectiles
    # ===============================================

    # Renvoie vrai s'il y a collision aux coordonnées pixel coord
    # entre le projectile et un obstacle
    def obstAt_Project?(coordPx, sizePJ)
        # Pour chaque obstacle on vérifie les collisions
        x = 0
        y = 0

        @viewGrid.each do |line|
            line.each do |cell|
                if (cell!=0) then
                    obstCoordPx = [x*CELLSIZE, y*CELLSIZE]
                    return true if (isHit?(obstCoordPx, coordPx, [sizePJ,sizePJ]))    
                end
                x=x+1
            end
            x=0
            y=y+1
        end

        return false
    end

    
    # Récupérer une case aux coordonnées coord
    def getCase(coord)

        # Si les coordonnées sortent de la map => obstacle
        if ((coord[0]>@@WX-1 || coord[0]<0) || (coord[1]>@@HY-1 || coord[1]<0))
            return 1
        end

        return @viewGrid[coord[1]][coord[0]]
    end

    # Getters statiques
    def self.WX
        @@WX
    end

    def self.HY
        @@HY
    end

    # Renvoie l'instance de map
    def self.INST
        return @@INSTANCE
    end
    def self.coordToPx(coord)
        x = (coord[0]*(Game.WIDTH/Map.WX.to_f)).to_i
        y = (coord[1]*(Game.HEIGHT/Map.HY.to_f)).to_i

        return [x-1,y-1]
    end

    def self.pxToCoord
        rx = (((@x.to_f+@sizeX)/Game.WIDTH)*Map.WX).to_i
        ry = (((@y.to_f+@sizeY)/Game.HEIGHT)*Map.HY).to_i

        return [rx-1,ry-1]
    end
end
