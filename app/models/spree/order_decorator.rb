module Spree::OrderDecorator
  def self.prepended(base)
    base.include SpreeGarbageCleaner::Helpers::ActiveRecord
    base.extend ClassMethods
  end

  module ClassMethods
    def garbage
      garbage_after = Spree::GarbageCleaner::Config.cleanup_days_interval
      incomplete.where("created_at <= ?", garbage_after.days.ago)
    end
  end

  def garbage?
    garbage_after = Spree::GarbageCleaner::Config.cleanup_days_interval
    completed_at.nil? && created_at <= garbage_after.days.ago
  end
end

::Spree::Order.prepend(Spree::OrderDecorator)
