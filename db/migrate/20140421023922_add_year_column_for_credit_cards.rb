class AddYearColumnForCreditCards < ActiveRecord::Migration
  def change
    add_column :credit_cards, :year, :string
  end
end
