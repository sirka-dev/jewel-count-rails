# モデルスキーマ
# t.string :name
# t.string :category
# t.datetime :start_date
# t.datetime :end_date

class Event < ApplicationRecord
  scope :term, -> name do
    where(name: name).select("start_date, end_date").first
	end
end
