module.exports =
class CalcModuleBase
  bExp : null

  constructor: ->
    props = Object.getOwnPropertyNames(Math)
    nums= props.filter(@numFilter)
    @bExp = "^("
    @bExp += nums.join('|')
    @bExp += ")$"

  numFilter: (p) ->
    return typeof(Math[p]) == 'number'

  toNumber: (val) ->
    re = new RegExp(@bExp)
    matches = re.exec(val.toUpperCase())
    if !!matches
      val = Math[matches[1]]
    else
      val = Number(val)

    return val
