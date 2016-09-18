# Performs availability check of site by issuing HTTP HEAD request

class Site::Check < Trailblazer::Operation
  include Model
  model Site

  attr_reader :check

  NETWORK_ERRORS = [
    Net::OpenTimeout, Net::ReadTimeout, Timeout::Error,           # Timeouts
    Errno::ECONNREFUSED, Errno::EHOSTUNREACH, Errno::ENETUNREACH, # Network issues
    SocketError,                                                  # DNS resolution issues
    HTTPI::SSLError,                                              # SSL is bad
  ].freeze

  def model!(params)
    params[:model] || Site.find(params[:id])
  end

  def process(_params)
    started_at = Time.current
    result = perform_request!
    @check = @model.checks.create!(result.merge(started_at: started_at, finished_at: Time.current))
  end

  def perform_request!
    uri = Addressable::URI.parse(@model.uri).normalize
    request = HTTPI::Request.new(url: uri, open_timeout: 15, read_timeout: 45)
    request.headers['User-Agent'] = 'Tenken site checker <https://github.com/Envek/tenken>'
    response = HTTPI.head(request, :net_http)
    { success: response.code == 200, response_code: response.code, response_headers: response.headers }
  rescue *NETWORK_ERRORS => e
    { success: false, details: "#{e.class}: #{e.message}" }
  end
end
