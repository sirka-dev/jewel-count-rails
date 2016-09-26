class Jewel < ApplicationRecord
	scope :usage, -> usage do
		if usage == "全部" then
			all
		else
			where(usage: usage)
		end
	end

	scope :date_between, -> from, to do
		if from.present? && to.present? then
			where( date: from..to )
		elsif from.present? then
			where( "date >= ?", from )
		elsif to.present? then
			where( "date <= ?", to )
		else
			all
		end
	end

	scope :enable, -> do
		where( delflag: false )
	end
end
