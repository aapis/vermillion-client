require "test"
require "client/controller/change"

class ChangeBranchTest < Vermillion::Test::Base
  def test_change_branch_one
    req = MockRequest.new(:change, :branch)
    cfg = Vermillion::Cfg.new.populate_config

    change = Change.new(cfg, req)

    assert change.branch(:local, :master).zero?
  end
end