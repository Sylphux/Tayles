module SessionsHelper
    def shorten_text(s, n) # shorten a string / text. s is the input string, n is the desired length
        if s.length > n
            return (s[0..n-3] + "...")
        end
        s
    end

    def node_edit_perm(node) # can current user edit this node or not ?
        # si créateur du node
        for world in current_user.worlds
            if node.world == world
                return true
            end
        end
        # si player character
        for team_link in current_user.team_linkers do
            if node == team_link.node
                return true
            end
        end
        false
    end

    def explored_worlds
        result = []
        for t in current_user.teams do
            result.push(t.world.node)
        end
        result
    end

    def node_belongs_to_user?(n) # verifies if node belongs to user
        for u in n.world.users
            if u == current_user
                return true
            end
        end
        false
    end

    def who_knows_secret_in_teams(secret, teams)
        result = []
        for team in teams do
            for user in team.users do
                if user.secrets.include? secret
                    if !(result.include? user)
                        result.push(user)
                    end
                end
            end
        end
        result
    end

    def teams_who_doesnt_know_secret(secret, teams)
        result = []
        for team in teams do
            for user in team.users do
                if !(user.secrets.include? secret)
                    result.push(team)
                    break # goes to scan next team
                end
            end
        end
        result
    end

    def users_who_dont_know_secret(secret, teams)
        result = []
        for team in teams do
            for user in team.users do # ne vérifie pas si user connait déjà le node ou pas. Donc si on débloque le secret il faut aussi débloquer le node en mm temps.
                if !(user.secrets.include? secret)
                    if !(result.include? user)
                        result.push(user)
                    end
                end
            end
        end
        result
    end

    def get_player_character(t, u) # gets a players character node (t is team and u is user)
        if u.team_linkers.where(team_id: t.id).first.node
            u.team_linkers.where(team_id: t.id).first.node
        else
            false
        end
    end

    def node_is_known?(n) # verifies if node is known by user (so user is an explorer)
        for u in n.users
            if u == current_user
                return true
            end
        end
        false
    end

    def team_belongs_to_user(t)
        for w in current_user.worlds do
            for team in w.teams do
                if team == t
                    return true
                end
            end
        end
        false
    end

    def team_is_explored(t)
        for user in t.users
            if user == current_user
                return true
            end
        end
        false
    end

    def node_discovered_on(n) # gives the date node was revealed to
        for known in KnownNode.where(node: n, user: current_user)
            return known.created_at
        end
        "Not discovered yet."
    end

    def user_teams(n) # returns the team on which user is exploring the world
        # for t in n.world.teams do
        #     for u in t.users do
        #         if u == current_user
        #             return t
        #         end
        #     end
        # end
        current_user.teams.where(world_id: n.world.id)
    end

    def grab_known_secrets(n)
        secret_array = []
        for secret in n.secrets do
            for u in secret.users do
                if u == current_user
                    secret_array.push(secret)
                end
            end
        end
        secret_array
    end

    def my_character(n) # gets user character for this node
        team = user_teams(n).first
        for g in team.team_linkers do
            if current_user == g.user
                return g.node
            end
        end
        nil
    end

    def has_not_discovered_node(node) # return les membres des teams du monde qui n'ont pas encore découvert le node
        result = []
        for team in node.world.teams
            for user in team.users do
                if user.nodes.where(id: node.id) == []
                    if !(result.include? user)
                        result.push(user)
                    end
                end
            end
        end
        result
    end

    def get_known_relative_nodes(node) # gets known nodes relative to the input one
        all_nodes = []
        for n in node.world.nodes do
            if n != node
                if node_belongs_to_user?(n)
                    all_nodes.push(n)
                elsif node_is_known?(n)
                    all_nodes.push(n)
                end
            end
        end
        all_nodes
    end

    def count_nodes_and_secrets(n)
        node_count = 0
        secret_count = 0
        for n in n.world.nodes do
            for s in n.secrets do
                secret_count += 1
            end
            node_count += 1
        end
        { nodes: node_count, secrets: secret_count }
    end

    def verify_new_node_format(par)
        case par
        when "Character"
            return "Character"
        when "Place"
            return "Place"
        when "Event"
            return "Event"
        when "Object"
            return "Object"
        when "World"
            return "World"
        end
        nil
    end

    def ntypes
        [ "Character", "Place", "Event", "Object" ]
    end
end
