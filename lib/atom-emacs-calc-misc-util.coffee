CalcModuleBase = require './atom-emacs-calc-module-base'

module.exports =
class MiscUtil extends CalcModuleBase
  doConv: (op, operand) ->
    operand = @toNumber(operand)
    if isNaN(operand)
      return null

    result = null
    switch op
      when "rad" then result = operand * Math.PI / 180
      when "deg" then result = operand * 180 / Math.PI

    return result

  tryMath: (statement) ->
      result = null
      matches = /(rad|deg)\s+([\-\+\.\w]+)\s*$/.exec(statement)
      if (!!matches)
        result = @doConv(matches[1], matches[2])
      return result
