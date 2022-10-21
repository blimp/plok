namespace 'plok:search' do
  desc 'Rebuild all search indices'
  # TODO: pass module(s) as parameter.
  # TODO: Rework to be less "intrusive" (remove SearchIndex#destroy_all, for starters).
  task rebuild_indices: :environment do
    SearchIndex.destroy_all
    SearchModule.where(searchable: true).each do |m|
      puts "Rebuilding #{m.name} indices..."
      m.name.constantize.all.each(&:trigger_indices_save!)
    end
    puts "Done."
  end
end
