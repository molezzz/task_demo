#
# 用于控制器中对用户权限验证
#
# @author [molezz]
#
module UserAuth
  extend ActiveSupport::Concern

  included do

  end



  #
  # 返回当前登录的user
  # @noto 由于没做登录逻辑，所以这里只是个演示
  #
  # @return [User]
  def current_user
    @_user ||= User.first
  end

  module ClassMethods
  end


end