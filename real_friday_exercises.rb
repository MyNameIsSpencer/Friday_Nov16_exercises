require 'date'
require 'active_support'
require 'active_support/core_ext'
require 'holidays'

class Cohort

  FIRST_COFFEE_CODE_WEEK = 3
  LAST_COFFEE_CODE_WEEK = 10
  WEEKS_IN_COHORT = 10




  def initialize(first_day)
    @first_day = first_day
  end

  def last_day
    @first_day + (WEEKS_IN_COHORT - 1).weeks + 4.days
  end

  def no_lecture_on(day)
    day.saturday? || day.sunday? || day.to_date == Date.new(2017,07,03) || double_check_holiday(day)
  end

  def double_check_holiday(day)
    potential_holidays = Holidays.on(day, :ca_on)

    if potential_holidays.any?
      potential_holidays.each do |h|
        print "Are you taking #{h} off? y/N: "
        answer = gets.chomp
        if answer.downcase == 'y'
          return true
        end
      end
    end

    return false
  end

  def class_days
    @class_days ||= []

    if @class_days.empty?
      (@first_day..last_day).each do |day|
        unless no_lecture_on(day)
          @class_days << day
        end
      end
    end

    return @class_days
  end

  def weeks_of_cohort
    (@first_day..last_day).each_slice(7)
  end

  def week_of(day)
    week_number = 1
    weeks_of_cohort.each do |week|
      if week.include?(day)
        return week_number
      end

      week_number += 1
    end

    return nil
  end

  def coffee_code_day?(day)
    day.tuesday? || day.thursday?
  end

  def coffee_code_week?(day)
    week_of(day).between?(FIRST_COFFEE_CODE_WEEK, LAST_COFFEE_CODE_WEEK)
  end

  def coffee_code_days
    list = []

    class_days.each do |day|
      if coffee_code_week?(day) && coffee_code_day?(day)
        list << day
      end
    end

    return list
  end

end


start = Date.new(2017,10,23)
test_date = Date.new(2017,10,30)
my_cohort = Cohort.new(start)
puts my_cohort.inspect
puts my_cohort.weeks_of_cohort.inspect
puts "Will this be a coffee code day? #{my_cohort.coffee_code_day?(test_date)}"
puts "Will this be a coffee code week? #{my_cohort.coffee_code_week?(test_date)}"
puts my_cohort.coffee_code_days


puts "These are the class days for my cohort #{my_cohort.class_days}"





christmas_week = [25, 26 ,27, 28, 29]

def chain_holiday(cohort, array, year, month)
    xer = 1
  array.each do |day|
      xer = day
      holiday = Date.new(year, month, xer)
      puts cohort.no_lecture_on(holiday)
  end
end

 chain_holiday(my_cohort, christmas_week, 2017, 12)


 def chain_check(cohort, array, year, month)
     xer = 1
   array.each do |day|
       xer = day
       holiday = Date.new(year, month, xer)
       puts cohort.double_check_holiday(holiday)
   end
 end

chain_check(my_cohort, christmas_week, 2017, 12)


 puts my_cohort.last_day

puts my_cohort.no_lecture_on(start)




puts '-_-_-_-_-_-_-_-_-_-_-_-_-'
