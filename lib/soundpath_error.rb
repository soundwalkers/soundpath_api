class SoundpathError < StandardError
  attr_reader :error_code, :status
  
  def initialize(error_type, context_msg = nil, *base_msg_args)
    @error_code, @status, base_msg = *error_type
    
    messages = Array.new
    messages << sprintf(base_msg, *base_msg_args)
    messages << context_msg unless context_msg.blank?
    @message = messages.join(" - ") 
    super(@message)
  end
  
  HTTP_BAD_REQUEST           = 400
  HTTP_UNAUTHORIZED          = 401
  HTTP_FORBIDDEN             = 403
  HTTP_NOT_FOUND             = 404
  HTTP_CONFLICT              = 409
  HTTP_INTERNAL_SERVER_ERROR = 500
  HTTP_BAD_GATEWAY           = 502
  
  # Base Errors
  REQUEST_INVALID = [100, HTTP_BAD_REQUEST, "Invalid request"]
  DATABASE_ERROR = [101, HTTP_INTERNAL_SERVER_ERROR, "Your request could not be completed due to an internal server error"]
  SYSTEM_ERROR = [102, HTTP_INTERNAL_SERVER_ERROR, "System Exception Encountered"]
  UNAUTHORIZED_REQUEST = [103, HTTP_UNAUTHORIZED, "Unauthorized - check credentials"]
  RESOURCE_NOT_FOUND = [104, HTTP_NOT_FOUND, "Resource not found"]
  REQUEST_CONFLICT = [105, HTTP_CONFLICT, "Conflict"]
  FILE_UPLOAD_ERROR = [106, HTTP_INTERNAL_SERVER_ERROR, "Could not upload file" ]

  #BAND ERRORS
  BAND_NOT_FOUND = [201, HTTP_NOT_FOUND, "Band not found"]

end
