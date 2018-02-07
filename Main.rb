require 'gosu'
require_relative 'Game'
require_relative 'Menu'

$ETAT_PLAY = 0
$ETAT_CLOSE = 1
$ETAT_PERDU = 2
$ETAT_NULL = 3

$fenetre = 1

$ETAT = $ETAT_PERDU
while true

  case $ETAT
    when $ETAT_CLOSE
      puts "close"
      exit
    when $ETAT_PERDU
      puts "perdu"
      $ETAT = $ETAT_NULL
      $fenetre = Menu.new
    when $ETAT_PLAY
      puts "play"
      $ETAT = $ETAT_NULL
      $fenetre = Game.new
    else
      puts "null"

  end
end
