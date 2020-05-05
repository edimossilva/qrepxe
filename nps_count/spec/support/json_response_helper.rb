module JsonResponseHelper
  def response_body
    JSON.parse(response.body)
  end
end
