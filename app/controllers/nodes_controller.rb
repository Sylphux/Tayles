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
    @posessed = node_belongs_to_user?(@node)
    if @posessed
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
    puts params
    node_spec = node_params

    if node_spec[:node_type] == "World"

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

      new_node = Node.new(node_spec)

      respond_to do |format|
        if new_node.save
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
    respond_to do |format|
      if @node.update(node_params)
        format.html { redirect_to @node, notice: "Node was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @node }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @node.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /nodes/1 or /nodes/1.json
  def destroy
    @node.destroy!

    respond_to do |format|
      format.html { redirect_to nodes_path, notice: "Node was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
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
