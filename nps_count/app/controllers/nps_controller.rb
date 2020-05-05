class NpsController < ApplicationController
  def index
    nps_percentage = NpsService.call(nps_params.to_hash)
    render json: { nps: nps_percentage }, status: :ok
  end

  def nps_params
    params.permit(:company, :year, :month)
  end
end
