module TinyUrl
  class << self
    def add_salt_int salt_int=32674
      @salt = salt_int
    end
    def encode(hash)
      @salt ||= 0
      puts "hash = #{hash}, which is a #{hash.class.name}"
      (hash.to_i(16) + @salt).to_s(32)
    end

    def decode(tiny)
      @salt ||= 0
      (tiny.to_i(32) - @salt).to_s(16)
    end
  end
end