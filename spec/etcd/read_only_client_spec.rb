# Encoding: utf-8

require 'spec_helper'

describe 'Etcd read only client' do

  before(:all) do
    start_daemon(3)
  end
  after(:all) do
    stop_daemon
  end

  let(:client) do
    etcd_client
  end

  it 'should not allow write' do
    key = random_key
    expect do
      read_only_client.set(key, :value => uuid.generate)
    end.to raise_error(Net::HTTPRetriableError)
  end

  it 'should allow reads' do
    key = random_key
    value = uuid.generate
    client.set(key, :value => value)
    sleep 1
    expect(read_only_client.get(key).value).to eq(value)
  end

  it 'should allow watch' do
    key = random_key
    value = uuid.generate
    index = client.set(key, :value => value).node.modified_index
    expect(read_only_client.watch(key, :index => index).value).to eq(value)
  end
end
