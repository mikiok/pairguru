# == Schema Information
#
# Table name: movies
#
#  id          :integer          not null, primary key
#  title       :string
#  description :text
#  released_at :datetime
#  avatar      :string
#  genre_id    :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Movie < ApplicationRecord
  belongs_to :genre
  has_many :comments, dependent: :destroy

  def self.are_pair? opening, closing
    if(opening == '(' && closing == ')')
      return true
    elsif(opening == '{' && closing == '}') 
      return true
    elsif(opening == '[' && closing == ']') 
      return true
    end
    return false
  end

  def self.validate_brackets? title
    characters = title.split(//)
    brackets = []
    characters.each do |character|
      if(character == '(' || character == '{' || character == '[')
        brackets.push(character)
      elsif (character == ')' || character == '}' || character == ']')
        if (!are_pair? brackets.last, character || brackets.empty?)
          return false
        else
          brackets.pop
        end
      end
    end
    brackets.empty?
  end
end
