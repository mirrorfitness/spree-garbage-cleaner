namespace :db do
  namespace :garbage do
    desc 'Cleanup garbage by calling .destroy on every model marked as garbage'
    task cleanup: :environment do
      garbage_models = Spree::GarbageCleaner::Config.models_with_garbage.delete(' ').split(',').map(&:constantize)

      garbage_models.each do |model|
        destroyed = model.destroy_garbage

        destroyed.each do |trash|
          puts "Destroyed #{model} id: #{trash.id}"
        end

        puts "Destroyed #{destroyed.length} garbage records from #{model}\n"
      end
    end

    desc 'Gives some info about garbage inside the db'
    task stats: :environment do
      garbage_models = Spree::GarbageCleaner::Config.models_with_garbage.delete(' ').split(',')

      puts 'The following garbage records have been found:'
      garbage_models.each do |model|
        model.constantize.garbage.each do |trash|
          puts "#{model} trash id: #{trash.id}"
        end

        puts "#{model}s ===> #{model.constantize.garbage.count}\n"
      end
    end
  end
end
