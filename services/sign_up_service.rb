class SignupService

  def create_user(name, email, password)
    u = User.new(
      name: name,
      email: email,
      password: password,
      type: 'user'
    )
    u.save
  end
end
