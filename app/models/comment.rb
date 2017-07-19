class Comment < ApplicationRecord
	belongs_to :user
	belongs_to :movie

	def self.exist_comments? mov_id, current_user
		if current_user.comments.find_by(movie_id: mov_id) != nil
			return true
		else
			return false
		end
	end
end
