# frozen_string_literal: true

class PagesController < ApplicationController
  def home
    redirect_to groups_path if logged_in?
  end

  def about; end
end
