# Fix for Ruby 3.3 + CGI + Rails + GlobalID
require "cgi"

class CGI
  @@accept_charset = Encoding::UTF_8 unless defined?(@@accept_charset)
end
