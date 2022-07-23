class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, nill: false
      t.string :password_digest, null: false, default: ""
      t.text :refresh_token, default: ""
      t.datetime :refresh_token_expire, default: -> { 'CURRENT_TIMESTAMP' }

      t.timestamps
    end
  end
end
