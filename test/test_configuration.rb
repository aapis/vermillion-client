require "test"
require "client/controllers/status"

class ConfigurationTest < Vermillion::Test::Base
  def test_config_exist
    path = File.expand_path("~/.vermillion.yml")

    assert File.exist? path
  end

  def test_run_default
    req = MockRequest.new(:status, :default)
    cfg = Vermillion::Cfg.new.populate_config

    status = Vermillion::Controller::Status.new(cfg, req)

    assert status.default.zero?
  end
end