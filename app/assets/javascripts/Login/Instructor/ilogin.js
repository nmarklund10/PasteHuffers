function instructorLoginSetup() {
    gapi.auth2.getAuthInstance().attachClickHandler(window.dom.byId("googleButton"), {}, sendLoginRequest, null);
}

// Sends POST request 
function sendLoginRequest(googleUser)
{
    var authResult = googleUser.getAuthResponse();
    var id_token = authResult.id_token;
    sendPostRequest("/ILogin/",{"id_token":id_token},
    function(response)
    {
        if (response.create) {
            if (confirm("There are no accounts associated with the email: " + response.email + "  Pressing OK will create a new one.")) {
                sendPostRequest("instructors/create", {"name":response.name, "email":response.email},
                    function(r)
                    {
                        if (r.success) {
                            window.name = response.name;
                            window.location = "/dash/";
                        }
                        else {
                            alert(r.reason);
                        }
                    });
            }
        }
        else if(response.success)
        {
            window.name = response.name;
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