class Jewel < ApplicationRecord
	scope :usage, -> usage do
		if usage == "全部" then
			all
		else
			where(usage: usage)
		end
	end
end
