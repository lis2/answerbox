class AppSpecificStringIO < StringIO
  attr_accessor :filepath
  attr_accessor :content_type

  ###
  # Constructor
  # NOTE: Extends the original implementation, allowing the developer 
  #       to define his own filename and content type for the request
  #
  # @param    string      filepath
  # @param    string      content_type     Ex: image/jpeg, html/text
  # @param    string      stringio
  # @return   void
  ##
  def initialize(filepath, content_type, stringio)
    super(stringio)
    @filepath     = filepath
    @content_type = content_type
  end

  ###
  # Return the original filename
  #
  # @return   string 
  ##
  def original_filename
    File.basename(filepath)
  end
end
