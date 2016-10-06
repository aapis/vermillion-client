require "test"
require "client/controllers/change"

class ChangeBranchTest < Vermillion::Test::Base
  def test_change_branch_one
    change = Vermillion::Controller::Change.new

    assert change.branch(:local, :change_branch, to: :master)
  end
end