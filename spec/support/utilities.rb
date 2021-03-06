def sign_in(user)
  visit signin_path
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
  # Sign in when not using Capybara as well.
  cookies[:remember_token] = user.remember_token
end

def sign_out(user)
  click_link "Sign out"
  # Sign in when not using Capybara as well.
  #cookies.delete(:remember_token)
end

def full_title(page_title)
  base_title = "Open Fleet"
  if page_title.empty?
    base_title
  else
    "#{base_title} | #{page_title}"
  end
end