require 'pg_dumper'
require 'rails'

class PgDumper
  class Railtie < Rails::Railtie
    #railtie_name :pg_dumper # Deprecated

    rake_tasks do
      load "tasks/db_dump.rake"
    end
  end
end