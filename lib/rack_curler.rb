require "rack_curler/version"

module RackCurler
  def self.to_curl(env)

    headers_to_drop = [
      'Version',         # make your life easy and let curl set this
      'Content-Length',  # curl will set this for you
      'Host',            # curl will set this for you
      'Connection',      # curl will set this for you
      'Accept-Encoding', # for debugging, you don't want an encoded-response
      'Date'             # it would be incorrect to repeat
    ]

    header_defaults = {
      'Accept' => '*/*',
      'Content-Type' => 'application/x-www-form-urlencoded'
    }
    
    env['rack.input'].rewind
    body = env['rack.input'].read
    env['rack.input'].rewind

    headerize = lambda { |raw| raw.split(/[ _\-]/).map(&:capitalize).join('-') }

    headers = {}.tap do |h|
      env.select { |k, v| k =~ /^HTTP_/ || k == 'CONTENT_TYPE' }
        .each { |k, v| h[headerize.call(k.sub(/^HTTP_/, ''))] = v}
      h.select! { |k, v| !headers_to_drop.member?(k) }
      h.select! { |k, v| header_defaults[k].nil? || header_defaults[k] != v }
    end
    
    url = Rack::Request.new(env).url
    
    curl_command = "curl '#{url}'"
    curl_command << " \\\n   -X #{env['REQUEST_METHOD']}" unless ['GET', 'POST'].member?(env['REQUEST_METHOD'])
    headers.each_pair do |header, value|
      curl_command << " \\\n   -H '#{header}: #{value}'"
    end
    curl_command << " \\\n   --data '#{body}'" if body && !body.empty?

    curl_command
  end
end
