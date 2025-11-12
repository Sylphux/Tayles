class TeamsController < ApplicationController
  before_action :set_team, only: %i[ show edit update destroy ]
  before_action :verify_show_access, only: [:show]

  # GET /teams or /teams.json

  # GET /teams/1 or /teams/1.json
  def show
    @team = Team.find(params[:id])
    @owned = team_belongs_to_user(@team)
    @available_characters = []
    for char in @team.world.nodes.where(node_type: "Character") do
      if char.team_linkers == []
        @available_characters.push(char)
      end
    end
  end

  # GET /teams/new
  def new
    @team = Team.new
  end

  # GET /teams/1/edit
  def edit
  end

  # POST /teams or /teams.json
  def create
    @team = Team.new(team_params)

    respond_to do |format|
      if @team.save
        format.html { redirect_to @team, notice: "Team was successfully created." }
        format.json { render :show, status: :created, location: @team }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teams/1 or /teams/1.json
  def update
    respond_to do |format|
      if @team.update(team_params)
        format.html { redirect_to @team, notice: "Team was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @team }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teams/1 or /teams/1.json
  def destroy
    puts "### Destroy team ###"
    puts params

    team_world = @team.world.node

    for invite in @team.team_invites do
      invite.destroy!
      puts "### Destroyed invites ###"
    end

    for link in @team.team_linkers do
      link.destroy!
      puts "### Destroyed links ###"
    end

    if @team.destroy!
      redirect_to node_path(team_world.id)
    end

    # @team.destroy!

    # respond_to do |format|
    #   format.html { redirect_to teams_path, notice: "Team was successfully destroyed.", status: :see_other }
    #   format.json { head :no_content }
    # end
  end

  private

    def verify_show_access
      team = Team.find(params[:id])

      if team_belongs_to_user(team) == false && team_is_explored(team) == false
        redirect_to :dashboard
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_team
      @team = Team.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def team_params
      params.require(:team).permit(:name, :description, :world_id)
    end

end
