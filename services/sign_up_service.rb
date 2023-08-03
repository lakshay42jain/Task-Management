class SignupService
  def create_user(name, email, password)
    user = User.new(
      name: name,
      email: email,
      password: password,
      type: 'user'
    )
    user.save
  end
end
