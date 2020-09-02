class Api::V1::MainController < Api::BaseController
  before_action :authenticate_user!
end
