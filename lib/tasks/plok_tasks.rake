namespace 'plok:search' do
  # The official Rails way to pass arguments to Rake tasks is this:
  #
  #   task :rebuild_indices, [:modules] => :environment do |_t, args|
  #     args.with_defaults(modules: SearchModule.searchable.pluck(:klass))
  #   end
  #
  # The problem with that is that you can't comma-separate multiple modules
  # unless you escape them. This is because commas denote multiple arguments.
  #
  # In short, this wouldn't work:
  #
  #   bin/rails plok:search:rebuild_indices[EmailTemplate,Article]
  #
  # And you'd need to do this:
  #
  #   bin/rails plok:search:rebuild_indices["EmailTemplate\,Article"]
  #
  # I don't agree with that notation, so instead I opted for ENV vars instead:
  #
  #   bin/rails plok:search:rebuild_indices modules=EmailTemplate,Article
  #
  desc 'Rebuild select search indices (or all of them without additional arguments).'
  task rebuild_indices: :environment do
    # Default to all searchable modules
    modules = ENV['modules']&.split(',') || SearchModule.searchable.pluck(:klass)

    # A safeguard to prevent mishaps
    modules.select! do |m|
      SearchModule.exists?(klass: m) && # Only known modules
        Plok::Engine.class_exists?(m.constantize) # Only existing classes
    end

    # Faster than SearchIndex.where(searchable_type: modules).destroy_all
    ActiveRecord::Base
      .connection
      .execute("DELETE FROM search_indices WHERE searchable_type in ('#{modules.join("','")}')")

    SearchModule.where(klass: modules).each do |m|
      puts "Rebuilding #{m.klass} indices..."
      m.klass.constantize.all.each(&:trigger_indices_save!)
    end

    puts "Done."
  end
end
