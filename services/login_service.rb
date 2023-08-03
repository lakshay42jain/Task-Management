class LoginService
  def password_match(password_from_db, user_input_password)
    BCrypt::Password.new(password_from_db) == user_input_password
  end

  def validate(email, user_input_password)
    connection = DatabaseConnection.connection
    user = User.find_by_email(email)
    if(user && password_match(user.password, user_input_password))
      user
    else  
      puts "Email id does not exist or may be password wrong" 
      exit 0
    end
  end
end
