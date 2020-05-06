class NpsReportController < ApplicationController
  def index
    case report_type[:type]
    when 'highest'
      highest_nps = HighestNpsService.call
      render json: { highest: highest_nps }, status: :ok
    else
      render json: { error_message: 'invalid report type' }, status: :bad_request
    end
  end

  def report_type
    params.require(:type)
    params.permit(:type)
  end
end
