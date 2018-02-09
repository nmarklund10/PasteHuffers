function hideElementById(id) {
  document.getElementById(id).style.visibility = 'hidden';
}

function setLanguage(lang) {
  if (lang == "Python")
      window.editor.session.setMode("ace/mode/python");
  else if (lang == "Ruby")
      window.editor.session.setMode("ace/mode/ruby");
  else if (lang == "Java")
      window.editor.session.setMode("ace/mode/java");
  else if (lang == "C++" || lang == "C")
      window.editor.session.setMode("ace/mode/c_cpp");
  else {
      hideElementById("outputPane");
      hideElementById("testButton");
      document.getElementById("editor").style.width = '100%';
      window.editor.setOptions({
        fontFamily: "Lucida Console",
        fontSize: "15px"
      });
  }
}

function backToDash() {
  window.location = '/a_dash/' + window.auid;
}

function codeEditorSetup() {
  window.editor = ace.edit("editor");
  window.editor.setTheme("ace/theme/monokai");
  window.editor.setShowPrintMargin(false);
  window.editor.$blockScrolling = Infinity;
  document.getElementById('editor').style.fontSize='16px';
  sendGetRequestForJSON('/assignments/getSkeletonCode', {}, 
    function(response) {
      if (response.success) {
        setLanguage(response.language);
        if (response.skeletonCode != null)
          window.editor.setValue(response.skeletonCode);
      }
      else {
        setLanguage("");
        alert(response.reason);
      }
      window.detector = Object.freeze(new CopyPasteDetector());
    });
  if (window.demo) {
    document.getElementById('submitButton').innerText = 'Show Log';
    document.getElementById('submitButton').onclick = getLog;
    document.getElementById('label').innerText = "";
  }
  else {
    hideElementById("backButton");
  }
}

function getLog() {
  var log = window.detector.makeLog();
  document.getElementById("output").innerText = "Log:\n\n" + log;
  // var element = document.createElement('a');
  // element.setAttribute('href', 'data:text/plain;charset=utf-8,' + encodeURIComponent(log));
  // element.setAttribute('download', "assignment" + window.auid + "TestLog.txt");
  // element.style.display = 'none';
  // document.body.appendChild(element);
  // element.click();
  // document.body.removeChild(element);
}

class Edit {
  constructor(text, cp) {
    var _time = new Date();
    var _text = text;
    var _copyPaste = cp;
    //Column and line start from 0
    var _position = window.editor.getCursorPosition();
    this.getTime = function() { return _time; }
    this.getText = function() { return _text; }
    this.copyPaste = function() { return _copyPaste; }
    this.getPosition = function() { return _position; }
  }
}

function sendSubmission() {
  confirm("Are you sure?  You will be unable to access your work after pressing OK.");
  submission = window.editor.getValue();
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
    var pasteEvent = false;

    var getKey = function(event) {
      //Only log non-copy paste events
      if (pasteEvent) {
        pasteEvent = false;
        return;
      }
      var text;
      if (event.action == "remove")
        text = "Backspace";
      else if (event.lines.length == 2)
        text = "Enter";
      else
        text = event.lines[0];
      editLog.push(new Edit(text, false));
    }
    var logTextPaste = function(event) {
      pasteEvent = true;
      var pastedText = event.text;
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
    window.editor.on('change', getKey);
    window.editor.on('paste', logTextPaste);
    //window.editor.textInput.getElement().addEventListener('paste', logTextPaste);
  }
}
function testCode()
{
    submission = window.editor.getValue();
    document.getElementById("output").innerText = "Compiling...";
    document.getElementById("testButton").disabled = true;
    sendPostRequest('/codeEdit/test', {"code":submission}, 
      function(response)
      {
        document.getElementById("testButton").disabled = false;
        if(response.success)
        {
          document.getElementById("output").innerText = response.output;
        }
        else
        {
          document.getElementById("output").innerText = "";
          alert(response.reason);
        }
      });
}
