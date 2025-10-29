# Tayles

Tayles is a RPG campaign manager. Is is suited for GMs wanting to create a concrete organisation for a world, but also for players who are exploring this world.

## What is so special about Tayles ?

What makes Tayles special is the ability for GMs to reveal nodes (characters, objects, events, places) and their individual secrets to the players.

For example, "House of Matilda" is a Place type node.
This place has many secrets, for example "The hidden trapdoor".

This secret can be revealed to specific players or to the full players team by the GM.

If a player knows about this secret, he can himself choose to reveal it to the other players in his team.

## Versions

### What will be available in the MVP version 

In the MVP version, Users will be able to create worlds and explore them. Here is a list of promised features :
- Create user accounts
- A dashboard showing all created/known worlds and known nodes with a searchbar that dynamically searchs for nodes and worlds and actualises the dashboard in real time.
- Creating worlds
- Creating all types of nodes in this world
- A node page with public description and secrets, with a sidebar containing related nodes.
- For each node page, an edit/view (and save) mode
- Creating player teams for specific worlds
- Creating a Player Character node for each team member
- Unlocking node access to players
- Unlocking node secrets to players

### What will be available in the Final version

Here are the features we want to get to work in the final version of Tayles.
- Nodes and secret descriptions can be formatted in MD format
- A browsable database of parent-child nodes (for example, France node is parent to Paris node)
- Possibility to create fast link to other nodes in one node with a specific formatting
- Adding a GM to a world (simple but not prioritary)

## Requirements

You need rails 8.0.3 and ruby 3.4.2 to work on this project.

After making sure of this, you can install and start the app :

```shell
bundle install
rails db:migrate
rails db:seed
rails s
```