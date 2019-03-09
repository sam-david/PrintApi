class CreatePrintLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :print_logs do |t|

      t.timestamps
    end
  end
end
