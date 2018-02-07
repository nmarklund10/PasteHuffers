/* ********************************************************
*  Setup Code                                             *
***********************************************************/
/*dashBoardSetup is set as window.setup by dashboard.html
  it will query for the course creation form and all the courses and call addCourseToContainer and placeTabContainer
*/

/*
When called, will attempt to place the TabContainer for the dashboard
If the flag signifying that the tabContainer has already been placed is true then nothing happens
If any of the SYNC flags are false then nothing happens.
When placing the tab container, we add an event listener that keeps track of the currently selected tab and course with:
     and window.selectedTab
*/
function placeTabContainer()
{
    // Check SYNC flags
    if(window.newCourseFormAdded)
    {
        if (window.courses.length != 0)
        {
            if(window.coursesCompleted.every(function(t){return t}) == false)
            {
                return;
            }
        }
        // Check Placement flag
        if(window.alreadyPlaced)
        {
            return;
        }
        // Plce the tab container
        window.centerContainer.placeAt("centerContainer");
        window.centerContainer.startup();
        window.centerContainer.resize();

        // Add in out selection listeners
        centerContainer.watch("selectedChildWidget", function(name, oval, nval){
            for (var i in window.courses)
            {
                // Set the currently selected tab/course
                if (window.courses[i].name == nval.title)
                {
                    window.selectedCourse = window.courses[i];
                    window.selectedTab = window.tabs[window.courses[i].id];
                    generateAssignmentsContainer(window.selectedTab.assignments,window.courses[i].id);
                    return;
                }
            }
            window.selectedCourse = null;
            window.selectedTab = null;
            window.centerContainer.resize();
        });
    }
}

/*
Adds a tab for a given course c to the tab container
if given a non-negative indexForLoadup will set the SYNC flag with that index
Still queries the backend for the course to ensure that course exists in the DB
*/
function addCourseToCenterContainer(c, indexForLoadup=-1)
{
    sendGetRequestForJSON("/assignments/", {"id":c.id},
        function(courseAssignMentDict){
            // Create the inner html for the tab
            var innerDivId = "grid-"+courseAssignMentDict.course.id;
            var innerContent ='<button data-dojo-type="dijit/form/Button" id="newAssignButton'+courseAssignMentDict.course.id+'" onclick="createNewAssignmentDialog();">Create new assignment</button><button data-dojo-type="dijit/form/Button" style="color: red;" id="deleteCourse'+courseAssignMentDict.course.id+'" onclick="showDeleteCourseDialog();">Delete This Course</button><div id="'+innerDivId+'" ></div>';
            var contentPaneForTab = new window.ContentPane({title:courseAssignMentDict.course.name,
                                                            content:innerContent, 
                                                            id:"tab-"+courseAssignMentDict.course.id,
                                                            style:"width:auto; height:auto;"})
            window.centerContainer.addChild(contentPaneForTab);
            window.tabs[courseAssignMentDict.course.id].contentPane = contentPaneForTab;
            window.tabs[courseAssignMentDict.course.id].assignments = courseAssignMentDict.assignments;
            // Set the SYNC flag
            if(indexForLoadup > -1)
            {
                window.coursesCompleted[indexForLoadup] = true;
                placeTabContainer();
            }
    });    
}

/* ********************************************************
*  Setup Code                                             *
***********************************************************/
/*dashBoardSetup is set as window.setup by dashboard.html
  it will query for the course creation form and all the courses and call addCourseToContainer and placeTabContainer
*/
function setupAdmin(response)
{
    var htmlContent = '<div id="outerAdminDiv"><label for="newinstrWhiteListEmail">New Instructor Email:</label><input type="text" id="newInstrWhiteListEmail" name="name" required="true" data-dojo-type="dijit/form/TextBox"/><button data-dojo-type="dijit/form/Button" id="submitNewWhiteListButton" onclick="createNewWhiteListInstructor();">Add To Whitelist</button><br />';
    htmlContent += '<label for="deleteInstrWhiteListEmail">Delete Instructor:</label><select id="deleteInstrWhiteListSelect" data-dojo-type="dijit/form/Select">';
    for(var i in response)
    {
        htmlContent += '<option value="'+response[i].email+'">'+response[i].email+'</option>';
    }
    htmlContent += '</select><button data-dojo-type="dijit/form/Button" id="deleteInstrWhiteListEmailButton" onclick="deleteInstrFromWhiteList();">Delete Instructor</button><br /></div>';
    window.centerContainer.addChild(new window.ContentPane({title:"Admin/Tools", content:htmlContent, id:"admin/tools"}));
}
function createNewWhiteListInstructor()
{
    // Send request to update DB with new instr
    var email = window.dom.byId("newInstrWhiteListEmail").value;
    if(!validateEmail(email))
    {
        alert("Enter in a valid email!");
        return;
    }
    sendPostRequest('/whitelist/add',{'email': email},
    function(response)
    {
        console.log(response);
        console.log(email);
        // Update the select to include the instr
        if(response.success)
        {
            window.dijit.byId("deleteInstrWhiteListSelect").addOption({disabled:false, label:email, value:email});
            window.dijit.byId("deleteInstrWhiteListSelect").reset();
        }
        else
        {
            alert(response.reason);
        }
    });
}
/*The below function is from a SO post here https://stackoverflow.com/questions/46155/how-can-you-validate-an-email-address-in-javascript*/
function validateEmail(email) {
    var re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    return re.test(email);
}

function deleteInstrFromWhiteList()
{
    // Send request to delete instr from DB
    var email = window.dijit.byId("deleteInstrWhiteListSelect").value;
    if(email == "")
    {
        alert("No email selected for deletion");
        return;
    }
    sendPostRequest('/whitelist/delete',{'email': email},
    function(response)
    {
        console.log(response);
        console.log(email);
        // Update the select to not include the instr
        if(response.success)
        {
            window.dijit.byId("deleteInstrWhiteListSelect").removeOption(email);
            window.dijit.byId("deleteInstrWhiteListSelect")._setDisplay("");
            window.dijit.byId("deleteInstrWhiteListSelect").reset();
        }
        else
        {
            alert(response.reason);
        }
    });
}

function dashBoardSetup()
{
    // Create Tab Container and set up SYNC flags
    window.centerContainer = new window.TabContainer({style:"height:100%;", doLayout:false});
    window.newCourseFormAdded = false;
    window.startedCourses = false;
    window.alreadyPlaced = false;
    window.tabs = {};
    window.courses = [];
    // Set up create new course form first
    sendGetRequestForHTML('/courses/creationForm',{},
        function(response)
        {
            var cp = new window.ContentPane({title:"Create a New Course", content:response});
            window.centerContainer.addChild(cp);
            window.newCourseFormAdded = true;
            window.tabs["NewCourseTab"] = cp;
            placeTabContainer();
        });

    if(window.isAdmin)
    {
        sendGetRequestForJSON('/whitelist/',{},setupAdmin);
    }
    // GET the courses for the session, the add a new tab and SYNC flag for each, then place the tab container
    
    sendGetRequestForJSON("/courses/",{},
        function(courses){
            // Set Global objects
            window.courses = courses;
            
            // Set up SYNC flags
            for(var i in courses)
            {
                window.tabs[courses[i].id] = {course: courses[i]};
            }
            window.coursesCompleted = [];
            for (var i=0;i<courses.length; i++)
            {
                window.coursesCompleted.push(false);
                addCourseToCenterContainer(courses[i],i);
            }
            placeTabContainer();
        });
    window.dom.byId("instructorName").innerHTML = "Welcome, " + window.name + "!"
}
/*
When called, will attempt to place the TabContainer for the dashboard
If the flag signifying that the tabContainer has already been placed is true then nothing happens
If any of the SYNC flags are false then nothing happens.
When placing the tab container, we add an event listener that keeps track of the currently selected tab and course with:
     and window.selectedTab
*/
function placeTabContainer()
{
    // Check SYNC flags
    if(window.newCourseFormAdded)
    {
        if (window.courses.length != 0)
        {
            if(window.coursesCompleted.every(function(t){return t}) == false)
            {
                return;
            }
        }
        // Check Placement flag
        if(window.alreadyPlaced)
        {
            return;
        }
        // Plce the tab container
        window.centerContainer.placeAt("centerContainer");
        window.centerContainer.startup();
        window.centerContainer.resize();

        // Add in out selection listeners
        centerContainer.watch("selectedChildWidget", function(name, oval, nval){
            for (var i in window.courses)
            {
                // Set the currently selected tab/course
                if (window.courses[i].name == nval.title)
                {
                    window.selectedCourse = window.courses[i];
                    window.selectedTab = window.tabs[window.courses[i].id];
                    generateAssignmentsContainer(window.selectedTab.assignments,window.courses[i].id);
                    return;
                }
            }
            window.selectedCourse = null;
            window.selectedTab = null;
            window.centerContainer.resize();
        });
    }
}

/*
Adds a tab for a given course c to the tab container
if given a non-negative indexForLoadup will set the SYNC flag with that index
Still queries the backend for the course to ensure that course exists in the DB
*/
function addCourseToCenterContainer(c, indexForLoadup=-1)
{
    sendGetRequestForJSON("/assignments/", {"id":c.id},
        function(courseAssignMentDict){
            // Create the inner html for the tab
            var innerDivId = "grid-"+courseAssignMentDict.course.id;
            var innerContent ='<button data-dojo-type="dijit/form/Button" id="newAssignButton'+courseAssignMentDict.course.id+'" onclick="createNewAssignmentDialog();">Create new assignment</button><button data-dojo-type="dijit/form/Button" style="color: red;" id="deleteCourse'+courseAssignMentDict.course.id+'" onclick="showDeleteCourseDialog();">Delete This Course</button><div id="'+innerDivId+'" ></div>';
            var contentPaneForTab = new window.ContentPane({title:courseAssignMentDict.course.name,
                                                            content:innerContent, 
                                                            id:"tab-"+courseAssignMentDict.course.id,
                                                            style:"width:auto; height:auto;"})
            window.centerContainer.addChild(contentPaneForTab);
            window.tabs[courseAssignMentDict.course.id].contentPane = contentPaneForTab;
            window.tabs[courseAssignMentDict.course.id].assignments = courseAssignMentDict.assignments;
            // Set the SYNC flag
            if(indexForLoadup > -1)
            {
                window.coursesCompleted[indexForLoadup] = true;
                placeTabContainer();
            }
    });    
}

