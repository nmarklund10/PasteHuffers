function codeEditorSetup()
{
  dijit.byId("editor").onLoadDeferred.then(function (){
    window.detector = Object.freeze(new CopyPasteDetector());
  });
}

class Edit {
  constructor(text, cp) {
    var _time = new Date();
    var _text = text;
    var _copyPaste = cp;
    //Column and line start from 0
    var _column = dijit.byId("editor").selection.getBookmark().mark.startOffset;
    var _line = dijit.byId("editor").editNode.innerHTML.split("<div>").length - 1;
    this.getTime = function() { return _time; }
    this.getText = function() { return _text; }
    this.copyPaste = function() { return _copyPaste; }
    this.getColumn = function() { return _column; }
    this.getLine = function() { return _line; }
  }
}

class CopyPasteDetector {
  constructor() {
    var editLog = [];    

    var getKey = function(event) {
      editLog.push(new Edit(event.key, false));
    }
    var logTextPaste = function(event) {
      var pastedText = "";
      if (typeof event.clipboardData === 'undefined')
        pastedText = window.clipboardData.getData('Text');
      else
        pastedText = event.clipboardData.getData('text/plain');
      editLog.push(new Edit(pastedText, true));
    }
    this.getLog = function() { return editLog; }
    this.makeLog = function() {
      var _lastStamp = undefined;
      var _lastEdit = undefined;
      var _logText = "";
      var cpdetected = false;
      for (var i = 0; i < editLog.length; i++) {
        var text = editLog[i].getText();
        var curTime = editLog[i].getTime();
        var timeString = "";
        var cp = editLog[i].copyPaste();
        if (cp) {
          if (i != 0) {
            _logText += "\n\n"
          }
          _logText += "**********COPY PASTE**********\n" + curTime.toString() + "\n" + text + "\n******************************\n";
          cpdetected = true;
        }
        else {
          if (_lastStamp == undefined) {
            _lastStamp = curTime;
            if (i != 0)
              timeString += "\n";
            timeString += _lastStamp.toString() + "\n";
          }
          else {
            var tsSecondsElapsed = (curTime - _lastStamp) / 1000;
            var editSecondsElapsed = (curTime - _lastEdit) / 1000;
          //If it has been 15 minutes or more since first time stamp, make a new one
            if (tsSecondsElapsed >= 900) {
              _lastStamp = curTime;
              timeString = "\n" + _lastStamp.toString() + "\n";
            }
            //Make relative timestamp if last edit was not made less than 15 seconds ago or copy paste was detected
            else if (editSecondsElapsed > 15 || cpdetected) {
              timeString = "\nH+" + tsSecondsElapsed + "\n";
            }
          }
          cpdetected = false;    
          _logText += timeString + text;
        }        
        _lastEdit = curTime;
      }
      return _logText;
    }

    this.getCode = function() {
      return dijit.byId("editor").editNode.innerText;
    }

    dijit.byId("editor").editNode.onkeydown = getKey;
    dijit.byId("editor").editNode.onpaste = logTextPaste;
  }
}

