require 'pg_dumper'

describe PgDumper do

  let(:database) { "database" }
  let(:pg_dumper) { PgDumper.new(database) }
  let(:subject) { pg_dumper }

  context "with pg_dump utility" do
    before { subject.stub(:find_executable){ "pg_dump" } }
    its(:command) { should == "pg_dump database" }
    its(:args) { should be_empty }

    context "with output set" do
      let(:file) { "my-file" }
      before { subject.output = file }
      its(:command) { should == "pg_dump -f #{file} database" }
      its(:output) { should == file }
      its(:args) { should == ["-f", file] }
    end
  end
end
