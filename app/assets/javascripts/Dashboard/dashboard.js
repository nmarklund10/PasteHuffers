// Adds a course the the tab container
function addCourseToCenterContainer(c, indexForLoadup=-1)
{
    // You can also POST data as necessary, see Dojo/Request docs to see how
    console.log("Grabbing Assignments for a course");
    sendGetRequestForJSON("/assignments/", {"id":c.id},
        function(courseAssignMentDict){
        // Recieve Course from service since this is asynchronusly run so the loop iterator may not be usable at the time this runs
        var innerDivId = "assignmentGridParentNodeFor_"+courseAssignMentDict.course.id;
        var innerContent ='<button data-dojo-type="dijit/form/Button" id="newAssignmentFor'+courseAssignMentDict.course.id+'" onclick="createNewAssignmentDialog();">Create new assignment</button><br />'+
                            '<div id="'+innerDivId+'" ></div>';
        
        window.centerContainer.addChild(new window.ContentPane({title:courseAssignMentDict.course.name,content:innerContent}));
        generateAssignmentsContainer(courseAssignMentDict.assignments, courseAssignMentDict.course.id, window.dom.byId(innerDivId));

        if(indexForLoadup != -1)
        {
            console.log("Finished course - "+ indexForLoadup+ "out of "+window.coursesCompleted.length);
            window.coursesCompleted[indexForLoadup] = true;
            placeTabContainer();
        }
    });    
}

/*
* The dashBoardSetup() will be called by dojo right after it is finished loading all libraries.
*/
function dashBoardSetup()
{
    window.assignmentStores = {};
    window.centerContainer = new window.TabContainer({style:"height:100%;"});
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

function placeTabContainer()
{
    // After sending out requests for each course, place and start up the accordion container 
    if(window.newCourseFormAdded && window.coursesCompleted.every(function(t){return t;}))
    {
        window.centerContainer.placeAt("centerContainer");
        window.centerContainer.startup();
        window.selectedCourse = null;
        // Add in out selection listeners
        centerContainer.watch("selectedChildWidget", function(name, oval, nval){
            for (var i in window.courses)
            {
                
                if (window.courses[i].name == nval.title)
                {
                    window.selectedCourse = window.courses[i];
                    console.log(window.courses[i]);
                    return;
                }
            }
            window.selectedCourse = null;
        });
    }
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
                addCourseToCenterContainer(response.course);
            }
            else
            {
                alert(response.reason);
            }
        });
}