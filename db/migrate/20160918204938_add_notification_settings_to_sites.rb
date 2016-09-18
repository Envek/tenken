class AddNotificationSettingsToSites < ActiveRecord::Migration[5.0]
  def change
    add_column :sites, :failing_since, :datetime
    add_column :sites, :notification_email, :string
    add_column :sites, :last_notification_at, :datetime
  end
end
