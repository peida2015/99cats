# == Schema Information
#
# Table name: cats
#
#  id          :integer          not null, primary key
#  birth_date  :datetime         not null
#  color       :string           not null
#  name        :string           not null
#  sex         :string(1)        not null
#  description :text             not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Cat < ActiveRecord::Base
  COLORS = ['brown', 'black', 'white', 'red', 'green', 'gold']

  validates :name, :color, :birth_date, :sex, :description, presence: true
  validates :color, inclusion: COLORS
  validates :sex, inclusion: ['M', 'F']

  has_many :requests,
    primary_key: :id,
    foreign_key: :cat_id,
    class_name: "CatRentalRequest",
    dependent: :destroy

  def age
    Time.now.year - birth_date.year
  end
end
