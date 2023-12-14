require "test_helper"

class UserTest < ActiveSupport::TestCase
  setup do
    @user = users(:user)
  end

  test "accepts viewer, tagger as role" do
    %i[viewer tagger].each do |_role|
      @user.role = :viewer
      assert @user.valid?
    end
  end

  test "doesn't accept other roles" do
    assert_raises(ArgumentError) { @user.role = :wrong }
  end
end
