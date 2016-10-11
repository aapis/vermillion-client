require "test"
require "client/controllers/create"

class CreateTest < Vermillion::Test::Base
  def test_default
    req = MockRequest.new(:create, :default, "test-sample-#{Time.now.to_i}")
    cfg = Vermillion::Cfg.new.populate_config

    create = Create.new(cfg, req)

    assert create.default(:local, req.param).zero?
  end
end