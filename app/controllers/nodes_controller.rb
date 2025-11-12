class NodesController < ApplicationController
  before_action :set_node, only: %i[ show edit update destroy ]
  before_action :verify_show_access, only: [ :show ] # verifie si le user peut accéder au node

  # GET /nodes or /nodes.json
  def index
    @nodes = Node.all
  end

  # GET /nodes/1 or /nodes/1.json
  def show
    @node = Node.find(params[:id])
    @user_can_edit = node_edit_perm(@node)
    if @user_can_edit
      @node_secrets = @node.secrets
    else
      @node_secrets = grab_known_secrets(@node)
    end
  end

  # GET /nodes/new
  def new
    @node = Node.new
  end

  # GET /nodes/1/edit
  def edit
  end

  # POST /nodes or /nodes.json
  def create
    puts "### Create function ###"
    puts params
    node_spec = node_params

    if node_spec[:node_type] == "World"
      puts "### World type node ###"
      node_spec[:world_id] = nil
      #on crée à la fois un node world et son object world associé avec les mêmes specs
      new_world_node = Node.new(node_spec)
      new_world = World.new(world_name: node_spec[:node_title], description: node_spec[:public_description])
      respond_to do |format|
        if new_world_node.save && new_world.save
          new_world.node_id = new_world_node.id
          new_world_node.world_id = new_world.id
          new_world_ownership = WorldOwner.new(user: current_user, world: new_world)
          if new_world_node.save && new_world.save && new_world_ownership.save # on vérifie que tout s'enregistre correctement
            format.html { redirect_to :dashboard, notice: "World node, world object and world ownership were successfully created." }
          end
        else
          format.html { render :new, status: :unprocessable_entity }
          redirect_to new_node_path
        end
      end

    else #si ce n'est pas un world mais un node commun
      puts "### Common node ###"
      new_node = Node.new(node_spec)
      new_node.world_id = Node.find(node_spec[:world_id]).world_id
      savestate = false 
      if new_node.save
        puts "### Success saving new node ###"
        savestate = true
      end

      if params[:user_id]
        puts "### Is a user character node ###"
        savestate = false
        for link in Team.find(params[:team_id]).team_linkers.where(user_id: params[:user_id])
          if link.node_id == nil
            link.node_id = new_node.id
            if link.save && KnownNode.create(user_id: params[:user_id], node_id: new_node.id)
              savestate = true
              puts "### Node attributed to user in team #{link.team.name} and discovered ###"
            end
          end
        end
      end

      respond_to do |format|
        if savestate
          format.html { redirect_to node_path(new_node.id), notice: "Node was successfully created." }
        else
          format.html { render :new, status: :unprocessable_entity }
          redirect_to :dashboard
        end
      end

    end

  end

  # PATCH/PUT /nodes/1 or /nodes/1.json
  def update
    puts "### in patch ###"
    puts params
    if params[:node_action] == "Dissociate" # dissociation de user et personnage
      puts "### Dissociate action ###"
      for team_link in @node.team_linkers do
        team_link.node_id = nil
        team_link.save
        puts "### Team Link erased ###"
      end
    else
      params_set = node_params
      world_params = {world_name: params_set[:node_title], description: params_set[:public_description]}

      if @node.world.update(world_params)
        puts "### World params updated with node ###"
      end

      respond_to do |format|
        if @node.update(params_set)
          format.html { redirect_to @node, notice: "Node was successfully updated.", status: :see_other }
          format.json { render :show, status: :ok, location: @node }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @node.errors, status: :unprocessable_entity }
        end
      end
    end

  end

  # DELETE /nodes/1 or /nodes/1.json
  def destroy
    world_node = @node.world.node
    for known in @node.known_nodes do # delete les découvertes de ce noeud
      known.destroy!
      puts "### découverte destroyed ###"
    end
    if @node.node_type == "Character"
      for team_link in @node.team_linkers do # delete les associations avec des joueurs si personnage
        team_link.node_id = nil
        team_link.save
        puts "### Team Link erased ###"
      end
    end
    if @node.node_type == "World" # si le node est une monde
      for ownership in @node.world.world_owners do # On delete les ownership
        ownership.destroy!
      end
      the_world = @node.world
      for team in the_world.teams do # on delete les teams du monde et les invitations en cours
        for invite in team.team_invites do
          invite.destroy!
          puts "### Invite destroyed ###"
        end
        team.destroy!
        puts "### Team destroyed ##"
      end
      the_world.node_id = nil # dissociation world et node
      @node.world_id = nil # dissociation world et node
      if the_world.save && @node.save # si dissociation réussie
        the_world.destroy!
        puts "### world destroyed ###"
      end
    end
    type = @node.node_type
    if @node.destroy!
      puts "### Node successfully destroyed ##"
      if type != "World"
        redirect_to node_path(world_node.id)
      else
        redirect_to :dashboard
      end
    end
    # @node.destroy!

    # respond_to do |format|
    #   format.html { redirect_to nodes_path, notice: "Node was successfully destroyed.", status: :see_other }
    #   format.json { head :no_content }
    # end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_node
      @node = Node.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def node_params
      params.require(:node).permit(:node_title, :public_description, :node_type, :world_id)
    end

    def verify_show_access
      @node = Node.find(params[:id])
      if node_belongs_to_user?(@node) == false
        if node_is_known?(@node) == false
          redirect_to :dashboard
        end
      end
    end

end
