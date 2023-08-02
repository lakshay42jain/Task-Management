class LoginService

  def password_match(query_result_for_pass,user_input_password)
    BCrypt::Password.new(query_result_for_pass[0]['password']) == user_input_password
  end

  def validate(email,user_input_password)
    connection = DatabaseConnection.connection
    query_result_for_email = connection.exec_params("SELECT COUNT(*) FROM users WHERE email=$1", [email])
    query_result_for_pass = connection.exec_params("SELECT password FROM users WHERE email=$1", [email])

    if (query_result_for_email[0]['count'].to_i >= 1 and password_match(query_result_for_pass,user_input_password))
      res = connection.exec_params("SELECT * from users where email=$1", [email])
      return User.new(
        name: res[0]['name'],
        email: res[0]['email'],
        password: res[0]['password'],
        type: res[0]['type']
      )
      puts "Email id does not exist or may be password wrong" 
    end
  end
end
