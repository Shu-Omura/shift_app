module WorkingResultsHelper

  def hours_and_mins(second)
    return "-" if second.nil?
    hours = second.div(3600)
    mins = second.modulo(3600).div(60)
    "#{hours}時間#{mins}分"
  end

  def currency(price)
    return "-" if price.nil?
    ActiveSupport::NumberHelper.number_to_delimited(price.div(3600)) + "円"
  end
end
