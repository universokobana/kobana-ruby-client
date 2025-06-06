# frozen_string_literal: true

class String
  def pluralize
    if end_with?("y") && !%w[a e i o u].include?(self[-2].downcase)
      "#{self[0..-2]}ies"
    elsif end_with?("s", "sh", "ch", "x", "z")
      "#{self}es"
    else
      "#{self}s"
    end
  end

  def underscore
    word = gsub("::", "/")
    word.gsub!(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
    word.gsub!(/([a-z\d])([A-Z])/, '\1_\2')
    word.tr!("-", "_")
    word.downcase
  end
end
