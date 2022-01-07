require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  
   def setup
    @user = users(:michael)
  end
  
  test "login with invalid information" do
    get login_path # ログイン用のパスを開く
    assert_template 'sessions/new' # 新しいセッションのフォームが正しく表示されたことを確認する
    post login_path, params: { session: { email: "", password: "" } } # わざと無効なparamsハッシュを使ってセッション用パスにPOSTする
    assert_template 'sessions/new' # 新しいセッションのフォームが再度表示され、
    assert_not flash.empty? # フラッシュメッセージが追加されることを確認する
    get root_path # 別のページ (Homeページなど) にいったん移動する
    assert flash.empty? # 移動先のページでフラッシュメッセージが表示されていないことを確認する
  end
  
  test "login with valid information" do
    get login_path
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
  end
end
