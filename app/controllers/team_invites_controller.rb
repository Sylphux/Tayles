class TeamInvitesController < ApplicationController
    def create
        puts "### Team invite create function ###"
        puts params
        if team_belongs_to_user(Team.find(params[:team_id])) #sécurité on vérifie si la team à la quelle on invite nous appartient
            if TeamInvite.where(invited_email_id: params[:email], team_id: params[:team_id], status: "Accepted") == [] && TeamInvite.where(invited_email_id: params[:email], team_id: params[:team_id], status: "Pending") == [] #vérifie qu'on a pas déjà une invite acceptée ou en cours pour cette personne dans ce monde. Si la personna a refusé, on peut donc lui en renvoyer une.
                if !Team.find(params[:team_id]).users.include? User.where(email: params[:email]).first #vérifie que l'user est tout de même pas déjà dans la team (à cause du seed)
                    puts "## Team seems to belong to user ##"
                    invite = TeamInvite.new(invited_email_id: params[:email], user: current_user, team_id: params[:team_id], status: "Pending")
                    if invite.invited_email_id != current_user.email && invite.save
                        puts "### Team invite saved successfully ##"
                        redirect_to team_path(invite.team.id)
                    else
                        puts "### Could not save invite ###"
                    end
                end
            end
        else
            puts "### Unauthorized action ###"
        end
    end
    
    def update
        invite = TeamInvite.find(params[:id])
        if params[:choice] == "Accept" # user accepte l'invitation à la team
            puts "### Invite accepted ###"
            new_link = TeamLinker.new(user: current_user, team: invite.team)
            puts "### Team linked ###"
            new_known_node = KnownNode.new(user: current_user, node: invite.team.world.node)
            puts "### World node discovered ###"
            if new_link.save && new_known_node.save
                invite.status = "Accepted"
                invite.save
                puts "### Accepted and done ###"
                redirect_to node_path(invite.team.world.node.id)
            else
                puts "### error while saving ###"
                redirect_to :dashboard
            end
        elsif params[:choice] == "Decline"
            invite.status = "Declined"
            invite.save
            puts "### Invite declined ###"
            redirect_to :dashboard
        end
    end

    def destroy
        puts "### Destroy function ###"
        puts params
        team = TeamInvite.find(params[:id]).team
        if TeamInvite.find(params[:id]).destroy
            puts "### Invite destroyed ###"
            redirect_to team_path(team.id)
        end
    end
end
