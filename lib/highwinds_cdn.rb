require 'highwinds_cdn/version'
require 'curb'
require 'json'

module HighwindsCDN

  class API
    BASE_URL = 'https://striketracker.highwinds.com/api/v1'

    def initialize(token: nil)
      token or raise ArgumentError

      @auth_token = token
    end

    def purge_url(url, recursive: false)
      data = { list: Array(url).map { |u| { url: u, recursive: recursive } } }.to_json
      resp = Curl.post(BASE_URL + "/accounts/#{account_hash}/purge", data) do |h|
        h.headers['Content-Type']  = 'application/json'
        h.headers['Accept']        = 'application/json'
        h.headers['Authorization'] = authorization_header
      end

      data = JSON.parse(resp.body)

      check_error(data)

      data['id']
    end

    def get_purge_progress(id)
      resp = Curl.get(BASE_URL + "/accounts/#{account_hash}/purge/#{id}") do |h|
        h.headers['Authorization'] = authorization_header
      end
      data = JSON.parse(resp.body)

      check_error(data)

      data['progress']
    end

    def account_hash
      @account_hash ||= get_account_hash()
    end

    private

    def authorization_header
      "Bearer #{@auth_token}"
    end

    def get_account_hash
      resp = Curl.get(BASE_URL + '/users/me') do |h|
        h.headers['Authorization'] = authorization_header
      end
      data = JSON.parse(resp.body)

      check_error(data)

      data['accountHash']
    end

    def check_error(data)
      raise data['error'] if data['error']
    end
  end
end
