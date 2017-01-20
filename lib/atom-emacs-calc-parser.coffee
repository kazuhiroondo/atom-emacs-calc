module.exports =
class CalcTool
  expStack : []
  mathModules : []

  constructor: (serializedState) ->

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->

  registerModule: (myModule) ->
    @mathModules.push(myModule)

  evalInner: (text) ->
    for mod in @mathModules
      result = mod.tryMath(text)
      if result != null
        return result
    return null

  evalOne: (text) ->
    pattern = /\(\s*(.*?)\s*\)/
    matches = pattern.exec(text)
    if (!!matches)
      exp = matches[0]
      exp_in = matches[1]
      return @evalInner(exp_in)
    else
      return null

  addSpacing: (text) ->
    pattern = /\)\(/g
    text = text.replace(pattern, ") (")
    pattern = /(\S)\(/g
    matches = pattern.exec(text)
    if (!!matches)
      text = text.replace(pattern, matches[1] + " (")
    return text

  doCalc: (text) ->
    text = @addSpacing(text)

    depth = 0
    current = ""
    for i in [0 .. (text.length - 1)]
      mychar = text.charAt(i)

      if mychar == '('
        ++depth
        @expStack.push current
        current = mychar
      else if mychar == ')'
        if depth == 0
          return "Extraneous )"
        current += mychar
        if (current.length > 0)
            result = @evalOne(current)
            if (result == null)
              return "Invalid expression: " + current
            current = @expStack.pop()
            current += result
        --depth
      else
        current += mychar

    if depth != 0
      return "Expression not complete : extraneous ("

    return current.toString()
