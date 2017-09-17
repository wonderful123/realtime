class RenamePlatformUrlToWebsite < ActiveRecord::Migration[5.1]
  def change
    rename_column :platforms, :url, :website
  end
end
