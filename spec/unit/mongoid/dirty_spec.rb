require "spec_helper"

describe Mongoid::Dirty do

  describe "test attribute changes" do

    context "when a document is new" do
      
      before do
        @post = Post.new
      end

      it "should not be changed" do
        @post.changed?.should == false
      end
      
      it "should have no changes" do
        @post.changes.should == {}
      end
      
    end
    
    context "when a new document is given attributes" do
      
      before do
        @post = Post.new(:title => 'New Post')
      end
      
      it "should be changed" do
        @post.changed?.should == true
      end
      
      it "should have :title in changes" do
        @post.changes['title'].should == [ nil, 'New Post' ]
      end
      
      context ":title" do
        
        it "should be changed" do
          @post.title_changed?.should == true
        end
          
        it "should have +nil+ for its previous value" do
          @post.title_was.should == nil
        end
        
      end
      
      context "after saving" do
        
        before do
          @post.save
        end
        
        it "should not be changed" do
          @post.changed?.should == false
        end
        
        it "should have no changes" do
          @post.changes.should == {}
        end
        
        it "should have :title in previous changes" do
          @post.previous_changes['title'].should == [ nil, 'New Post' ]
        end
      
      end
    
    end
    
    context "when a document is loaded from a collection" do
      
      before do
        @post = Post.new(:title => 'New Post')
        @post.save

        @from_db = Post.find(@post.id)
      end
      
      it "should not be changed" do
        @from_db = Post.find(@post.id)
        @from_db.changed?.should == false
      end

      it "should have no changes" do
        @from_db.changes.should == {}
      end
    
    end
    
    context "when a loaded document is given attributes" do
      
      before do
        @post = Post.new(:title => 'New Post')
        @post.save

        @from_db = Post.find(@post.id)
        @from_db.title = 'New Title'
      end
      
      it "should be changed" do
        @from_db.changed?.should == true
      end
      
      it "should have :title in changes" do
        @from_db.changes['title'].should == [ 'New Post', 'New Title' ]
      end
      
      context ":title" do
        
        it "should be changed" do
          @from_db.title_changed?.should == true
        end
          
        it "should have 'New Post' for its previous value" do
          @from_db.title_was.should == 'New Post'
        end
        
      end
      
      context "after saving" do
        
        before do
          @from_db.save
        end
        
        it "should not be changed" do
          @from_db.changed?.should == false
        end
        
        it "should have no changes" do
          @from_db.changes.should == {}
        end
        
        it "should have :title in previous changes" do
          @from_db.previous_changes['title'].should == [ 'New Post', 'New Title' ]
        end
      
      end
    
    end
    
  end

end
