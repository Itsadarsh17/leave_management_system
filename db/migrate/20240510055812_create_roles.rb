class CreateRoles < ActiveRecord::Migration[6.0]
  def change
    create_table :roles do |t|
      t.string :name, null: false

      t.timestamps
    end

    Role.create(name: 'user')
    Role.create(name: 'manager')
    Role.create(name: 'admin')
  end
end