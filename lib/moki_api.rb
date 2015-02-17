require 'faraday'
require 'faraday_middleware'
require 'celluloid/io'
require 'future_wrapper'
require 'hashie'
require 'moki_ruby/device_identifier'

class MokiAPI
  include Celluloid::IO
  BASE_URL = '/rest/v1/api/tenants/'

  def self.ios_profiles
    issue_request(:get, full_url('/iosprofiles'), {})
  end

  def self.device_profile_list(device_id)
    if DeviceIdentifier.is_udid?(device_id)
      issue_request(:get, full_url("/devices/#{ device_id }/profiles"), {})
    elsif DeviceIdentifier.is_serial?(device_id)
      issue_request(:get, full_url("/devices/sn-!-#{ device_id }/profiles"), {})
    else
      raise "Must pass a serial number or UDID to get device profile list"
    end
  end

  def self.full_url(path)
    ENV['MOKI_API_URL'] + BASE_URL + ENV['MOKI_TENANT_ID'] + path
  end

  def self.issue_request(method, url, options)
    raise "No Moki URL Provided. Set ENV['MOKI_API_URL']."    if ENV['MOKI_API_URL'].nil? || ENV['MOKI_API_URL'].empty?
    raise "No Tenant ID Provided. Set ENV['MOKI_TENANT_ID']." if ENV['MOKI_TENANT_ID'].nil? || ENV['MOKI_TENANT_ID'].empty?
    raise "No API Key Provided. Set ENV['MOKI_API_KEY']."     if ENV['MOKI_API_KEY'].nil? || ENV['MOKI_API_KEY'].empty?

    future = Celluloid::Future.new do
      begin
        log_request(method, url)
        response = conn.send(method, url, options) do |request|
          request.headers = request.headers.merge(headers)
        end
        to_return_type response
      rescue => e
        Honeybadger.notify(e, context: { method: method,
                                         url: url,
                                         options: options,
                                         response_status: response.try(:status),
                                         response_body: response.try(:body) }) if defined?(Honeybadger)
        raise e
      end
    end
    future.extend(FutureWrapper)
  end

  def issue_request(method, url, options)
    self.class.issue_request(method, url, options)
  end

private
  def self.to_return_type response
    begin
      Hashie::Mash.new({
        body: JSON.parse(response.body),
        status: response.status,
        headers: response.headers
      })
    rescue => e
      response
    end
  end

  def self.conn
    connection = Faraday.new do |conn|
      conn.request :json
      conn.adapter Faraday.default_adapter
    end
    connection
  end

  def self.headers
    {
      "X-Moki-TenantAPIToken" => ENV['MOKI_API_KEY']
    }
  end

  def self.log_request(method, url)
    logger = if defined?(Rails)
               Rails.logger
             elsif defined?(Napa::Logger)
               Napa::Logger.logger
             else
               nil
             end

    return unless logger

    data = { moki_api_request:
      {
        message: "Calling Moki API URL #{ url }",
        request_method: method,
        request_url: url,
      }
    }

    logger.info(data.as_json)
  end
end
