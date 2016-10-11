require "test"
require "client/controllers/change"

class ChangeBranchTest < Vermillion::Test::Base
  MockRequest = Struct.new(:controller, :command)

  def test_change_branch_one
    req = MockRequest.new(:change, :branch)

    cfg = Vermillion::Cfg.new
    cfg.bootstrap!

    change = Vermillion::Controller::Change.new(cfg, req)

    assert change.branch(:local, :master)
  end
end