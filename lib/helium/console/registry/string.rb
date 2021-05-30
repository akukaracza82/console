module Helium
  class Console
    register String do
      Helium::Console.format_string(
        "\"#{object.gsub('"', '\"')}\"",
        max_width: max_width,
        max_lines: max_lines,
        overflow: overflow,
        ellipses: "...\""
      )
    end
  end
end
