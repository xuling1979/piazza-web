require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'requires a name' do
    @user = User.new(name: '', email: 'xuling@example.com', password: '12345678')
    assert_not @user.valid?
    @user.name = 'Ling'
    assert @user.valid?
  end

  test 'requires a valid email' do
    @user = User.new(name: 'Ling', email: '', password: '12345678')
    assert_not @user.valid?

    @user.email = 'xuling@example.com'
    assert @user.valid?
  end

  test 'requires a unique email' do
    @existing_user = User.create(
      name: 'Ling', email: 'Ling@example.com',
      password: '12345678'
    )
    assert @existing_user.persisted?

    @user = User.new(name: 'Lin', email: 'Ling@example.com')
    assert_not @user.valid?
  end

  test 'name and email is stripped of spaces before saving' do
    @user = User.create(
      name: '  Ling',
      email: '  ling@example.com ',
      password: '12345678'
    )

    assert_equal 'Ling', @user.name
    assert_equal 'ling@example.com', @user.email
  end

  test "password length must be between 8 and ActiveModel's maximum" do
    @user = User.new(
      name: 'Ling',
      email: 'ling@example.com',
      password: ''
    )
    assert_not @user.valid?

    @user.password = '12345678'
    assert @user.valid?

    max_length = ActiveModel::SecurePassword::MAX_PASSWORD_LENGTH_ALLOWED
    @user.password = '1' * (max_length + 1)
    assert_not @user.valid?
  end
end
