class CreateLinks < ActiveRecord::Migration[7.0]
  def change
    create_table :links do |t|

      t.bigint :link_id, null: false , index: true
      t.string :url, null: false
      t.bigint :clicked,  default: 0

      t.belongs_to :user
      t.timestamps
    end
  end
end
