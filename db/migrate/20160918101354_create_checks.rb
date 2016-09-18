class CreateChecks < ActiveRecord::Migration[5.0]
  def change
    create_table :checks, id: :uuid do |t|
      t.references :site,             null: false, type: :uuid
      t.datetime   :started_at,       null: false
      t.datetime   :finished_at,      null: false
      t.boolean    :success,          null: false, comment: 'Whether this check considered successful'
      t.integer    :response_code,                 comment: 'HTTP response code'
      t.jsonb      :response_headers,              comment: 'A key-value object of received HTTP headers'
      t.text       :details,                       comment: 'Technical details for debugging'
      t.datetime   :created_at, null: false
      # This model meant to never be changed so updated_at column is not necessary
    end
    add_index :checks, [:site_id, :created_at], order: { created_at: :desc }
    add_foreign_key :checks, :sites, on_update: :cascade, on_delete: :cascade
  end
end
