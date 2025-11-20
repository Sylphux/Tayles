class KnownSecretsController < ApplicationController

  def create
    puts "### In create secret link ###"
    puts params
    secret = Secret.find(params[:secret_id])  
    

    if params[:user_id]
      add_secret_to_user(secret, User.find(params[:user_id]))
    elsif params[:team_id]
      team = Team.find(params[:team_id])
      for user in team.users do
        add_secret_to_user(secret, user)
      end
      # ajouter le secret à tous les membres de la team
    else
      puts "### Wrong parameters ###"
      return
    end

    # redirect_to node_path(secret.node)

  end

  def destroy
    known_secret = KnownSecret.find(params[:id])
    node = known_secret.secret.node
    if known_secret.destroy!
      puts "### Success destroying known secret ###"
      # redirect_to node
    end
  end

  private

  def add_secret_to_user(secret, user)

    if !(user.nodes.include? secret.node) # si user ne connait pas encore le node mais se fait révéler le secret
      if KnownNode.create(user: user, node: secret.node)
        puts "#### Success assigning node knownledge ###"
      end
    end

    if !(user.secrets.include? secret)
      if KnownSecret.create(secret: secret, user: user)
        puts "#### Success assigning secret ###"
      end
    end

  end 

end
