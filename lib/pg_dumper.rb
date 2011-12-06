require 'pg_dumper/vendor/escape'
require 'tempfile'
require 'open3'

class PgDumper
  require 'pg_dumper/railtie' if defined?(Rails)

  attr_reader :database
  attr_reader :output

  def initialize database, binary = nil
    @database = database or raise "no database given"
    @args = []
    @options = {}
    @binary = binary
  end

  def run(mode = :silent)
    raise "ERROR: pg_dump executable not found" unless binary

    options = {}

    case mode
    when :silent
      options[:out] = "/dev/null"
    end

    execute command, options
  end

  def command
    Escape.shell_command([binary, *args, database]).to_s
  end

  def schema_only!
    add_args "-s"
  end

  def create!
    add_args "-C"
  end

  def clean!
    add_args "-c"
  end

  def data_only!
    add_args "-a", '--disable-triggers'
    add_args '-T', 'schema_migrations'
  end

  def compress! level=9
    add_args '-Z', level if level
  end

  def verbose!
    @stderr = nil
    add_args "-v"
  end

  def pretty!
    add_args '--column-inserts'
  end

  def silent!
    # FIXME: this is not windows friendly
    # try to use same solution as Bundler::NULL
    @stderr = "/dev/null"
  end

  def connection= opts
    add_args('-p', opts['port']) if opts['port']
    add_args('-h', opts['host']) if opts['host']
    add_args('-U', opts['username']) if opts['host']
  end
  alias :auth= :connection=

  def output= filename
    @output = filename
  end

  def output?
    !!@output
  end

  def output
    File.path(@output)
  end

  def tempfile
    @tempfile ||= new_tempfile
  end

  def args
    if output?
      @args.dup.push('-f', output)
    else
      @args
    end
  end

  private

  def binary
    @binary ||= find_executable
  end

  def execute(cmd, options)
    puts [cmd, options].inspect
    if output?
      system(cmd, options)
    else
      stdout, status = Open3.capture2(cmd, options)
      stdout
    end
  end

  def find_executable
    [ENV['PG_DUMP'], %x{which pg_dump}.strip].each do |pg|
      return pg if pg && File.exists?(pg)
    end
    nil
  end

  def add_args(*args)
    @args.push *args.map!(&:to_s)
    @args.uniq!
  end

  def stdout
    @stdout || $stdout
  end

  def stderr
    @stderr || $stderr
  end

  def new_tempfile
    tempfile = Tempfile.new('pg_dumper')
    at_exit {
      tempfile.close
      tempfile.unlink
    }
    tempfile
  end

end
