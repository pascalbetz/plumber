require 'test_helper'

class Plumber::Blocks::PlugTest < Minitest::Test
  def test_does_not_have_exit_pipes
    assert_raises NameError do
      Plumber::Blocks::Plug.new.connect(nil)
    end
  end

  def test_it_accepts_values
    Plumber::Blocks::Plug.new.call(nil)
  end

end
