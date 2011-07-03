require 'spec_helper'

describe ProjectsController do
  render_views

  describe "access control" do

    it "should deny access to 'create'" do
      post :create
      response.should redirect_to(signin_path)
    end

    it "should deny access to 'destroy'" do
      delete :destroy, :id => 1
      response.should redirect_to(signin_path)
    end
  end
  
  describe "POST 'create'" do

    before(:each) do
      @user = test_sign_in(Factory(:user))
    end

    describe "failure" do

      before(:each) do
        @attr = { :title => "" }
      end

      it "should not create a project" do
        lambda do
          post :create, :project => @attr
        end.should_not change(Project, :count)
      end

      it "should render the home page" do
        post :create, :project => @attr
        response.should render_template('pages/home')
      end
    end

    describe "success" do

      before(:each) do
        @attr = { :title => "Lorem ipsum" }
      end

      it "should create a project" do
        lambda do
          post :create, :project => @attr
        end.should change(Project, :count).by(1)
      end

      it "should redirect to the home page" do
        post :create, :project => @attr
        response.should redirect_to(root_path)
      end

      it "should have a flash message" do
        post :create, :project => @attr
        flash[:success].should =~ /project created/i
      end
    end
  end

    describe "DELETE 'destroy'" do

    describe "for an unauthorized user" do

      before(:each) do
        @user = Factory(:user)
        wrong_user = Factory(:user, :email => Factory.next(:email))
        test_sign_in(wrong_user)
        @project = Factory(:project, :user => @user)
      end

      it "should deny access" do
        delete :destroy, :id => @project
        response.should_not change(Project, :count)
      end
    end

    describe "for an authorized user" do

      before(:each) do
        @user = test_sign_in(Factory(:user))
        @project = Factory(:project, :user => @user)
      end

      it "should destroy the project" do
        lambda do 
          delete :destroy, :id => @project
        end.should change(Project, :count).by(-1)
      end
    end
  end
end


