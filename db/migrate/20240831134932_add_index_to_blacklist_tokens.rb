class AddIndexToBlacklistTokens < ActiveRecord::Migration[7.2]
  def change
    add_index :blacklist_tokens, :token, unique: true
  end
end
