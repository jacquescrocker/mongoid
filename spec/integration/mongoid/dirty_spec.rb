require "spec_helper"

describe Mongoid::Document do

  before do
    Dog.delete_all
  end
  
  describe "changed?" do
    context "newly created model" do
      before do
        @dog = Dog.new
      end
      it "should not be dirty when initialized" do
        @dog.should_not be_changed
      end

      it "should be dirty after setting name" do
        @dog.name = "Fido"
        @dog.should be_changed
      end
      
      it "should not be dirty after saving" do
        @dog.name = "Fido"
        @dog.save
        @dog.should_not be_changed
      end
      
    end
    
    context "existing model" do
      before do
        Dog.create!(:name => "Rover")
        @dog = Dog.where(:name => "Rover").first
      end
      
      it "should not be dirty after retrieving" do
        @dog.should_not be_changed
      end

      it "should be dirty after changing name" do
        @dog.name = "Rover2"
        @dog.should be_changed
      end

      it "should not be dirty after saving" do
        @dog.name = "Rover2"
        @dog.save
        @dog.should_not be_changed
      end
    end
  end
end
