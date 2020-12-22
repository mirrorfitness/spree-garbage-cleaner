module SpreeGarbageCleaner
  module Helpers
    module ActiveRecord
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def destroy_garbage
          destroyed = []

          garbage.find_each(batch_size: Spree::GarbageCleaner::Config.batch_size) do |r|
            begin
              destroyed << r.destroy
            rescue StandardError => e
              puts "Unable to destroy #{r.class} #{r&.id}"
            end
          end

          destroyed
        end
      end
    end
  end
end
