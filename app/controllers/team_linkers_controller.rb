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

    end
end
