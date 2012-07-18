module MenuPagesHelper

  def select_menu(menu)
    self.menu_selected = menu
    session[:menu_selected] = menu
  end
  def select_item(menu_item)
    if menu_selected?
      self.item_selected = menu_item
      session[:item_selected] = menu_item
    end
  end

  def menu_selected?
    !menu_selected.nil?
  end
  def item_selected?
    !item_selected.nil?
  end

  def menu_selected=(menu)
    @menu_selected = menu
  end
  def item_selected=(menu_item)
    @item_selected = menu_item
  end

  def menu_selected
    @menu_selected ||= session[:menu_selected]
  end
  def item_selected
    @item_selected ||= session[:item_selected]
  end

  def unselect_menu
    self.menu_selected = nil
    #session.data.delete :menu_selected
    session.delete(:menu_selected)
  end
  def unselect_item
    self.item_selected = nil
    #session.data.delete :menu_selected
    session.delete(:item_selected)
  end

  def selected_menu?(menu)
    menu == menu_selected
  end
  def selected_item?(menu_item)
    menu_item == item_selected
  end
  def selected_vehicle?
    vehicle_items = ['new','list']
    vehicle_items.include?(item_selected)
  end

end
