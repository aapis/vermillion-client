require "test"
require "client/controller/create"

class CreateTest < Vermillion::Test::Base
  # Test the default method
  def test_default
    req = MockRequest.new(:create, :default, "test-sample-#{Time.now.to_i}")
    cfg = Vermillion::Cfg.new.populate_config

    create = Create.new(cfg, req)

    assert create.one(:local, req.param).zero?
  end
end