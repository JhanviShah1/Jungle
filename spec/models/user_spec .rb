require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Validations' do
    it 'should create a User if all of the validations are true' do
    @user = User.new(name: "Sam", email: "samjones@email.com", password: "ABC", password_confirmation: "ABC")
    @user.valid?
    expect(@user.errors).not_to include("can\'t be blank")
    end

    it 'should not create a User if their name is missing' do
    @user = User.new(email: "samjones@email.com", password: "ABCDEF", password_confirmation: "ABCDEF")
    @user.valid?
    expect(@user.errors[:name]).to include("can\'t be blank")
    end
  
    it 'should not create a User if their email is missing' do
    @user = User.new( password: "ABCDEF", password_confirmation: "ABCDEF")
    @user.valid?
    expect(@user.errors[:email]).to include("can\'t be blank")
    end

    it "is not a Valid user if created with an email which exists(not case sensitive)" do
      newUser1 = User.create(
        name: 'Sarah',
        email: 'test@test.com',
        password:'1234567',
        password_confirmation:'1234567'
        )
       
        newUser2= User.create(
          name: 'Ann',
          email: 'TEST@TEST.COM',
          password:'1234567',
          password_confirmation:'1234567'
          )
    p newUser2
    expect(newUser2).to_not be_valid
    end

    it 'should not create a User if their passwords do not match' do
    @user = User.new( name: 'ABC', email: "sam@gmail.com", password: "ABCDEF", password_confirmation: "ABCDEFG")
    @user.valid?
    expect(@user.errors[:password_confirmation]).to include("doesn\'t match Password")
    end
    it 'should not create a User if there is no password' do
    @user = User.new(name: 'ABC',email: "sam@gmail.com")
    @user.valid?
    expect(@user.errors[:password]).to include("can\'t be blank")
    end
    it 'should not create a User if there the password is too short' do
    @user = User.new( name: 'ABC', email: "sam@gmail.com", password: "ABC", password_confirmation: "ABC")
    @user.valid?
    expect(@user.errors[:password]).to include("is too short (minimum is 6 characters)")
    end
  end

  describe '.authenticate_with_credentials' do
    it 'should log the user in if the credentials are correct' do
      @user = User.new( name: 'ABC',email: "sammy123@gmail.com", password: "ABCDEF", password_confirmation: "ABCDEF")
      @user.save!
      expect(User.authenticate_with_credentials("sammy123@gmail.com", "ABCDEF")).to be_present
    end
    it 'should not log the user in if the email is wrong' do
      @user = User.new(name: 'ABC', email: "abc123@gmail.com", password: "ABCDEF", password_confirmation: "ABCDEF")
      @user.save!
      expect(User.authenticate_with_credentials("sammy123@gmail.com", "ABCDEF")).not_to be_present
    end
    it 'should not log the user in if the password is wrong' do
      @user = User.new(name: 'ABC', email: "sammy123@gmail.com", password: "ABCDEF", password_confirmation: "ABCDEF")
      @user.save!
      expect(User.authenticate_with_credentials("sammy123@gmail.com", "ABCDEFG")).not_to be_present
    end
    it 'should log the user in even if the email contains spaces' do
      @user = User.new( name: 'ABC',email: "sammy123@gmail.com", password: "ABCDEF", password_confirmation: "ABCDEF")
      @user.save!
      expect(User.authenticate_with_credentials("  sammy123@gmail.com   ", "ABCDEF")).to be_present
    end
    it 'should log the user in even if the email is typed with a different case' do
      @user = User.new(name: 'ABC', email: "sammy123@gmail.com", password: "ABCDEF", password_confirmation: "ABCDEF")
      @user.save!
      expect(User.authenticate_with_credentials("  SAMMY123@gmail.com   ", "ABCDEF")).to be_present
    end
    it "authenticate a user with spaces in email" do
      newUser = User.create(
        name: 'Nicole',
        email: 'test@test.com',
        password:'1234567',
        password_confirmation:'1234567'
        )
      user =  User.authenticate_with_credentials('  test@test.com  ','1234567')
      expect(user).to_not be_nil
    end   
    it "authenticate a user with diffrerent case in email" do
      newUser = User.create(
        name: 'Nicole',
        email: 'test@test.com',
        password:'1234567',
        password_confirmation:'1234567'
        )
      user =  User.authenticate_with_credentials('Test@tEst.com','1234567')
      expect(user).to_not be_nil
    end   
  end
end








