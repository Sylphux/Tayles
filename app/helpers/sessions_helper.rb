module SessionsHelper
    def shorten_text(s, n)
        if s.length > n
            return (s[0..n-3] + "...")
        end
        return s
    end

    def node_belongs_to_user?(n)
        for u in n.world.users
            if u == current_user
                return true
            end
        end
        return false
    end

    def node_is_known?(n)
        for u in n.users
            if u == current_user
                return true
            end
        end
        return false
    end

    def node_discovered_on(n)
        for x in n.known_nodes
            if x.user == current_user
                return x.created_at
            end
        end
    end

    def user_team(n)
        for t in n.world.teams do
            for u in t.users do
                if u == current_user
                    return t.name
                end
            end
        end
    end
end