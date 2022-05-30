require 'rails_helper'

RSpec.describe Api::UserController do

  describe 'GET #index' do
    before do
      get :index
    end

    it 'is expected to assign user instance variable' do
      body = JSON.parse(response.body)
      expect(body).to eq(User.paginate(page:1).as_json)
    end
  end

  describe 'GET #new' do
    before do
      get :new
    end

    it 'is expected to assign user as new instance variable' do
      # body = JSON.parse(response.body)
      # binding.pry
      body = JSON.parse(response.body, object_class: User)
      expect(body).to be_instance_of(User)
    end
  end

  describe 'POST #create' do
    let(:params) { { user: { firstName: "Shreekanth", lastName: "B", email:"xyz@gmail.com" } } }
    before do
      post :create, params: params
    end

    context 'when params are correct' do
    
      it 'is expected to create new user successfully' do
        body = JSON.parse(response.body, object_class: User)
        expect(body).to be_instance_of(User)
      end
      it 'is expected to have firstname lastName email assigned to it' do
        expect(params[:user][:firstName]).to eq('Shreekanth')
        expect(params[:user][:lastName]).to eq('B')
        expect(params[:user][:email]).to eq('xyz@gmail.com')
      end
    end

    # context 'when params are not correct' do
    #   let(:params) { { user: { firstName: '', lastName: '', email:'' } } }

    #   it 'is expected to add errors to name attribute' do
    #     binding.pry
    #     expect(params[:user].errors[:firstName]).to eq(['can\'t be blank'])
    #     expect(params[:user].errors[:lastName]).to eq(['can\'t be blank'])
    #     expect(params[:user].errors[:email]).to eq(['can\'t be blank'])
    #   end
    # end
  end

  # describe 'GET #update' do
  #   before do
  #     get :update, params: params
  #   end

  #   context 'when user id is valid' do
  #     let(:user) { FactoryBot.create :user }
  #     let(:params) { { id: user.id } }

  #     it 'is expected to set user instance variable' do
  #       expect(assigns[:user]).to eq(User.find_by(id: params[:id]))
  #     end
  # it 'is expected to set flash message' do
  #   expect(flash[:notice]).to eq('User has been updated Successfully.')
  # end
  # #     it 'is expected to render edit template' do
  #       is_expected.to render_template(:edit)
  #     end
  #   end

  #   context 'when user id is invalid' do
  #     let(:params) { { id: Faker::Number.number } }

  #     it 'is expected to redirect_to users path' do
  #       is_expected.to redirect_to(users_path)
  #     end

  #     it 'is expected to set flash' do
  #       expect(flash[:notice]).to eq('User not found.')
  #     end
  #   end

  # end
  describe 'GET #typeahead' do
    let(:params) {{input: "Shree"}}
    before do
      get :typeahead, params: params
    end
    context 'is expected to match user with input' do
      let(:user1) {FactoryBot.create(:user,{:firstName =>"Shreekanth", :lastName =>"B", :email =>"def@yopmail.com"})}
      let(:user2) {FactoryBot.create(:user,{:firstName =>"Woeeier", :lastName =>"B", :email =>"abc@gmail.com"})}
      context 'when user is provided' do
        it 'is expected to match user with input' do
          body = response.body.split(' and ')
          expect(body.length).to eq(1)
        end
      end
    end
  end
  describe 'GET #show' do
    before do
      get :show, params: params
    end
    context 'is expected to show user by id' do
      let(:user) {FactoryBot.create :user}
      let(:params) {{id: user.id}}
      context 'when user is provided' do
        it 'is expect to show user by id' do
          body = JSON.parse(response.body)
          expect(user.as_json).to eq(body)
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    before do
      delete :destroy, params: params
    end
    context 'is expected to delete user by id' do
      let(:user) {FactoryBot.create :user}
      let(:params) {{id: user.id}}
      context 'when user is provided' do
        it 'should destroy' do
          delete :destroy, params: { id: user.id }
          expect(User.find_by_id(user.id)).to eq(nil)
        end
      end
    end
  end

  describe 'PATCH #update' do

    before do
      patch :update, params: params
    end
    
    context 'when user exist in database' do
      let(:user) { FactoryBot.create :user }
      let(:params) { { id: user.id, user: { firstName: 'test name',lastName: 'LastName', email:'test email' } } }

      context 'when data is provided is valid' do
        it 'is expected to update user' do
          expect(params[:user][:firstName]).to eq('test name')
          expect(params[:user][:lastName]).to eq('LastName')
          expect(params[:user][:email]).to eq('test email')
        end

        # it 'is_expected to redirect_to users_path' do
        #   is_expected.to redirect_to(users_path)
        # end
      end

      # context 'when data is invalid' do
      #   let(:user) { FactoryBot.create :user }
      #   let(:params) { { id: user.id, user: { name: '' } } }

      #   it 'is expected not to update user name' do
      #     expect(user.reload.name).not_to be_empty
      #   end

      #   it 'is expected to render edit template' do
      #     expect(response).to render_template(:edit)
      #   end

      #   it 'is expected to add errors to user name attribute' do
      #     expect(assigns[:user].errors[:name]).to eq(['can\'t be blank'])
      #   end
      # end
    end
  end
end