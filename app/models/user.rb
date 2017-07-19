# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default("0"), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime
#  updated_at             :datetime
#

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  validates :phone_number, format: { with: /\A[+]?\d+(?>[- .]\d+)*\z/, allow_nil: true }

  has_many :comments, dependent: :destroy

  def self.top_ten
  	commenters = Comment.select(:user_id).where('created_at >= ?', 1.week.ago).group("user_id").limit(10).order('count_id desc').count('id')
  	# SELECT  COUNT("comments"."id") AS count_id, "comments"."user_id" AS comments_user_id FROM "comments" 
  	# 	WHERE (created_at >= '2017-07-11 18:13:03.358146') 
  	# 	GROUP BY "comments"."user_id" 
  	# 	ORDER BY count_id desc 
  	# 	LIMIT ?  [["LIMIT", 10]]
  end
end
