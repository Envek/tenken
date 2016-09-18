require 'test_helper'

class Site::CheckTest < MiniTest::Spec

  before do
    @site = Site.find_or_create_by!(uri: 'https://example.com')
    HTTPI.log = false
  end

  it 'must treat response 200 as successful' do
    stub_request(:head, /example.com/).to_return(status: 200)
    operation = Site::Check.(id: @site.id)
    assert operation.check.success
    operation.check.response_code.must_equal 200
  end

  it 'must treat all other statuses as faulty' do
    Rack::Utils::HTTP_STATUS_CODES.except(200).each do |code, _message|
      stub_request(:head, /example.com/).to_return(status: code)
      operation = Site::Check.(id: @site.id)
      refute operation.check.success
      operation.check.response_code.must_equal code
    end
  end

  it 'must treat timeouts as failures' do
    stub_request(:head, /example.com/).to_timeout
    operation = Site::Check.(id: @site.id)
    refute operation.check.success
    operation.check.response_code.must_be_nil
  end

  it 'must treat network errors as failures' do
    [Errno::ECONNREFUSED, Errno::EHOSTUNREACH, Errno::ENETUNREACH, SocketError, HTTPI::SSLError].each do |exception|
      stub_request(:head, /example.com/).to_raise(exception)
      operation = Site::Check.(id: @site.id)
      refute operation.check.success
      operation.check.response_code.must_be_nil
      operation.check.details.wont_be_empty
    end
  end
end
