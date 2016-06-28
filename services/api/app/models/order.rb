class Order < ActiveRecord::Base
	def one_sweet_done
		return if self.done
		self.amount_ready += 1
		if self.amount_ready == self.amount
			self.done = true
		end
		save!
	end
end