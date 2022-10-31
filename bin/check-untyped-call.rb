#!/usr/bin/env ruby

require 'open3'
require 'csv'

def red(str)
  "\e[31m#{str}\e[0m"
end

def green(str)
  "\e[32m#{str}\e[0m"
end

out, err, status = Open3.capture3('steep', 'stats')
unless status.success?
  raise <<~END
    steep stats` fails.
    stdout:
    #{out}

    stderr:
    #{err}
  END
end

ok = true
CSV.parse(out, headers: true).each do |row|
  untyped_calls = row['Untyped calls']
  next if untyped_calls == '0'

  s = 's' unless untyped_calls == '1'
  puts red "#{untyped_calls} method call#{s} with untyped receiver detected from #{row['File']}. Please assign the expected type to the receiver#{s}"
  ok = false
end

exit 1 unless ok

puts green "No untyped calls detected. 🐾"
