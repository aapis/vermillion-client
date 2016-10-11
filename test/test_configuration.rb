require "test"
require "client/controller/status"

class ConfigurationTest < Vermillion::Test::Base
  def test_config_exist
    path = File.expand_path("~/.vermillion.yml")

    assert File.exist? path
  end

  def test_default
    req = MockRequest.new(:status, :default)
    cfg = Vermillion::Cfg.new.populate_config

    status = Status.new(cfg, req)

    assert status.default.zero?
  end
end