class CreateRetweets < ActiveRecord::Migration[6.0]
  def change
    create_table :retweets do |t|
      t.references :user, null: false, foreign_key: true
      t.references :tweet, null: false, foreign_key: true

      t.timestamps
    end
  end
end
