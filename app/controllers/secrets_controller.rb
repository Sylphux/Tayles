class SecretsController < ApplicationController
  before_action :set_secret, only: %i[ show edit update destroy ]

  # GET /secrets/1 or /secrets/1.json
  def show
  end

  # GET /secrets/new
  def new
    @node = Node.find(params[:node_id])
    @secret = Secret.new
  end

  # GET /secrets/1/edit
  def edit
  end

  # POST /secrets or /secrets.json
  def create
    @secret = Secret.new(secret_params)

    if @secret.save
      redirect_to node_path(Node.find(secret_params[:node_id]))
    end

    # respond_to do |format|
    #   if @secret.save
    #     format.html { redirect_to @secret, notice: "Secret was successfully created." }
    #     format.json { render :show, status: :created, location: @secret }
    #   else
    #     format.html { render :new, status: :unprocessable_entity }
    #     format.json { render json: @secret.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # PATCH/PUT /secrets/1 or /secrets/1.json
  def update

    if @secret.update(secret_params)
      redirect_to node_path(@secret.node.id)
    end

    # respond_to do |format|
    #   if @secret.update(secret_params)
    #     redirect_to node_path(@secret.node.id)
    #     # format.html { redirect_to @secret.node, notice: "Secret was successfully updated.", status: :see_other }
    #     # format.json { render :show, status: :ok, location: @secret }
    #   else
    #     format.html { render :edit, status: :unprocessable_entity }
    #     format.json { render json: @secret.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # DELETE /secrets/1 or /secrets/1.json
  def destroy
    
    for known in @secret.known_secrets do # delete toutes les découverrtes de cec secret
      known.destroy!
    end
    
    node = @secret.node

    if @secret.destroy!
      redirect_to node_path(node.id)
    end

    # respond_to do |format|
    #   format.html { redirect_to secrets_path, notice: "Secret was successfully destroyed.", status: :see_other }
    #   format.json { head :no_content }
    # end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_secret
      @secret = Secret.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def secret_params
      params.require(:secret).permit(:secret_title, :secret_content, :secret_order, :node_id)
    end

end
