function sendAccessRequest()
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
}