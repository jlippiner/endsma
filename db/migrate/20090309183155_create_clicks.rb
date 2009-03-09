class CreateClicks < ActiveRecord::Migration
  def self.up
    create_table :clicks do |t|
      t.string :referral
      t.string :tags
      t.string :ip_address
      t.string :useragent

      t.timestamps
    end
  end

  def self.down
    drop_table :clicks
  end
end
