module MatchAndPrint
  REGEXP = /(GET|POST|PUT|DELETE)?\s+(\/[\w\:\/\(\)\.]+)\s+(\{.*\})$/


  def match_and_print(reg, *strings)
    strings.flatten.each do |str|
      md = reg.match(str)
      response = "String: #{str.gsub(/\s{3,}/, "->")}"
      if md
        md.captures.each do |cap|
          response << "\nCapture: #{cap}"
        end
      else
        response << "\n No match"
      end
      puts response
    end
  end


end