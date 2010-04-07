class Blog
  include Mongoid::Document

  field :title, :type => String

  embeds_many :editorials #, :class_name => "Editorial"
end

class Article
  include Mongoid::Document

  field :name, :type => String
  field :entry, :type => String

  embeds_many :notes
end

class Editorial
  include Mongoid::Document

  field :name, :type => String
  field :entry, :type => String

  embedded_in :blog, :inverse_of => :editorials
  embeds_many :notes

end

class Note
  include Mongoid::Document

  field :body, :type => String

  embedded_in :editorial, :inverse_of => :notes
end