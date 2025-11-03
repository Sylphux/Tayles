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
    @node = Node.new(node_params)

    respond_to do |format|
      if @node.save
        format.html { redirect_to @node, notice: "Node was successfully created." }
        format.json { render :show, status: :created, location: @node }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @node.errors, status: :unprocessable_entity }
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
      params.fetch(:node, {})
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
