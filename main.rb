require_relative 'lib/managers/game'

require_relative 'lib/managers/producer'

# Load the save if the player wants to
p 'Do you want to load a save? (y/n)'
manager = if gets.chomp == 'y'
            p 'What save do you want to load'
            GameManager.load gets.chomp
          else
            GameManager.new
          end

# Initialize the primal core
ProducerManager.new({'air' => 5, 'earth' => 4, 'water' => 3, 'fire' => 2}, 'Primal Core', manager, 1)

# Add all the recipes
manager.crafter.add_recipe!({'water' => 2, 'earth' => 5}, ElementManager.new('mud'))
manager.crafter.add_recipe!({'air' => 3, 'fire' => 1}, ElementManager.new('heat'))
manager.crafter.add_recipe!({'earth' => 20, 'fire' => 40}, ElementManager.new('lava'))
manager.crafter.add_recipe!({'lava' => 20, 'water' => 10}, ElementManager.new('obsidian'))
manager.crafter.add_recipe!({'heat' => 100, 'fire' => 20}, ElementManager.new('energy'))
manager.crafter.add_recipe!({'water' => 20, 'fire' => 30}, ElementManager.new('steam'))
manager.crafter.add_recipe!({'air' => 30, 'fire' => 20}, ElementManager.new('wind'))
manager.crafter.add_recipe!({'lava' => 20, 'wind' => 10}, ElementManager.new('stone'))
manager.crafter.add_recipe!({'stone' => 30, 'wind' => 50}, ElementManager.new('gravel'))
manager.crafter.add_recipe!({'gravel' => 30, 'wind' => 50}, ElementManager.new('sand'))
manager.crafter.add_recipe!({'mud' => 20, 'sand' => 20}, ElementManager.new('clay'))
manager.crafter.add_recipe!({'sand' => 20, 'heat' => 70}, ElementManager.new('glass'))
manager.crafter.add_recipe!({'gravel' => 20, 'heat' => 70}, ElementManager.new('concrete'))
manager.crafter.add_recipe!({'clay' => 20, 'heat' => 70}, ElementManager.new('brick'))
manager.crafter.add_recipe!({'mud' => 30, 'energy' => 100}, ElementManager.new('organism'))

loop do # Main loop
  # Make a new clone
  clone = manager.clone

  # Make the manager equal clone.tick (immutable). Execute in new thread
  Thread.new { manager = clone.tick }.join

  # Log the critical vals
  clone.log_vals

  # Get the command and eval it, mainly for debugging and testing
  p 'Command for this run, if no command, press Enter'
  eval gets.chomp

  # Sleep between executions of the loop for 1 second
  sleep 1
end
