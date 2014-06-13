1) Add module to gemfile
  gem 'omniauth-github'

2) Add initializer to config/initializers
  Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET'],
    scope: 'user:email'
  end

  3) Create .env

    SESSION_SECRET='super secret'

  GITHUB_KEY=662bbcb6beed2a20e796
  GITHUB_SECRET=44dc12142ddd78f598ec63af436096a951d5d355

4) add .env to gitignore

5) add to routes file

      get '/auth/github/callback', to: 'sessions#create'

      resources :sessions, only: [:destroy]

6) create user controllers 
        class User < ActiveRecord::Base
      has_many :questions
      has_many :answers

    def self.find_or_create_from_omniauth(auth)
      provider = auth.provider
      uid = auth.uid

      find_by(provider: provider, uid: uid) || create_from_omniauth(auth)
    end

    def self.create_from_omniauth(auth)
      
      create(
        provider: auth.provider,
        uid: auth.uid,
        email: auth.info.email,
        username: auth.info.nickname,
        avatar_url: auth.info.image
      )
    end
  end

7 ) add user sessions to the application controller

protect_from_forgery with: :exception

  helper_method :signed_in?, :current_user

  def current_user
    user_id = session[:user_id]
    @current_user ||= User.find(user_id) if user_id.present?
  end

  def signed_in?
    current_user.present?
  end

  def set_current_user(user)
    session[:user_id] = user.id
  end
  protect_from_forgery with: :exception

8)create a sessions controller

    class SessionsController < ApplicationController
  def create
    auth = env['omniauth.auth']

    user = User.find_or_create_from_omniauth(auth)
    set_current_user(user)
    flash[:notice] = "You're now signed in as #{user.username}!"

    redirect_to '/'
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "You have been signed out."

    redirect_to '/'
  end
end

9) migration for users

class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |table|
      table.string :provider, null: false
      table.string :uid, null: false
      table.string :username, null: false
      table.string :email, null: false
      table.string :avatar_url, null: false

      table.timestamps
    end

    add_index :users, [:uid, :provider], unique: true
  end
end







































