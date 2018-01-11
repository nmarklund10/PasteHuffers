/* ********************************************************
*  Setup Code                                             *
***********************************************************/
/*
* The dashBoardSetup() will be called by dojo right after it is finished loading all libraries.
*/
function dashBoardSetup()
{
    console.log("STARTED SETUP");
    window.centerContainer = new window.TabContainer({style:"height:100%;", doLayout:false});
    window.newCourseFormAdded = false;
    window.startedCourses = false;
    // Set up create new course form first
    sendGetRequestForHTML('/courses/creationForm',{},
        function(response)
        {
            window.centerContainer.addChild(new window.ContentPane({title:"Create a New Course", content:response}));
            window.newCourseFormAdded = true;
        });

    console.log("Grabbing Courses");
    // Send a request to the courses resource with the IUID in session dict
    // Then pass in a call back for a succesful response and one for an error
    sendGetRequestForJSON("/courses/",{},
        function(courses){
            window.courses = courses;
            window.tabs = {};
            for(var i in courses)
            {
                window.tabs[courses[i].id] = {course: courses[i]};
            }
            window.coursesCompleted = [];
            // Iterate through each course object in the response
            for (var i=0;i<courses.length; i++)
            {
                window.coursesCompleted.push(false);
                // For each course, use its CUID to find all of the assignments
                addCourseToCenterContainer(courses[i],i);
            }
            
        });
}
// When called, checks to see if all tabs are loaded, if so it places the tab container
function placeTabContainer()
{
    // After sending out requests for each course, place and start up the accordion container 
    if(window.newCourseFormAdded && window.coursesCompleted.every(function(t){return t;}))
    {
        window.centerContainer.placeAt("centerContainer");
        window.centerContainer.startup();
        window.centerContainer.resize();
        window.selectedCourse = null;
        // Add in out selection listeners
        centerContainer.watch("selectedChildWidget", function(name, oval, nval){
            for (var i in window.courses)
            {
                
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

// Adds a course the the tab container
function addCourseToCenterContainer(c, indexForLoadup=-1)
{
    // You can also POST data as necessary, see Dojo/Request docs to see how
    console.log("Grabbing Assignments for a course");
    sendGetRequestForJSON("/assignments/", {"id":c.id},
        function(courseAssignMentDict){
        
            // Recieve Course from service since this is asynchronusly run so the loop iterator may not be usable at the time this runs
            var innerDivId = "grid-"+courseAssignMentDict.course.id;
            var innerContent ='<button data-dojo-type="dijit/form/Button" id="newAssignButton'+courseAssignMentDict.course.id+'" onclick="createNewAssignmentDialog();">Create new assignment</button><div id="'+innerDivId+'" ></div>';
            var contentPaneForTab = new window.ContentPane({title:courseAssignMentDict.course.name,
                                                            content:innerContent, 
                                                            id:"tab-"+courseAssignMentDict.course.id,
                                                            style:"width:auto; height:auto;"})
            window.centerContainer.addChild(contentPaneForTab);
            window.tabs[courseAssignMentDict.course.id].contentPane = contentPaneForTab;
            window.tabs[courseAssignMentDict.course.id].assignments = courseAssignMentDict.assignments;
            if(indexForLoadup != -1)
            {
                console.log("Finished course - "+ indexForLoadup+ "out of "+window.coursesCompleted.length);
                window.coursesCompleted[indexForLoadup] = true;
                placeTabContainer();
            }
    });    
}

function createCourseFromForm()
{
    //Construct the course name
    var courseName = ((window.dom.byId("courseSemesterForm").value!="") ? (window.dom.byId("courseSemesterForm").value+": "): "")+
                        window.dom.byId("courseNameForm").value + 
                        ((window.dom.byId("courseSectionForm").value != "") ? ("-"+window.dom.byId("courseSectionForm").value) : "");
    if(courseName == "")
    {
        alert("Course must have a name!");
        return;
    }
    //Send request to create the course
    sendPostRequest("/courses/create",{"name":courseName},
        function(response)
        {
            if(response.success)
            {
                window.tabs[response.course.id] = {course: response.course};
                window.courses.push(response.course)
                addCourseToCenterContainer(response.course);
                cleanClassForm();
                //switchToTabByCUID(response.course.id);
            }
            else
            {
                alert(response.reason);
            }
        });
}

function cleanClassForm()
{
    window.dom.byId("courseSemesterForm").value ="";
    window.dom.byId("courseNameForm").value = "";
    window.dom.byId("courseSectionForm").value = "";
}

function switchToTabByCUID(cuid)
{
    window.centerContainer.selectChild(window.tabs[cuid].contentPane);
}


/* ********************************************************
*  Assignment Specific Code for the Instructor dashboard  *
***********************************************************/
function generateAssignmentsContainer(assignments,cuid)
{
    if(typeof window.tabs[cuid].grid === 'undefined')
    {
        var data = {
            identifier: "id",
            items : assignments
        }
        var columns = [
            { "label":"AUID",     "field":"id", "width":"200px"},
            { "label":"Name",     "field":"name", "width":"200px"},
            { "label":"Language", "field":"language", "width":"200px"}
        ];
        var grid = new (window.declare([window.Grid, window.GridSelection]))({
            columns:columns,
            selectionMode: 'single',
            
        },"grid-" + cuid );
        grid.on(".dgrid-row:click",openAssignmentDashboard);
        window.tabs[cuid].grid = grid;
    }
    window.tabs[cuid].grid.refresh();
    
    window.tabs[cuid].grid.renderArray(assignments);
}
function openAssignmentDashboard(event)
{
    window.location = "/a_dash/"+window.selectedTab.grid.row(event).data.id;
}
function createNewAssignmentDialog()
{
    if(window.selectedCourse == null)
    {
        console.log("Selected Course is null");
        return;
    }
    if(typeof window.createInstructorFormDialog !== 'undefined')
    {
        createAssignmentFormDialog.show();
        window.dom.byId("newAssignmentName").value = "";
        return;
    }
    window.createAssignmentFormDialog = new window.DojoDialog({title:"Create New Assignment"});
    createAssignmentFormDialog.show();
    sendGetRequestForHTML("/assignments/creationForm", {}, function(response){
        createAssignmentFormDialog.set("content",response);
      });
}

function createNewAssignment()
{
    if(window.selectedCourse == null)
    {
        console.log("Selected course is null!");
        return;
    }
    var assignmentName = window.dom.byId("newAssignmentName").value;
    var assignmentLanguage = dijit.byId("newAssignmentLanguage").attr("value");
    if(assignmentName == "" || assignmentLanguage == "")
    {
        alert("Please supply a name and a language!");
        return;
    }
    sendPostRequest('/assignments/create',{"name": assignmentName, "language": assignmentLanguage, "CUID": window.selectedCourse.id},
        function(response)
        {
            // Will return a copy of the new assignment object
            if(response.success)
            {
                window.selectedTab.assignments.push(response.assignment);
                generateAssignmentsContainer(window.selectedTab.assignments,window.selectedTab.course.id);
                window.createAssignmentFormDialog.hide();
            }
            else
            {
                alert(response.reason);
            }
        });
}
