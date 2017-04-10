CalcModuleBase = require './atom-emacs-calc-module-base'

module.exports =
class BasicMath extends CalcModuleBase
  doCalc: (op, current, operand) ->
    switch op
      when '+' then current += operand
      when '-' then current -= operand
      when '*' then current *= operand
      when '/' then current /= operand
      when '%' then current %= operand
      when '^' then current = Math.pow(current, operand)
      when '&' then current &= operand
      when '|' then current |= operand
    return current

  tryMath: (statement) ->
      result = null
      matches = /([\+\-\*\/\%\^\&\|])\s+([\-\+\.\w\s]+)/.exec(statement)
      if (!!matches)
        vals = matches[2].split(/\s+/)
        for val in vals
          val = @toNumber(val)
          if isNaN(val)
            return null
          if result == null
            result = val
          else
            result = @doCalc(matches[1], result, val)
      return result
