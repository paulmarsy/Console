
# vtlf-tail

fs  = require 'fs-plus'
{$} = require 'atom'

module.exports =
class Tail
  
  constructor: (@fileView, @state, vtlfLibPath) ->
    @Viewer = require vtlfLibPath + 'viewer'
    @filePath = @fileView.filePath
    
    @watcher = (event, filename) => 
      if @isDestroyed then return
      if not @fileIsOpen then setTimeout @watcher, 100; return
      @fileView.reader.buildIndex null, (res) => 
        switch res
          when 'ok' then @fileView.haveNewLines()
          when 'reload' then atom.workspace.activePane.activateItem new @Viewer @filePath
      
    fs.watch @filePath, persistent: no, @watcher

    @fileView.onDidOpenFile    => @didOpenFile()
    @fileView.onDidGetNewLines => @didGetNewLines()
    @fileView.onDidScroll      => @didScroll()
    
  didOpenFile: -> 
    @tailing = @fileIsOpen = yes
    @fileView.setScroll @fileView.lineCount
  	 
  didGetNewLines: -> 
    if @tailing then @fileView.setScroll @fileView.lineCount
    
  didScroll: ->
    @tailing = (@fileView.botLineNum is @fileView.lineCount-1)
    $lineNums = @fileView.find '.line-num'
    $lineNums.removeClass 'tail-hilite'
    # console.log 'didScroll', @tailing, $lineNums.length, @fileView.botLineNum, @fileView.lineCount
    if @tailing 
      botLineNum = @fileView.botLineNum
      $lineNum = $lineNums.last()
      lineNum  = +$lineNum.parent().attr 'data-line'
      if +$lineNum.attr('data-line') isnt botLineNum
        $lineNums.each ->
          $lineNum = $ @
          lineNum  = +$lineNum.parent().attr 'data-line'
          if lineNum is botLineNum then return false
      $lineNum.addClass 'tail-hilite'
    
  destroy: -> 
    @isDestroyed = yes
    atom.workspaceView.find('.item-views .sticky-bar').remove()
    fs.unwatchFile @fileView.filePath, @watcher
    
    