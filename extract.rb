require 'open-uri'

file = open(ARGV[0]).read

EXCERPT_FORMAT = "------------------------------------------------\r\n%s\r\n"

def sanitize_non_ascii(string)
  encoding_options = {
    invalid: :replace,
    undef: :replace,
    replace: '_',
  }

  string.encode Encoding.find('ASCII'), encoding_options
end

matched_endpoints = []

original_regex = /(^.*?("|')(\/[\w\d\?\/&=\#\.\!:_-]*?)(\2).*$)/
regex = /(.*?("|'|\/)\^?\\?(\/[\w\d\?\/&=\#\.\!:_\-\\]*)(\2|))/
sanitize_non_ascii(file).gsub(/;/, "\n").scan(regex).map do |string|
  string[2].gsub!("\\/", "/")

  next if matched_endpoints.include?(string[2])

  matched_endpoints << string[2]

  puts string[2]

  puts format(EXCERPT_FORMAT, string[0]) if ARGV[1] == '-c'
end
