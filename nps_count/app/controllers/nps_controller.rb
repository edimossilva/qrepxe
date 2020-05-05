class NpsController < ApplicationController
  def index
    nps_percentage = NpsService.call(params)
    render json: { nps: nps_percentage }, status: :ok
  end
end
