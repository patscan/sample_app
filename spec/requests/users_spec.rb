require 'spec_helper'

describe "Users" do

  describe "signup" do
  
    describe "failure" do
      
      it "should not make a new user" do
        lambda do
          visit signup_path
          fill_in "Name",         :with => ""
          fill_in "Email",        :with => ""
          fill_in "Password",     :with => ""
          fill_in "Confirmation", :with => ""
          click_button
          response.should render_template('users/new')
          response.should have_selector("div#error_explanation")
        end.should_not change(User, :count)
      end
    end

    describe "success" do
      
      it "should make a new user" do
        lambda do
          visit signup_path
          fill_in "Name",         :with => "Example User"
          fill_in "Email",        :with => "user@example.com"
          fill_in "Username",     :with => "Username_1"
          fill_in "Password",     :with => "foobar"
          fill_in "Confirmation", :with => "foobar"
          click_button
          response.should have_selector("div.flash.success",
                                        :content => "Welcome")
          response.should render_template('users/show')
        end.should change(User, :count).by(1)
      end
    end      
  end
  
  describe "sign in/out" do
  
    describe "failure" do
      it "should not sign a user in" do
        visit signin_path
        fill_in :email,     :with => ""
        fill_in :password,  :with => ""
        click_button
        response.should have_selector("div.flash.error", :content => "Invalid")
      end
    end  
    
    describe "success" do
      it "should sign a user in and out" do
      user = Factory(:user)
      integration_sign_in(user)
      controller.should be_signed_in
      click_link "Sign out"
      controller.should_not be_signed_in
     end
    end
  end
  
  describe "admin access to delete" do
  
    describe "non admins" do
      it "should not display a delete link" do
      user = Factory(:user)
      integration_sign_in(user)
      click_link "Users"
      response.should_not have_selector("a", :content => "delete")
      end
    end
    
    describe "admins" do
      it "should display a delete link" do
      admin = Factory(:user, :email => "admins@example.com", :admin => true)
      integration_sign_in(admin)
      click_link "Users"
      response.should have_selector("a", :content => "delete")
      end
    end
  end


  
  
end
