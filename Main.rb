require 'gosu'
require_relative 'Game'
require_relative 'Menu'
require_relative 'Son'

# On initialise tous les sons
Son.INST

$menu = Menu.new