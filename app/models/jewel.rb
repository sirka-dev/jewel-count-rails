class Jewel < ApplicationRecord
	scope :usage, -> usage do
		if usage == "#{Settings.usage.all}" then
			all
		else
			where(usage: usage)
		end
	end

	scope :date_between, -> from, to do
		if from.present? && to.present? then
			from += ' 00:00:00' if !from.include?(':')
			to += ' 23:59:59' if !to.include?(':')
			where( date: from..to )
		elsif from.present? then
			from += ' 00:00:00' if !from.include?(':')
			where( "date >= ?", from )
		elsif to.present? then
			to += ' 23:59:59' if !to.include?(':')
			where( "date <= ?", to )
		else
			all
		end
	end

	scope :enable, -> do
		where( delflag: false )
	end

	scope :disable, -> do
		where( delflag: true )
	end

	scope :minDate, -> do
		if Jewel.any? then
			minimum(:date).strftime("%Y-%m-%d")
		else
			Date.today
		end
	end
end
