CalcModuleBase = require './atom-emacs-calc-module-base'

module.exports =
class MathEval extends CalcModuleBase
  regExp : null

  constructor: ->
    super()
    props = Object.getOwnPropertyNames(Math)
    funcs = props.filter(@funcFilter)
    @regExp = "^("
    @regExp += funcs.join('|')
    @regExp += ")\\s+([\\-\\+\\.\\w\\s]+)"

  funcFilter: (p) ->
    return typeof(Math[p]) == 'function' &&
           Math[p].length > 0 && Math[p].length < 3

  callMathOp: (op, opers) ->
    result = null

    if Math[op].length != opers.length
      return null

    for i in [0..(opers.length - 1)]
      val = @toNumber(opers[i])
      if isNaN(val)
        return null
      opers[i] = val

    # Only support Math methods with 4 operands
    switch opers.length
      when 1 then result = Math[op](opers[0])
      when 2 then result = Math[op](opers[0], opers[1])
    if isNaN result
      result = null
    return result

  tryMath: (statement) ->
      result = null
      re = new RegExp(@regExp)
      matches = re.exec(statement)
      if (!!matches)
        vals = matches[2].split(/\s+/)
        result = @callMathOp(matches[1], vals)
      return result
