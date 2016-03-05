#
#  hash.rb
#
#  Copyright (c) 2016 Netguru Sp. z o.o. All rights reserved.
#

class Hash

  def compact
    delete_if { |key, value| value.nil? }
  end

  def replace(key, new_value)
    cloned = clone
    cloned[key] = new_value
    cloned
  end

end
