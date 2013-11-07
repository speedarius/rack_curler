require 'rack_curler'
require 'rack/mock'

describe RackCurler do
  it "has a version" do
    RackCurler::VERSION.should_not be_nil
  end

  describe "to_curl" do
    describe 'for a GET to http://foo.example.com' do
      before(:each) do
        @env = Rack::MockRequest.env_for 'http://foo.example.com'
        @env['HTTP_VERSION'] = '1.2.3.4'
        @env['HTTP_HOST'] = 'foo.example.com'
        @env['HTTP_CONNECTION'] = 'close'
        @env['HTTP_ACCEPT_ENCODING'] = 'deflate, gzip'
        @env['HTTP_DATE'] = '2013-11-06 16:52:05 -0800'
        @env['HTTP_ACCEPT'] = '*/*'
        @env['HTTP_SOME_OTHER_HEADER'] = 'header value 123'
        @output = RackCurler.to_curl(@env)
      end

      it "is a curl command" do
        @output.should match /^curl /
      end

      it "has a url argument of http://foo.example.com" do
        @output.should match /^curl 'http:\/\/foo\.example\.com\/?'/
      end

      it "does not specify a Version header (curl should choose this)" do
        @output.should_not match /-H 'Version:/
      end

      it "does not specify a Host header (curl does this for you)" do
        @output.should_not match /-H 'Host:/
      end

      it "does not specify a Connection header (curl does this for you)" do
        @output.should_not match /-H 'Connection:/
      end

      it "does not specify an Accept-Encoding header (for debugging, you don't want an encoded response)" do
        @output.should_not match /-H 'Accept-Encoding:/
      end

      it "does not specify a Date header (curl will do this for you)" do
        @output.should_not match /-H 'Date:/
      end

      it "does not have a redundant Accept header (curl will use */* by default)" do
        @output.should_not match /-H 'Accept:/
      end

      it "does include any other header" do
        @output.should match /-H 'Some-Other-Header: header value 123'/
      end

      it "does not have a -X argument (curl will assume it is a GET)" do
        @output.should_not match /-X GET/
      end

      it "does not have a --data argument" do
        @output.should_not match /--data/
      end

      describe 'with non-default Accept' do
        before(:each) do
          @env['HTTP_ACCEPT'] = 'something specific'
          @output = RackCurler.to_curl(@env)
        end

        it "does include the Accept header" do
          @output.should match /-H 'Accept: something specific'/
        end
      end
    end

    describe 'for a PUT to http://foo.example.com' do
      before(:each) do
        @env = Rack::MockRequest.env_for 'http://foo.example.com', :input => 'some body'
        @env['CONTENT_LENGTH'] = '9'
        @env['CONTENT_TYPE'] = 'application/x-www-form-urlencoded'
        @output = RackCurler.to_curl(@env)
      end

      it "does not specify a Content-Length header (curl will set this for you)" do
        @output.should_not match /-H 'Content-Length:/
      end

      it "does not specify a redundant Content-Type header (curl will assume application/x-www-form-urlencoded)" do
        @output.should_not match /-H 'Content-Type:/
      end

      it "includes the body in a --data argument" do
        @output.should match /--data 'some body'/
      end

      describe 'with non-default Content-Type' do
        before(:each) do
          @env['CONTENT_TYPE'] = 'hello'
          @output = RackCurler.to_curl(@env)
        end

        it "does specify a Content-Type header" do
          @output.should match /-H 'Content-Type: hello'/
        end
      end
    end

    describe 'for a POST to http://foo.example.com' do
    end

    describe 'for a DELETE to http://foo.example.com' do
    end
  end
end

