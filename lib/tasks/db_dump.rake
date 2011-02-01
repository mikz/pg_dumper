namespace :db do
  desc 'Dumps database (both data and schema) to FILE or asks for output'
  task :dump => ["#{Rails.root}/config/database.yml", :environment] do
    gzip = ENV['GZIP'].present?
    db = ActiveRecord::Base.configurations[Rails.env]
    backup_file = Time.now.strftime("backup_%Y%m%d%H%M%S.sql")
    unless file = ENV['FILE']
      print "Enter filename of dump [#{backup_file}#{'.gz' if gzip}]: "
      input = STDIN.gets.chop
      file  = (input.blank?)? backup_file : input
    end
    
    dump = PgDump.new db["database"]
    dump.recreate!
    dump.connection = db
    dump.output = backup_file
    dump.verbose! if ENV['VERBOSE'].present?
    dump.compress! ENV['Z']
    
    print "Creating backup to '#{file}'\n"
    
    if dump.run
      system 'gzip', '-v', file if gzip
      print "Backup saved to #{file.inspect}\n"
    else
      print "Backup failed! Error status: #{$?}."
    end
    
    @backup_file = file
  end
  
  desc 'Dumps database (only data) to FILE or asks for output'
  namespace :dump do
    task :data =>  ["#{Rails.root}/config/database.yml", :environment] do
      gzip = ENV['GZIP'].present?
      db = ActiveRecord::Base.configurations[Rails.env]
      backup_file = Time.now.strftime("backup_%Y%m%d%H%M%S.sql")
      unless file = ENV['FILE']
        print "Enter filename of dump [#{backup_file}#{'.gz' if gzip}]: "
        input = STDIN.gets.chop
        file  = (input.blank?)? backup_file : input
      end

      dump = PgDump.new db["database"]
      dump.data_only!
      dump.connection = db
      dump.output = backup_file
      dump.verbose! if ENV['VERBOSE'].present?
      dump.compress! ENV['Z']

      print "Creating backup to '#{file}'\n"

      if dump.run
        system 'gzip', '-v', file if gzip
        print "Backup saved to #{file.inspect}\n"
      else
        print "Backup failed! Error status: #{$?}."
      end

      @backup_file = file
    end
  end
end