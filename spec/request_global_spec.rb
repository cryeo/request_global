require 'spec_helper'

describe RequestGlobal do
  before do
    RequestGlobal.clear_all!
  end

  it 'has a version number' do
    expect(RequestGlobal::VERSION).not_to be_nil
  end

  describe ".set_current_request" do
    it "set request id to class variable" do
      RequestGlobal.set_current_request test_request_id
      expect(current_request).to eq test_request_id
    end
  end

  describe ".get_current_request" do
    it "returns request id from class variable" do
      RequestGlobal.set_current_request test_request_id
      expect(RequestGlobal.get_current_request).to eq current_request
    end
  end

  describe ".begin!" do
    it "creates storage for current request" do
      RequestGlobal.set_current_request test_request_id
      RequestGlobal.begin!
      expect(storages).to include test_request_id
      RequestGlobal.end!
    end
  end

  describe ".end!" do
    it "destroy storage for current request" do
      RequestGlobal.set_current_request test_request_id
      RequestGlobal.begin!
      RequestGlobal.end!
      expect(storages).not_to include test_request_id
      expect(current_request).to be_nil
    end
  end

  describe ".clear!" do
    it "clears only storage for current request" do
      RequestGlobal.set_current_request test_request_id
      RequestGlobal.begin!
      RequestGlobal.storage[:foo] = 1
      RequestGlobal.storage[:bar] = 2
      expect(RequestGlobal.storage).to include foo: 1, bar: 2
      RequestGlobal.clear!
      expect(RequestGlobal.storage).not_to include test_request_id
      RequestGlobal.end!
    end
  end

  describe ".clear_all!" do
    it "clears all storages and current request" do
      RequestGlobal.set_current_request test_request_id
      RequestGlobal.begin!
      RequestGlobal.storage[:foo] = 1
      RequestGlobal.storage[:bar] = 2
      expect(RequestGlobal.storage).to include foo: 1, bar: 2
      RequestGlobal.clear_all!
      expect(storages).not_to include test_request_id
      expect(current_request).to be_nil
    end
  end

  describe ".delete" do
    it "remove given key-value pairs from current storage" do
      RequestGlobal.set_current_request test_request_id
      RequestGlobal.begin!
      RequestGlobal.storage[:foo] = 1
      RequestGlobal.storage[:bar] = 2
      RequestGlobal.delete(:foo)
      expect(RequestGlobal.storage).not_to include foo: 1
      RequestGlobal.end!
    end
  end

  describe ".fetch" do
    it "returns value for given key from current storage" do
      RequestGlobal.set_current_request test_request_id
      RequestGlobal.begin!
      RequestGlobal.storage[:foo] = 1
      RequestGlobal.storage[:bar] = 2
      expect(RequestGlobal.fetch(:foo)).to eq 1
      expect(RequestGlobal[:bar]).to eq 2
      expect(RequestGlobal[:hoge]).to be_nil
      RequestGlobal.end!
    end
  end

  describe ".storage" do
    it "stores key-value pairs" do
      RequestGlobal.set_current_request test_request_id
      RequestGlobal.begin!
      RequestGlobal.storage[:foo] = 1
      RequestGlobal[:bar] = 2
      expect(RequestGlobal.fetch(:foo)).to eq 1
      expect(RequestGlobal[:bar]).to eq 2
      RequestGlobal.end!
    end
  end
end
