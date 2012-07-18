module MenuPagesHelper

  def select_menu(menu)
    self.menu_selected = menu
    session[:menu_selected] = menu
  end

  def menu_selected?
    !menu_selected.nil?
  end

  def menu_selected=(menu)
    @menu_selected = menu
  end

  def menu_selected
    @menu_selected
  end

  def unselect_menu
    self.menu_selected = nil
    #session.data.delete :menu_selected
    session.delete(:menu_selected)
  end

  def menu_selected?(menu)
    menu == menu_selected
  end

end
