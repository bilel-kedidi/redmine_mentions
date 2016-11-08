class CreateMentions < ActiveRecord::Migration
  def change
    create_table :mentions do |t|

      t.integer :user_id

      t.string :issue_id


    end

  end
end
