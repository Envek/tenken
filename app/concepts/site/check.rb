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
    enqueue_notifications!
  end

  protected

  def perform_request!
    uri = Addressable::URI.parse(@model.uri).normalize
    request = HTTPI::Request.new(url: uri, open_timeout: 15, read_timeout: 45)
    request.headers['User-Agent'] = 'Tenken site checker <https://github.com/Envek/tenken>'
    response = HTTPI.head(request, :net_http)
    { success: response.code == 200, response_code: response.code, response_headers: response.headers }
  rescue *NETWORK_ERRORS => e
    { success: false, details: "#{e.class}: #{e.message}" }
  end

  def enqueue_notifications!
    if !@check.success
      if @model.failing_since.present?
        failing_duration = @check.finished_at - @model.failing_since
        return unless Settings.notification_times_in_minutes.any? do |n|
          time_passed  = failing_duration > n.minutes
          was_notified = (@model.last_notification_at || @model.failing_since) >= @model.failing_since + n.minutes
          time_passed && !was_notified
        end
        @model.update(last_notification_at: @check.finished_at)
        NotificationMailer.failed_email(@model, @check).deliver_later
      else
        @model.update(failing_since: @check.finished_at)
      end
    elsif @check.success && @model.failing_since.present?
      @model.update(failing_since: nil, last_notification_at: @check.finished_at)
      NotificationMailer.restored_email(@model, @check).deliver_later
    end
  end
end
