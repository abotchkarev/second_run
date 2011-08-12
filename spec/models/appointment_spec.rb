require 'spec_helper'

describe Appointment do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: appointments
#
#  id              :integer         not null, primary key
#  time_factor     :integer
#  summary         :text
#  active          :boolean         default(TRUE)
#  created_at      :datetime
#  updated_at      :datetime
#  relationship_id :integer
#  pause           :boolean         default(FALSE)
#  start_time      :datetime
#  end_time        :datetime
#

