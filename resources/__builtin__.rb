class Image
  alias_method :w, :width
  alias_method :h, :height

  def square(x_offset = 0, y_offset = 0)
    l = width > height ? height : width
    cx = width / 2
    cy = height / 2
    crop(cx - l/2 + x_offset, cy - l/2 + y_offset, l, l)
  end

  def aspect_ratio
    width.to_f / height
  end

  def fitw(height)
    aspect_ratio * height
  end

  def fith(width)
    (1.0 / aspect_ratio) * width
  end
end

module URI
  def self.encode_www_form(enum)
    enum.map do |k,v|
      if v.nil?
        encode_www_form_component(k)
      elsif v.respond_to?(:to_ary)
        v.to_ary.map do |w|
          str = encode_www_form_component(k)
          unless w.nil?
            str += '='
            str += encode_www_form_component(w)
          end
        end.join('&')
      else
        str = encode_www_form_component(k.to_s)
        str += '='
        str += encode_www_form_component(v)
      end
    end.join('&')
  end
end

module Browser
  def self.json(url)
    JSON::parse(get(url))
  end

  def self.encode(str)
    URI.encode_www_form_component(str)
  end
  
  def self.post(url, opts)
    if opts[:json]
      post_in(url, opts[:header], JSON.stringify(opts[:json]))
    elsif opts[:body].is_a? Hash
      post_in(url, opts[:header], URI.encode_www_form(opts[:body]))
    else
      post_in(url, nil, opts[:body])
    end
  end
end

module Kernel
  ##
  # Invoke method +print+ on STDOUT and passing +*args+
  # Customize for Image
  #
  # ISO 15.3.1.2.10
  def print(*args)
    i = 0
    len = args.size
    while i < len
      if args[i].is_a?(Image) || args[i].is_a?(AttrString)
        __printstr__ args[i]
      else
        __printstr__ args[i].to_s
      end
      i += 1
    end
  end

  ##
  # Invoke method +puts+ on STDOUT and passing +*args*+
  # Customize for Image
  #
  # ISO 15.3.1.2.11
  def puts(*args)
    i = 0
    len = args.size
    while i < len
      if args[i].is_a?(Image) || args[i].is_a?(AttrString)
        __printstr__ args[i] 
        __printstr__ "\n"
      else
        s = args[i].to_s
        __printstr__ s
        __printstr__ "\n" if (s[-1] != "\n")
      end
      i += 1
    end
    __printstr__ "\n" if len == 0
    nil
  end
  
  def prompt(header = "$")
    print header + " "
    input = gets
    puts input
    input
  end

  def choise(candidates, opts = {})
    candidates.each_with_index do |e, index|
      print "#{index+1}: " if opts[:with_no]
      print AttrString.new(e, link: "#{index}")
      if opts[:combine]
        print ", " if candidates.length-1 != index
      else
        print "\n"
      end
    end

    loop do
      no = clicked_link
      return candidates[no.to_i] if no
      sleep 0.1
    end
  end
end

class Dir
  def self.home
    File.expand_path("~")
  end

  def self.documents
    File.join(home, "Documents")
  end
end
