class Instructor < ActiveRecord::Base
  attr_accessor :remember_token

  # Return hash digest of the given string.
  def Instructor.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Return random token.
  def Instructor.new_token
    SecureRandom.urlsafe_base64
  end
  
  # Remember user for pesistent sessions in db
  def remember
      self.remember_token = Instructor.new_token
      update_attribute(:remember_digest,Instructor.digest(remember_token))
  end
  
end
