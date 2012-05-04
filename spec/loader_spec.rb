require_relative '../lib/secrets/loader'

describe Secrets::Loader do
  subject { Secrets::Loader }
  
  before do
    @test_secrets = File.expand_path("../fixtures/test_secrets.yml", __FILE__)
  end
  
  describe "environmentalizing" do
    it "environmentalizes all top-level variables" do
      subject.environmentalize!(@test_secrets)
      
      ENV["FAVORITE_COLOR"].should == "Rainbow"
      ENV["MOST_AWESOME_NINJA_TURTLE"].should == "Donatello"
    end
    
    context "when given a scope" do
      it "environmentalizes variables in the scope" do
        subject.environmentalize!(@test_secrets, "fools")
        
        ENV["FIRST_FOOL"].should == "Feste"
        ENV["SECOND_FOOL"].should == "Patchface"
      end
    
      it "still environmentalizes top-level variables" do
        ENV["FAVORITE_COLOR"] = nil
        
        subject.environmentalize!(@test_secrets, "fools")
        ENV["FAVORITE_COLOR"].should be_present
      end
      
      it "does not environmentalize other scopes" do
        ENV["FIRST_FOOL"] = nil
        
        subject.environmentalize!(@test_secrets, "heroes")
        ENV["FIRST_FOOL"].should_not be_present
      end
    end
  end
  
  it "can return a string suitable for adding vars to Heroku" do
    heroku_string = subject.for_heroku(@test_secrets, "fools")
    heroku_string.should == "FAVORITE_COLOR=Rainbow MOST_AWESOME_NINJA_TURTLE=Donatello FIRST_FOOL=Feste SECOND_FOOL=Patchface "
  end
end