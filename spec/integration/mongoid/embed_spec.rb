require "spec_helper"

describe "Testing some embed cases" do

  before do
    Blog.delete_all
    Article.delete_all
    # Editorial.delete_all
    # Note.delete_all
  end
  
  context "some embedded test" do
    
    it "does something" do
      # puts "WTF"
      article = Article.new(:name => 'My Dog Runs', :entry => 'I love him so much')
      article.notes.build(:body => 'this is a stupid article. stop writing')
      article.save

      blog = Blog.new(:title => 'My Cat Blog')
      lambda {
        blog.editorials << article
      }.should raise_error
    end
    
  end
  
end
