class User < ApplicationRecord
    self.per_page = 3
    def self.type_matches str
        User.where('firstName LIKE ? or lastName LIKE ? or email LIKE ?',"%#{str}%","%#{str}%","%#{str}%" ).all
    end
end
