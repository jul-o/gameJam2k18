module ListSons
    MUSIQUE_FOND = ['resources/sons/fullMusic.ogg']
    SON_SPAWN = [0, 'resources/sons/spawn_mob.wav']
    SON_MINIGUN = [1, 'resources/sons/machinegun.wav']
    SON_REVOLVER = [2, 'resources/sons/revolver.wav']
    SON_BAZOOKA = [3, 'resources/sons/bazooka-tir.wav']
    SON_POMPE = [4, 'resources/sons/pompe.wav']
    SON_EXPLOSION = [5, 'resources/sons/explosion.wav']
    SON_MORT_BOSS = [6, "resources/sons/mort-boss.wav"]
    SON_ARRIVEE_BOSS = [7, 'resources/sons/gong_boss.wav']
    SON_BOSS_TOMBE = [8, 'resources/sons/fall-down.wav']
end

class Son
  @@INSTANCE = nil
  @@allSons = [ListSons::SON_SPAWN,     ListSons::SON_MINIGUN,   ListSons::SON_REVOLVER,      ListSons::SON_BAZOOKA, ListSons::SON_POMPE,
                ListSons::SON_EXPLOSION, ListSons::SON_MORT_BOSS, ListSons::SON_ARRIVEE_BOSS, ListSons::SON_BOSS_TOMBE]

  def initialize
    @sonsCharges = Array.new
    @@allSons.each do |ficSon|
      son = Gosu::Sample.new(ficSon[1])
      @sonsCharges << son
    end

    # On joue la musique de fond
    @music = Gosu::Song.new(ListSons::MUSIQUE_FOND[0])
    @music.volume = 0.10
    @music.play(true)
  end
    
  def self.INST
    if (@@INSTANCE.nil?) then
      @@INSTANCE = self.new
    end
    @@INSTANCE
  end

  def playSon(idSon)
      #puts idSon
    case idSon
      when ListSons::SON_MORT_BOSS[0]
        @sonsCharges[idSon].play(0.8,1,false)
      when ListSons::SON_MINIGUN[0]
        @sonsCharges[idSon].play(0.1,1,false)
      when ListSons::SON_EXPLOSION[0]
        @sonsCharges[idSon].play(0.05,1.2,false)
      when ListSons::SON_SPAWN[0]
        @sonsCharges[idSon].play(0.02,1,false)
      when ListSons::SON_BAZOOKA[0]
        @sonsCharges[idSon].play(0.10,1,false)
      when ListSons::SON_POMPE[0]
        @sonsCharges[idSon].play(0.15,1,false)
      else
        @sonsCharges[idSon].play(0.4,1,false)
    end
  end
end