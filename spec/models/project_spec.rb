require 'spec_helper'

describe Project do

  before(:each) do
    @user = Factory(:user) 
    @attr = {
      :title => "value for title",
      :description => "value for description",
      :user_id => 1
    }
  end

  describe "user associations" do

    before(:each) do
      @project = @user.projects.create(@attr)
    end

    it "should have a user attribute" do
      @project.should respond_to(:user)
    end

    it "should have the right associated user" do
      @project.user_id.should == @user.id
      @project.user.should == @user
    end
  end
  
    describe "validations" do

    it "should require a user id" do
      Project.new(@attr).should_not be_valid
    end

    it "should require nonblank content" do
      @user.projects.build(:title => "  ").should_not be_valid
    end

    it "should reject long content" do
      @user.projects.build(:title => "a" * 211).should_not be_valid
    end
  end
end
