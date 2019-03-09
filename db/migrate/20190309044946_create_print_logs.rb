class CreatePrintLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :print_logs do |t|
      t.belongs_to :job
      t.float :tool_temp
      t.float :bed_temp
      t.float :filament_length
      t.float :estimated_total_print_time
      t.integer :print_time
      t.integer :print_time_left
      t.float :completion_percentage
      t.datetime :logged_at
      t.string :state

      t.timestamps
    end
  end
end
