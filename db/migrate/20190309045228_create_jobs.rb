class CreateJobs < ActiveRecord::Migration[5.2]
  def change
    create_table :jobs do |t|
      t.belongs_to :component
      t.string :gcode_title
      t.string :display_title
      t.integer :priority
      t.string :slicer_profile
      t.float :estimated_print_time
      t.float :actual_filament_length
      t.float :estimated_filament_length
      t.float :filament_weight
      t.integer :build_time_hours
      t.integer :build_time_minutes
      t.datetime :sliced_at
      t.datetime :started_at
      t.datetime :finished_at
      t.string :slicer

      t.timestamps
    end
  end
end
