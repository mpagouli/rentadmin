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

def select_menu(user, menu)
  sign_in user
  if user.admin?
    if menu == 'admin'
      click_link "Administration"
    else 
      click_link menu.capitalize
    end
  end
  # when not using Capybara as well.
  session[:menu_selected] = menu
end

def unselect_menu(user)
  sign_out user
  # when not using Capybara as well.
  session.delete(:menu_selected)
end