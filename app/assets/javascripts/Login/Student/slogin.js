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
            sendGetRequestForHTML("assignmentID/", {}, function(response){
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
  sendPostRequest("verifyCreds/", {"access":accessId}, 
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

/*function sendAccessRequest()
{
    // Grab user info from the forms
    var username = window.dom.byId("username").value;
    var accessId = window.dom.byId("access").value;
    console.log("Sending Request")
    // Send POST request for login
    // A succesful response will end in redirect, any other response will provide information about error
    sendPostRequest("/SLogin/", {"access":accessId, "username":username}, 
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
}*/