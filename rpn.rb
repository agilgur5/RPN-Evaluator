# RPN Evaluator
class RPN
  # ascii constants
  NEGATIVE_SIGN = 45
  ZERO = 48
  NINE = 57

  # character constants
  ADD = '+'
  SUBTRACT = '-'
  MULTIPLY = '*'
  DIVIDE = '/'


  def ascii_string_to_int(rev_int_string)
    int = 0
    rev_int_string.bytes.each_with_index do |char, index|
      byte = char.ord
      if byte == NEGATIVE_SIGN and index == rev_int_string.length - 1
        int *= -1
      elsif byte >= ZERO and byte <= NINE
        int += (byte - ZERO) * (10 ** index)
      else
        abort "invalid number"
      end
    end
    int
  end

  # converts a reversed string to a number via ascii conversion
  def ascii_string_to_num(rev_num_string)
    rev_num_arr = rev_num_string.split('.')
    if rev_num_arr.length == 1 # if integer
      ascii_string_to_int(rev_num_string)
    elsif rev_num_arr.length == 2 # if float
      after_decimal_point = (ascii_string_to_int(rev_num_arr[0]) * 1.0) / (10 ** rev_num_arr[0].length)
      before_decimal_point = ascii_string_to_int(rev_num_arr[1])
      if after_decimal_point < 0 # after decimal point had a -
        abort "invalid number"
      elsif before_decimal_point < 0 # negative number
        (before_decimal_point.abs + after_decimal_point) * -1
      else
        before_decimal_point + after_decimal_point
      end
    else
      abort "invalid number"
    end
  end
  
  def rpn_eval(eval_array)
    elem = eval_array.shift # use it like a stack
    case elem
    when nil, []
      abort "not enough arguments"
    when ADD
      rpn_eval(eval_array) + rpn_eval(eval_array)
    when SUBTRACT
      # not commutative
      -(rpn_eval(eval_array) - rpn_eval(eval_array))
    when MULTIPLY
      rpn_eval(eval_array) * rpn_eval(eval_array)
    when DIVIDE
      # not commutative
      arg2 = rpn_eval(eval_array)
      arg1 = rpn_eval(eval_array)
      arg1 / arg2
    when 'trqs' # 'sqrt' reversed
      Math.sqrt rpn_eval(eval_array)
    when 'mus' # 'sum' reversed
      result = 0
      while eval_array.length > 0 do
        result += rpn_eval(eval_array)
      end
      result
    else
      ascii_string_to_num(elem)
    end
  end

  # eagerly evaluate the eval array
  def eager_eval(eval_array)
    result = rpn_eval(eval_array)
    if eval_array.length > 0
      abort "too many arguments"
    else
      result
    end
  end

  # parse the initial string and return the result
  def parse(str)
    eval_array = str.reverse.split # reverse (prefix notation with reversed numbers), then split by whitespace
    eager_eval(eval_array)
  end

  # to be called from command line
  def self.main(str)
    puts RPN.new.parse(str)
  end

end

if __FILE__ == $0
  RPN.main($stdin.gets)
end