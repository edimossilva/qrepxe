class NpsReportController < ApplicationController
  def index
    highest_nps = HighestNpsService.call
    render json: { highest: highest_nps }, status: :ok
  end
end
