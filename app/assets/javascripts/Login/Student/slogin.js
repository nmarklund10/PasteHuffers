function studentLoginSetup() {
    gapi.auth2.getAuthInstance().attachClickHandler(window.dom.byId("googleButton"), {}, onSignIn, null);
}

function onSignIn(googleUser) {
  var id_token = googleUser.getAuthResponse().id_token;
  sendPostRequest("/SLogin",{"id_token":id_token},
    function(response)
    {
        if(response.success)
        {
            // Create confirmation dialog
            if(typeof window.getAssignmentIDDialog !== 'undefined')
            {
                window.getAssignmentIDDialog.show();
                return;
            }
            window.getAssignmentIDDialog = new window.DojoDialog({title:"Welcome, " + response.name});
            window.getAssignmentIDDialog.show();
            sendGetRequestForHTML("/s_login/assignmentID/", {}, function(response){
              getAssignmentIDDialog.set("content",response);
            });
        }
        else
        {
            alert(response.reason);
        }
    });
}

function getAssignmentID() {
  accessId = dijit.byId("assignmentID").value;
  sendPostRequest("/s_login/verifyCreds/", {"access":accessId}, 
      function(response)
      {
        if(response.success)
        {
          window.location = "/codeEdit/";
        }
        else
        {
          alert(response.reason);
        }
      });
}