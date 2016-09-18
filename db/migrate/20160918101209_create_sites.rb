class CreateSites < ActiveRecord::Migration[5.0]
  def change
    enable_extension 'uuid-ossp'

    create_table :sites, id: :uuid do |t|
      t.string :uri, null: false, comment: 'Full URI that will be checked (with protocol and path)'
      t.string :name,             comment: 'Short name displayed to humans'

      t.timestamps
    end
  end
end
