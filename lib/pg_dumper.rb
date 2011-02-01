class PgDumper
  attr_reader :database
  attr_reader :args
  
  def initialize database
    @database = database
    @args = []
    @options = {}
  end
  
  def run(mode = :silent)
    @binary ||= find_executable
    
    raise "ERROR: pg_dump binary not found" unless @binary.present?

    options = {}
    
    case mode
    when :silent
      options[:out] = "/dev/null" 
    end
    DEBUG {%w{@binary args database options}}
    system @binary, *args, database, options
  end
  
  def schema_only!
    add_args "-s"
  end
  
  def recreate!
    add_args "-c"
  end
  
  def data_only!
    add_args "-a", '--disable-triggers'
    add_args '-T', 'schema_migrations'
  end
  
  def compress! level=9
    add_args '-Z', level if level.present?
  end
  
  def verbose!
    add_args "-v"
  end
  
  def pretty!
    add_args '--column-inserts'
  end
  
  def connection= opts
    add_args '-p', opts['port'] if opts['port'].present?
    add_args '-h', opts['host'] if opts['host'].present?
    add_args '-U', opts['username'] if opts['host'].present?
  end
  
  def output= filename
    add_args "-f", filename
  end
  
  private
  def find_executable
    [ENV['PG_DUMP'], %x{which pg_dump}.strip].each do |pg|
      return pg if pg.present? && File.exists?(pg)
    end
    nil
  end
  
  def add_args(*args)
    @args.push *args.map!(&:to_s)
    @args.uniq!
  end
  
  
end