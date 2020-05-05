class NpsController < ApplicationController
  def index
    nps_percentage = NpsService.call(nps_params)
    render json: { nps: nps_percentage }, status: :ok
  end

  def nps_params
    result = params.permit(:company)
    result[:date] = params[:date].permit(:month, :year).to_hash if params[:date]
    result.to_hash.transform_keys(&:to_sym)
  end
end
