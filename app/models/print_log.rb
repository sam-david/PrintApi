class PrintLog < ApplicationRecord
  belongs_to :job
  validates_presence_of :job
end
