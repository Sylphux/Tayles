class TeamLinkersController < ApplicationController
    def create

    end

    def destroy
        puts "### Team linker destroy function ###"
        puts params
        team = TeamLinker.find(params[:id]).team
        if TeamLinker.find(params[:id]).destroy
            puts "### Destroyed link between user and team ###"
            redirect_to team_path(team.id)
        else
            puts "### Could not destroy team linker ###"
        end
    end

    def update
        puts "### In team linker update function ! ###"
        puts params
        @team_linker = TeamLinker.find(params[:id])
        if @team_linker.update(team_linker_params)
            puts "### Team linker updated successfully ###"
            redirect_to team_path(@team_linker.team.id)
        end
    end

    private

    def team_linker_params
      params.permit(:user_id, :node_id, :id)
    end
end
