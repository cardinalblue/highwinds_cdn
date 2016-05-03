require 'spec_helper'
require 'yaml'

describe HighwindsCDN do
  let(:config) { YAML.load_file('spec/config.yml') }
  subject { HighwindsCDN::API.new(token: config['token']) }

  it 'has a version number' do
    expect(HighwindsCDN::VERSION).not_to be nil
  end

  it '.account_hash' do
    account_hash = subject.account_hash
    expect(account_hash).not_to be_empty
    expect(account_hash.length).to eq 8
  end

  it '.purge_url' do
    url = 'http://image-cdn.pic-collage.com/768x1024.jpg'
    purge_id = subject.purge_url(url)
    expect(purge_id).not_to be_empty
    expect(purge_id.length).to be > 10
  end

  it '.get_purge_progress' do
    url = 'http://image-cdn.pic-collage.com/768x1024.jpg'
    purge_id = subject.purge_url(url)
    progress = subject.get_purge_progress(purge_id)

    expect(progress).to be > 0
  end
end
