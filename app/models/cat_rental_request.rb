# == Schema Information
#
# Table name: cat_rental_requests
#
#  id         :integer          not null, primary key
#  cat_id     :integer          not null
#  start_date :datetime         not null
#  end_date   :datetime         not null
#  status     :string           default("PENDING")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'byebug'

class CatRentalRequest < ActiveRecord::Base
  validates :cat_id, :start_date, :end_date, :status, presence: true
  validates :status, inclusion: ['PENDING', 'APROVED', 'DENIED']
  validate :overlapping_approved_request

  belongs_to :cat,
    foreign_key: :cat_id,
    primary_key: :id,
    class_name: "Cat"

  def approve!
    CatRentalRequest.transaction do
      update!(status: "APROVED")
      overlap = overlapping_request
      overlap = overlap.each do |request|
        if request.status == "PENDING"
          request.update!(status: "DENIED")
        end
      end
    end
  end

  def deny!
    CatRentalRequest.transaction do
      update!(status: "DENIED")
    end
  end

  private

  def overlapping_request
    cat_requests = CatRentalRequest.where(cat_id: cat_id)
    overlap = []

    cat_requests.each do |request|
      next if self.id == request.id
      overlap << request if start_date.between?(request.start_date, request.end_date)
      overlap << request if end_date.between?(request.start_date, request.end_date)
    end
    overlap
  end

  def overlapping_approved_request
    overlap = overlapping_request

    if overlap.any? {|request| request.status == 'APROVED' } && status != "DENIED"
      errors[:overlap] << "Cat has been booked during requested times"
    end
  end

end
