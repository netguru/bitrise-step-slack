#
#  string.rb
#
#  Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
#

class String

  def is_numeric?
    Float(self) != nil rescue false
  end

end
