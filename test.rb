require 'date'
time = "2012-11-30 10:51:14 +0100"
dt = DateTime.parse(time)
puts dt.zone
