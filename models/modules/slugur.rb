module Slugur
  class Counter
    include Mongoid::Document
    field :seq,:type => Integer, default: 0
  end

  def self.included(base)
    base.extend(ClassMethods)
    base.field :url_slug,  :type => String
    base.field :slug_id,    :type => Integer, default: -1
    #create counter in mongoid if it doesn't exist
    counter_id=base.to_s.downcase
    counter = Counter.new
    counter.id=counter_id
    counter.save
    puts "this happened in class #{counter_id}"
  end
  #Strip everything except whitespace, dashes, underscores, and alphanumerics.
  #Replace spaces and underscores with dashes.
  #Convert to lowercase
  def slugify txt, max=2000
    # Perform transliteration to replace non-ascii characters with an ascii
    # character
    value = txt.gsub(/[^\x00-\x7F]/n, '').to_s
    # Remove single quotes from input
    value.gsub!(/[']+/, '')
    # Replace any non-word character (\W) with a space
    value.gsub!(/\W+/, ' ')
    # Remove any whitespace before and after the string
    value.strip!
    # All characters should be downcased
    value.downcase!
    # Replace spaces with dashes
    value.gsub!(' ', '-')
    # Return the resulting slug

    self.url_slug=value[0...max]
    if (self.slug_id == -1)
      self.slug_id = get_slug_id
    end
  end

  def get_slug_id
    counter_id = self.class.to_s.downcase
    Counter.find(counter_id).inc(:seq, 1)
  end

  module ClassMethods
    def slugur_find(the_id)
      if the_id.is_a? Integer
        self.find_by(slug_id: the_id)
      elsif the_id.is_a? String
        self.find(the_id)
      end
    end
  end
  private :get_slug_id
end
