module SpreeGarbageCleaner
  module Helpers
    module ActiveRecord
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def destroy_garbage(debug: false)
          destroyed = []

          garbage.find_each(batch_size: Spree::GarbageCleaner::Config.batch_size) do |r|
            begin
              puts "Destroying #{r.class} #{r&.id}" if debug
              destroyed << r.destroy
            rescue StandardError => e
              puts "Unable to destroy #{r.class} #{r&.id}: #{e.message}"
            end
          end

          destroyed
        end
      end
    end
  end
end
