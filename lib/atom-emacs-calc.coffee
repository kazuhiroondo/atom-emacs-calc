CalcTool = require './atom-emacs-calc-parser'
BasicMath = require './atom-emacs-calc-basic-math'
MathEval = require './atom-emacs-calc-math-eval'
BaseConv = require './atom-emacs-calc-base-conv'
MiscUtil = require './atom-emacs-calc-misc-util'
{CompositeDisposable} = require 'atom'

module.exports = AtomEmacsCalc =
  subscriptions: null
  calcTool: null

  activate: (state) ->
    @calcTool = new CalcTool(state.calcToolState)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'atom-emacs-calc:calc': => @calc()

    @calcTool.registerModule(new BasicMath)
    @calcTool.registerModule(new MathEval)
    @calcTool.registerModule(new BaseConv)
    @calcTool.registerModule(new MiscUtil)

  deactivate: ->
    @subscriptions.dispose()
    @calcTool.destroy()

  serialize: ->
    calcToolState: @calcTool.serialize()

  calc: ->
    editor = atom.workspace.getActiveTextEditor()
    cursor = editor.getLastCursor()
    tex = cursor.getCurrentBufferLine()
    pat = @calcTool.doCalc(tex)

    cursor.moveToEndOfLine()
    editor.insertNewline()

    if (pat)
      editor.insertText(pat)
    else
      editor.insertText("invalid expression")
