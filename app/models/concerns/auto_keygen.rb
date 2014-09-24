#
# 在某个模型对象被创建时动态生成Key
#
# @author [molezz]
#
module AutoKeygen
  extend ActiveSupport::Concern

  included do
    before_create :gen_key
  end

  def gen_key
    self.key = Digest::SHA1.hexdigest("#{self.class.name}-#{Time.now}-#{self.object_id}")
  end

  module ClassMethods
  end


end