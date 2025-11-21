# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'faker'

puts 'Destroying data'
KnownNode.destroy_all
KnownSecret.destroy_all
TeamLinker.destroy_all
WorldOwner.destroy_all
Secret.destroy_all
Team.destroy_all
World.destroy_all
Node.destroy_all
User.destroy_all

number_of_worlds = 15
number_of_users = 8
number_of_random_nodes = 300
number_of_secrets = 600
number_of_teams = 10

puts 'Creating users'
number_of_users.times do
    name = Faker::Name.name
    User.create(
        username: name,
        email: "#{name.split(' ').join('.')}#{rand(1800..2025)}@yopmail.com",
        password: "coolos",
        subscribed: false
    )
end

puts 'Creating worlds and world nodes'
worldnumber = 0
number_of_worlds.times do
    worldname = Faker::Fantasy::Tolkien.location
    World.create(
        world_name: worldname,
        description: Faker::Books::Lovecraft.paragraph,
    )
    Node.create(
        node_type: "World",
        node_title: "#{worldname}",
        public_description: Faker::Books::Lovecraft.paragraph,
    )
    worldnumber += 1
end

worldnumber = 0
number_of_worlds.times do
    myworld = World.find(World.first.id + worldnumber)
    myworld.node_id = Node.first.id + worldnumber
    myworld.save

    mynode = Node.find(Node.first.id + worldnumber)
    mynode.world_id = World.first.id + worldnumber
    mynode.save

    worldnumber += 1
end

node_type = [ "World", "Character", "Object", "Event", "Place" ]

puts 'Creating random nodes'
number_of_random_nodes.times do
    Node.create(
        world_id: rand(World.first.id..World.last.id),
        node_type: node_type[rand(1..4)],
        node_title: Faker::Books::Lovecraft.word,
        public_description: Faker::Books::Lovecraft.paragraph
    )
end

puts 'Creating random secrets'
number_of_secrets.times do
    Secret.create(
        node_id: rand(Node.first.id..Node.last.id),
        secret_title: Faker::Games::SuperSmashBros.stage,
        secret_content: Faker::Games::Fallout.quote,
        secret_order: rand(1..20)
    )
end

puts "Creating teams"
number_of_teams.times do
    Team.create(
        name: "Team #{Faker::Games::Fallout.faction}",
        description: Faker::Games::Witcher.quote,
        world_id: rand(World.first.id..World.last.id)
    )
end

puts "Giving ownership of worlds"
i = 1
while i <= number_of_worlds do
    if i > number_of_users
        user_id_gen = rand(User.first.id..User.last.id)
    else
        user_id_gen = User.first.id + i
    end
    WorldOwner.create(
        world_id: World.first.id + i,
        user_id: user_id_gen
    )
    i += 1
end

puts "Linking secrets and nodes to users"

number_of_secrets.times do
    defined_user_id = rand(User.first.id..User.last.id)
    defined_secret_id = rand(Secret.first.id..Secret.last.id)

    while Secret.find(defined_secret_id).node.world.users.exists?(defined_user_id) # cherche un secret qui n'appartient pas à un monde du user (on n'attribue les secrets qu'aux explorateurs)
        defined_secret_id = rand(Secret.first.id..Secret.last.id)
    end

    if rand(1..4) == 1
        KnownSecret.create(
            user_id: defined_user_id,
            secret_id: defined_secret_id
        )
    end
    KnownNode.create(
        node_id: Secret.find(defined_secret_id).node.id,
        user_id: defined_user_id
    )
end

puts "Linking users to teams & creating player characters"
x = 0
defined_user_id = User.first.id

number_of_teams.times do
    defined_team_id = Team.first.id + x

    4.times do
        if User.last.id < defined_user_id
            defined_user_id = User.first.id
        end

        while Team.find(defined_team_id).world.users.exists?(defined_user_id) # Cherche un joueur pas MJ
            defined_user_id += 1
            if User.last.id < defined_user_id
                defined_user_id = User.first.id
            end
        end

        # On crée un character pour le user dans la team
        defined_character_node_id = Node.create(
            world_id: Team.find(defined_team_id).world_id,
            node_type: "Character",
            node_title: Faker::Games::Witcher.character,
            public_description: Faker::Books::Lovecraft.paragraph
        ).id

        KnownNode.create(
            node_id: defined_character_node_id,
            user_id: defined_user_id
        )

        TeamLinker.create(
            user_id: defined_user_id,
            team_id: defined_team_id,
            node_id: defined_character_node_id
        )

        # fiving player access to the world node
        KnownNode.create(
            user_id: defined_user_id,
            node_id: Team.find(defined_team_id).world.node.id
        )
        defined_user_id += 1
    end
    x += 1
end


### Cleaning stuff doubles and wrong stuff ###
puts "Cleaning seed sloppiness..."
puts "- Deleting worlds with no users"
for world in World.all do
    if world.users == []
        for node in world.nodes do
            for known in node.known_nodes do
                known.destroy!
            end
            for secret in node.secrets do
                for known in secret.known_secrets do
                    known.destroy!
                end
                secret.destroy!
            end
            world.node = nil
            world.save
            node.destroy!
        end
        for team in world.teams do
            for link in team.team_linkers do
                link.destroy!
            end
            team.destroy!
        end
        world.destroy!
    end
end

puts "- Deleting duplicate KnownSecrets"
for known in KnownSecret.all do
    for compared_known in KnownSecret.all do
        puts "# Comparing secret #{known.secret.secret_title} to #{compared_known.secret.secret_title}"
        if known.user == compared_known.user && known.secret == compared_known.secret
            compared_known.destroy!
        end
    end
end

puts "- Deleting duplicate KnownNodes"
# for known in KnownNode.all do
#     for compared_known in KnownNode.all do
#         puts "# Comparing node #{known.node.node_title} to #{compared_known.node.node_title}"
#         if known.user == compared_known.user && known.node == compared_known.node
#             compared_known.destroy!
#             puts "## destroyed node"
#         end
#     end
# end

for user in User.all do
    for node in user.nodes do
        while KnownNode.where(user: user, node: node).count > 1
            puts "# Multiple links with #{node.node_title} found"
            KnownNode.where(user: user, node: node).last.destroy!
        end
    end
end
