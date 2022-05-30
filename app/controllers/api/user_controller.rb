class Api::UserController < ApplicationController
    def create
        render json: User.create(user_params)
    end
    def index
        render json: User.paginate(:page => params[:page])
    end
    def new
        @user = User.new
        render json: @user
    end
    def update
        user = User.find_by_id(params[:id])
        user.update(user_params) if user
        render json: user
    end
    def show
        render json: User.find_by_id(params[:id])
    end
    def destroy
        User.delete(params[:id])
        render json: []
    end
    def typeahead
        mathes = []
        input_str = params[:input]
        User.type_matches(input_str).each do |user|
            mathes << user.firstName + '' + user.lastName
        end
        results = mathes.present? ? mathes.join(' and ') : ''
        render json: results
    end
    private
    def user_params
        params.permit(:firstName, :lastName, :email)
    end
end
