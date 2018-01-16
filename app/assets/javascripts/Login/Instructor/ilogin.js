// Sends POST request 
function sendLoginRequest()
{
    // Grab user info from the forms
    var username = window.dom.byId("username").value;
    var password = window.dom.byId("password").value;
    console.log("Sending Request")
    // Send POST request for login
    // A succesful response will end in redirect, any other response will provide information about error
    sendPostRequest("/ILogin/", {"username":username, "password":password}, 
      function(response)
      {
        if(response.success)
        {
          window.location = "/dash/";
        }
        else
        {
          alert(response.reason);
        }
      });
}
function openStudentLogin(){
    window.location = "/s_login/";
}

// Gets the html for the create instructor form
function openCreateInstructorForm()
{
    if(typeof window.createInstructorFormDialog !== 'undefined')
    {
        window.createInstructorFormDialog.show();
        return;
    }
    window.createInstructorFormDialog = new window.DojoDialog({title:"Register New Account!"});
    createInstructorFormDialog.show();
    sendGetRequestForHTML("/instructors/creationForm", {}, function(response){
        createInstructorFormDialog.set("content",response);
      });
  }

// Sends a POST request to create a new instructor 
function submitInstructor()
{
    // Grab all the data from the form
    var instrName = window.dom.byId("instrName").value.trim();
    var instrEmail = window.dom.byId("instrEmail").value.trim();
    var instrPassword = window.dom.byId("instrPassword").value.trim();
    var valInstrPassword = window.dom.byId("password_validate").value.trim();
    if (instrName.length < 1) 
    {
        alert("Please type in Instructor Name!");
        return;        
    }
    if (instrEmail.length < 1) 
    {
        alert("Please type in email!");
        return;        
    }
    if (instrEmail[instrEmail.length - 4] != '.') 
    {
        alert("Invalid email!");
        return;
    }
    if (instrPassword.length < 6) 
    {
        alert("Password must be at least 6 characters!");
        return;
    }
    if(instrPassword != valInstrPassword)
    {
        alert("Password and validation do not match!!");
        return;
    }
    // Send Creation POST to BE
    sendPostRequest("/instructors/create", {"name":instrName, "password":instrPassword, "email":instrEmail},
        function(response)
        {
            if(response.success)
            {
                // Log in with new instructor data
                sendPostRequest("/ILogin/", {"username":instrName, "password":instrPassword},
                    function(response)
                    {
                        if(response.success)
                        {
                            window.createInstructorFormDialog.hide();
                            window.location = "/dash/";
                        }
                        else
                        {
                            alert(response.reason);
                        }
                    });
            }
            else
            {
                alert(response.reason);
            }
        });
}