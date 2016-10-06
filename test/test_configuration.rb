require "test"

class ConfigurationTest < Vermillion::Test::Base
  def test_config_exist
    path = File.expand_path("~/.vermillion.yml")

    assert File.exist? path
  end
end