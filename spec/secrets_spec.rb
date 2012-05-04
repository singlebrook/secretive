require_relative '../lib/secrets'

describe Secrets do
  subject { Secrets }
  
  it "supports reading and writing a file" do
    subject.file = "myfile"
    subject.file.should == "myfile"
  end
  
  it "can be configured using a block" do
    subject.should_receive(:file=).with("stuff")
    subject.configure do |config|
      config.file = "stuff"
    end
  end
  
  it "delegates #environmentalize! to the Loader" do
    subject::Loader.should_receive(:environmentalize!)
    subject.environmentalize!
  end
end