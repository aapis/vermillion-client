require "test"
require "client/controller/update"

class UpdateTest < Vermillion::Test::Base
  # Test updating one server
  def test_update_one
    req = MockRequest.new(:update, :one, "local/vermillion-server")
    cfg = Vermillion::Cfg.new.populate_config

    status = Update.new(cfg, req)

    assert status.one(req.param).zero?
  end

  # Test updating the config manifest on one server
  def test_update_config
    req = MockRequest.new(:update, :one, :local)
    cfg = Vermillion::Cfg.new.populate_config

    status = Update.new(cfg, req)

    assert status.one(req.param).zero?
  end
end