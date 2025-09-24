module Ui
  RESET  = "\e[0m"
  BOLD   = "\e[1m"
  RED    = "\e[31m"
  GREEN   = "\e[32m"
  YELLOW = "\e[33m"
  BLUE   = "\e[34m"
  CYAN   = "\e[36m"

  module_function

  def clear_screen
    print("\e[H\e[2J")
  end

  def color(text, code)
    "#{code}#{text}#{RESET}"
  end

  def banner(text, width:  fifty)
    w = width_value(width)
    puts("#" * w)
    centered = center_line("### #{text} ###", w)
    puts(centered)
    puts("#" * w)
  end

  def box(title:, lines:, width: fifty)
    w = width_value(width)
    puts("+#{'-' * (w - 2)}+")
    puts("| #{pad(title, w - 4)} |") unless title.to_s.strip.empty?
    puts("+#{'-' * (w - 2)}+")
    lines.each do |line|
      puts("| #{pad(line, w - 4)} |")
    end
    puts("+#{'-' * (w - 2)}+")
  end

  def section(title, width: fifty)
    w = width_value(width)
    str = title.to_s.strip
    if str.empty?
      puts("+#{'-' * (w - 2)}+")
    else
      inner = " #{str} "
      dashes = (w - 2) - inner.length
      left = dashes / 2
      right = dashes - left
      puts("+#{'-' * left}#{inner}#{'-' * right}+")
    end
  end

  def separator(width: fifty)
    w = width_value(width)
    puts('-' * w)
  end

  def fifty
    54
  end

  def width_value(val)
    val.is_a?(Integer) ? val : fifty
  end

  def pad(text, len)
    str = text.to_s
    str.length >= len ? str[0, len] : str.ljust(len, ' ')
  end

  def center_line(text, width)
    text.center(width, ' ')
  end
end


