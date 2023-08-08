class SignupService
  def create_user(name, email, password)
    user = User.new(
      name: name,
      email: email,
      password: password,
      type: 'user'
    )
    if User.find_by_email(email)
      puts "User Already Exist"
    else   
      user.save
    end
  end
end
