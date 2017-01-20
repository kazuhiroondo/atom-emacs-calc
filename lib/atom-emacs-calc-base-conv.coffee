CalcModuleBase = require './atom-emacs-calc-module-base'

module.exports =
class BaseConv extends CalcModuleBase
  baseConv: (op, operand) ->
    operand = @toNumber(operand)
    if isNaN(operand)
      return null

    base = 10
    prefix = ""
    switch op
      when "bin"
        base = 2
        prefix = "0b"
      when "oct"
        base = 8
        prefix = "0o"
      when "hex"
        base = 16
        prefix = "0x"

    return prefix + operand.toString(base)

  tryMath: (statement) ->
      result = null
      matches = /(dec|bin|hex|oct)\s+([\-\+\.\w]+)\s*$/.exec(statement)
      if (!!matches)
        result = @baseConv(matches[1], matches[2])
      return result
