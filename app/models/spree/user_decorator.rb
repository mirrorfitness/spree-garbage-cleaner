module Spree::UserDecorator
  def self.prepended(base)
    base.include SpreeGarbageCleaner::Helpers::ActiveRecord
    base.extend ClassMethods
  end

  module ClassMethods
    def garbage
      garbage_after = Spree::GarbageCleaner::Config.cleanup_days_interval
      garbage = joins("LEFT JOIN spree_orders ON spree_orders.user_id = #{Spree.user_class.table_name}.id")
      garbage = garbage.where(
        "#{Spree.user_class.table_name}.email IS NULL OR #{Spree.user_class.table_name}.email LIKE ?", '%@example.com'
      )
      garbage = garbage.where("#{Spree.user_class.table_name}.created_at <= ?", garbage_after.days.ago)
      garbage.where('spree_orders.completed_at IS NULL').readonly(false)
    end
  end

  def garbage?
    garbage_after = Spree::GarbageCleaner::Config.cleanup_days_interval
    anonymous? && created_at <= garbage_after.days.ago && orders.count == orders.incomplete.count
  end
end

Spree.user_class.prepend(Spree::UserDecorator)
