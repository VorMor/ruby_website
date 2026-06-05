module Account
  class BaseController < ApplicationController
    before_action :require_user
  end
end
