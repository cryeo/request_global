require 'spec_helper'

describe RequestGlobal::Middleware do
  let(:app) { FakeApp.new }
  let(:middleware) { RequestGlobal::Middleware.new(app) }
  let(:env) { Hash.new }

  def current_request_id(env)
    middleware.send(:current_request_id, env)
  end

  it "resets all storages after each request" do
    allow(middleware).to receive(:current_request_id).and_return(test_request_id)
    2.times { middleware.call(env) }

    expect(app.last_count).to eq 1
    expect(storages).to eq Hash.new
  end

  it "resets all storages when error raised" do
    allow(middleware).to receive(:current_request_id).and_return(test_request_id)
    error = nil
    begin
      env[:error] = true
      middleware.call(env)
    rescue Exception => e
      error = e
    end

    expect(error.message).to eq "fail"
    expect(storages).to eq Hash.new
  end

  describe "#current_request_id" do
    let!(:action_dispatch_request_id) { "action_dispatch.request_id" }
    let!(:http_x_request_id) { "HTTP_X_REQUEST_ID" }

    context "when env['action_dispatch.request_id'] and env['HTTP_X_REQUEST_ID'] both appear" do
      it "returns env['action_dispatch.request_id']" do
        env["action_dispatch.request_id"] = action_dispatch_request_id
        env["HTTP_X_REQUEST_ID"] = http_x_request_id
        expect(current_request_id(env)).to eq action_dispatch_request_id
      end
    end

    context "when only env['action_dispatch.request_id'] appears" do
      it "returns env['action_dispatch.request_id']" do
        env["action_dispatch.request_id"] = action_dispatch_request_id
        expect(current_request_id(env)).to eq action_dispatch_request_id
      end
    end

    context "when only env['HTTP_X_REQUEST_ID'] appears" do
      it "returns env['HTTP_X_REQUEST_ID']" do
        env["HTTP_X_REQUEST_ID"] = http_x_request_id
        expect(current_request_id(env)).to eq http_x_request_id.gsub(/[^\w\-]/, "")[0, 255]
      end
    end

    context "when env['action_dispatch.request_id'] and env['HTTP_X_REQUEST_ID'] both don't appear" do
      it "returns randomly generated uuid" do
        expect(current_request_id(env)).to match /[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}/
      end
    end
  end
end
