class Instructor < ActiveRecord::Base
	validates :name, presence: true
	has_many :courses, dependent: :destroy
end
