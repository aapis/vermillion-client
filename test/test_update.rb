require "test"
require "client/controllers/update"

class UpdateTest < Vermillion::Test::Base
  def test_update_one
    req = MockRequest.new(:update, :one, "local/vermillion-server")
    cfg = Vermillion::Cfg.new.populate_config

    status = Update.new(cfg, req)

    assert status.one(req.param).zero?
  end

  def test_update_config
    req = MockRequest.new(:update, :one, :local)
    cfg = Vermillion::Cfg.new.populate_config

    status = Update.new(cfg, req)

    assert status.one(req.param).zero?
  end
end