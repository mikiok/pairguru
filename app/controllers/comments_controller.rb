class CommentsController < ApplicationController
	def create
		comment = current_user.comments.new(comment_params)
		comment.movie_id = params[:id]
		if !Comment.exist_comments? params[:id], current_user
			if comment.save
				flash[:notice]="The trip was succesfully created"
				redirect_to root_path, notice: "Comment created"
			else
				redirect_to root_path, notice: "There was a problem while creating the comment"
			end
		else
			redirect_to root_path, notice: "You have commented already"
		end
	end

	def destroy
		comment.destroy
		binding.pry
		redirect_to root_path, notice: "You have deleted your comment"
	end

	def best_commenters
    usershash = User.top_ten
    @users = []
    usershash.each do |key, value|
    	@users.push(User.find(key))
    end
  end

	private

	def comment_params
		params.require(:comment).permit(:content);
	end

	def comment
		@comment = Comment.find_by(id: params[:id])
	end
end
