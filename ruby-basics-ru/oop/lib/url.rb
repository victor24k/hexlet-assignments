# frozen_string_literal: true

# BEGIN
require 'uri'
require 'forwardable'

# Simple implementation of Url class. Urls comparsion is not complete.
class Url
  attr_reader :query_params

  extend Forwardable
  include Comparable

  def initialize(address)
    @uri = URI(address)
    @query_params = @uri.query.nil? ? {} : parse_query_params
  end

  def_delegators :@uri, :scheme, :host, :port

  def query_param(key, default_value = nil)
    query_params[key] || default_value
  end

  def <=>(other)
    [@uri.scheme, @uri.host, @uri.port, @query_params] <=> [other.scheme, other.host, other.port, other.query_params]
  end

  private

  def parse_query_params
    @uri.query.split('&').each_with_object({}) do |kv_pair, acc|
      key, value = kv_pair.split('=')
      acc[key.to_sym] = value
    end
  end
end
# END