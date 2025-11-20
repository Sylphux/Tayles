class KnownNodesController < ApplicationController

    def destroy
        puts "### In known nodes destroy ###"
        @known_node = KnownNode.find(params[:id])
        @node = @known_node.node
        if @known_node.destroy
            puts "### Succes destroying knownledge ###"
            # redirect_to node_path(@node)
        else
            puts "### Error trying to destroy known node ###"
        end
    end

    def create
        puts "### In knowon nodes create ###"
        @node = Node.find(params[:node_id])

        if params[:team_id] # Si on doit créer des liens pour tous les membres de la team
            for user in Team.find(params[:team_id]).users do
                if !(user.nodes.include? @node)
                    if KnownNode.create(user: user, node: @node)
                        puts "### #{user} now known #{@node} ###"
                    end
                end
            end
            # redirect_to node_path(params[:node_id])
        end

        if params[:user_id]
            user = User.find(params[:user_id])
            if KnownNode.create(user: user, node: @node)
                puts "### #{user.username} now knows #{@node.node_title} ###"
                # redirect_to node_path(@node)
            end
        end

    end

end
