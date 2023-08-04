class LoginService
  def valid_password?(password_from_db, user_input_password)
    BCrypt::Password.new(password_from_db) == user_input_password
  end

  def validate(email, user_input_password)
    connection = DatabaseConnection.connection
    user = User.find_by_email(email)
    if(user && valid_password?(user.password, user_input_password))
      user
    else  
      puts "Invalid User or Password" 
      exit
    end
  end
end
