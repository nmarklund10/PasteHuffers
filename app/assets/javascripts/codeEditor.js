function codeEditorSetup()
{
  window.editor = ace.edit("editor");
  window.editor.setTheme("ace/theme/monokai");
  window.editor.session.setMode("ace/mode/python");
  window.editor.setShowPrintMargin(false);
  window.editor.$blockScrolling = Infinity;
  document.getElementById('editor').style.fontSize='15px';
  window.detector = Object.freeze(new CopyPasteDetector());
  sendGetRequestForJSON('/assignments/getSkeletonCode', {}, 
    function(response) {
      if (response.success) {
        console.log(response.skeletonCode);
        window.editor.setValue(response.skeletonCode);
      }
      else {
        alert(response.reason);
      }
    });
}

class Edit {
  constructor(text, cp) {
    var _time = new Date();
    var _text = text;
    var _copyPaste = cp;
    //Column and line start from 0
    //var _column = dijit.byId("editor").selection.getBookmark().mark.startOffset;
    //var _line = dijit.byId("editor").editNode.innerHTML.split("<div>").length - 1;
    this.getTime = function() { return _time; }
    this.getText = function() { return _text; }
    this.copyPaste = function() { return _copyPaste; }
    this.getColumn = function() { return _column; }
    this.getLine = function() { return _line; }
  }
}

function sendSubmission() {
  confirm("Are you sure?  You will be unable to access your work after pressing OK.");
  submission = dijit.byId("editor").editNode.innerText;
  log = window.detector.makeLog();
  sendPostRequest('/submissions/submit', {"submission":submission, "log": log, "cp":window.detector.getCP()}, 
    function(response) {
      if(response.success)
        {
          window.location = '/s_login/';
        }
        else
        {
          alert(response.reason);
        }
    });
}

class CopyPasteDetector {
  constructor() {
    var editLog = [];
    var copyPaste = false;    

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
    var logCopyPaste = function() { copyPaste = true; }
    this.getCP = function() { return copyPaste; }
    this.getLog = function() { return editLog; }
    this.makeLog = function() {
      var _lastStamp = undefined;
      var _logText = "";
      var cpdetected = false;
      for (var i = 0; i < editLog.length; i++) {
        var text = editLog[i].getText();
        var curTime = editLog[i].getTime();
        var timeString = "";
        var cp = editLog[i].copyPaste();
        if (i == 0) {
          _lastStamp = curTime;
          if (cp)
            timeString += "\n";
          timeString += _lastStamp.toString() + "\n";
        }
        else {
          var tsSecondsElapsed = (curTime - _lastStamp) / 1000;
        //If it has been 15 minutes or more since first time stamp, make a new one
          if (tsSecondsElapsed >= 900) {
            _lastStamp = curTime;
            timeString = "\n" + _lastStamp.toString() + "\n";
          }
          //Make relative timestamp if last edit was not made less than 10 seconds ago or copy paste was detected
          else {
            timeString = "\n--H+" + tsSecondsElapsed + "--\n";
          }
        }
        if (cp) {
          if (i != 0) {
            _logText += "\n"
          }
          _logText += "**********COPY PASTE**********" + timeString + text + "\n******************************";
          cpdetected = true;
          logCopyPaste();
          continue;
        }
        _logText += timeString + text;
      }
      _logText += "\n";        
      return _logText;
    }
    window.editor.textInput.getElement().addEventListener('keydown', getKey);
    window.editor.textInput.getElement().addEventListener('paste', logTextPaste);
  }
}
function testCode()
{
    submission = dijit.byId("editor").editNode.innerText;
    sendPostRequest('/codeEdit/test', {"code":submission}, 
      function(response)
      {
        if(response.success)
        {
          dom.byId("tempOutputArea").innerText = response.output;
        }
        else
        {
          alert(response.reason);
        }
      });
}
