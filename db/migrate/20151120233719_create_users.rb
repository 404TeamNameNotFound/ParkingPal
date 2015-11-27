class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :password_digest
      t.string :role

      t.references :parked_meter, index: true, foreign_key: true
      t.references :parking_meter, index: true, foreign_key: true

      t.timestamps
    end
  end
end