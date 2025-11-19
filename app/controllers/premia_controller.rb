class PremiaController < ApplicationController
  before_action :set_premium, only: %i[ show edit update destroy ]

  # GET /premia or /premia.json
  def index
    @premia = Premium.all
  end

  # GET /premia/1 or /premia/1.json
  def show
  end

  # GET /premium
  # Static landing page that explains premium benefits and provides a simple checkout CTA.
  def premium
    # This action is intentionally simple — the view is static and uses existing CSS.
  end

  # GET /premia/new
  def new
    @premium = Premium.new
  end

  # GET /premia/1/edit
  def edit
  end

  # POST /premia or /premia.json
  def create
    @premium = Premium.new(premium_params)

    respond_to do |format|
      if @premium.save
        format.html { redirect_to @premium, notice: "Premium was successfully created." }
        format.json { render :show, status: :created, location: @premium }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @premium.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /premia/1 or /premia/1.json
  def update
    respond_to do |format|
      if @premium.update(premium_params)
        format.html { redirect_to @premium, notice: "Premium was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @premium }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @premium.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /premia/1 or /premia/1.json
  def destroy
    @premium.destroy!

    respond_to do |format|
      format.html { redirect_to premia_path, notice: "Premium was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_premium
      @premium = Premium.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def premium_params
      params.expect(premium: [ :name, :price_cents ])
    end
end
