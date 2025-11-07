module SessionsHelper
    def shorten_text(s, n) # shorten a string / text. s is the input string, n is the desired length
        if s.length > n
            return (s[0..n-3] + "...")
        end
        s
    end

    def explored_worlds
        result = []
        for t in current_user.teams do
            result.push(t.world.node)
        end
        return result
    end

    def node_belongs_to_user?(n) # verifies if node belongs to user
        for u in n.world.users
            if u == current_user
                return true
            end
        end
        false
    end

    def node_is_known?(n) # verifies if node is known by user (so user is an explorer)
        for u in n.users
            if u == current_user
                return true
            end
        end
        false
    end

    def node_discovered_on(n) # gives the date node was revealed to current user
        for x in n.known_nodes
            if x.user == current_user
                return x.created_at
            else
                return "(Error : User not found in known nodes)"
            end
        end
        "(Error : No known nodes)"
    end

    def user_team(n) # returns the team on which user is exploring the world
        for t in n.world.teams do
            for u in t.users do
                if u == current_user
                    return t
                end
            end
        end
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
        team = user_team(n)
        for g in team.team_linkers do
            if current_user == g.user
                return g.node
            end
        end
        nil
    end

    def get_known_relative_nodes(n) # gets known nodes relative to the input one
        all_nodes = []
        for n in n.world.nodes do
            if n.node_type != "World"
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
end
