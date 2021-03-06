require_relative '../lib/secretive/loader'

describe Secretive::Loader do
  subject { Secretive::Loader }

  let(:test_secrets)        { File.expand_path("../fixtures/test_secrets.yml", __FILE__) }
  let(:empty_secrets)       { File.expand_path("../fixtures/empty_secrets.yml", __FILE__) }
  let(:nonexistent_secrets) { File.expand_path("../fixtures/nonexistent_secrets.yml", __FILE__) }

  describe "environmentalizing" do
    it "environmentalizes all top-level variables" do
      subject.environmentalize!(test_secrets)

      ENV["FAVORITE_COLOR"].should == "Rainbow"
      ENV["MOST_AWESOME_NINJA_TURTLE"].should == "Donatello"
    end

    it "doesn't barf when given an empty variable" do
      expect { subject.environmentalize!(test_secrets) }.not_to raise_error
    end

    it "doesn't barf when given an empty file" do
      expect { subject.environmentalize!(empty_secrets) }.not_to raise_error
    end

    context "without a secrets file" do
      it "doesn't barf" do
        subject.stub(:warn) # Prevent warning from displaying in test output
        expect { subject.environmentalize!(nonexistent_secrets) }.not_to raise_error
      end

      it "gives a warning" do
        subject.should_receive(:warn).with("secretive attempted to initialize, but #{nonexistent_secrets} does not exist.")
        subject.environmentalize!(nonexistent_secrets)
      end
    end

    context "when given a scope" do
      it "environmentalizes variables in the scope" do
        subject.environmentalize!(test_secrets, "fools")

        ENV["FIRST_FOOL"].should == "Feste"
        ENV["SECOND_FOOL"].should == "Patchface"
      end

      it "doesn't barf when given a scope filled with empty variables" do
        expect { subject.environmentalize!(test_secrets, "filled_with_empty") }.not_to raise_error
      end

      it "doesn't barf when given an empty scope" do
        expect { subject.environmentalize!(test_secrets, "empty_scope") }.not_to raise_error
      end

      it "doesn't barf when given a scope when no file is found" do
        expect { subject.environmentalize!(empty_secrets, "any_scope") }.not_to raise_error
      end

      it "still environmentalizes top-level variables" do
        ENV["FAVORITE_COLOR"] = nil

        subject.environmentalize!(test_secrets, "fools")
        ENV["FAVORITE_COLOR"].should be_present
      end

      it "does not environmentalize other scopes" do
        ENV["FIRST_FOOL"] = nil

        subject.environmentalize!(test_secrets, "heroes")
        ENV["FIRST_FOOL"].should_not be_present
      end
    end

  end

  describe "Heroku string:" do
    it "can return a string suitable for adding vars to Heroku" do
      heroku_string = subject.for_heroku(test_secrets, "fools")
      heroku_string.should == "FAVORITE_COLOR=Rainbow MOST_AWESOME_NINJA_TURTLE=Donatello FIRST_FOOL=Feste SECOND_FOOL=Patchface "
    end

    it "does not include empty scopes in the string" do
      heroku_string = subject.for_heroku(test_secrets, "fools")
      heroku_string.should_not include "empty_scope"
    end
  end
end
