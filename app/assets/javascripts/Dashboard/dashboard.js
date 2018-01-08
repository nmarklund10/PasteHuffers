// Adds a course the the tab container
function addCourseToCenterContainer(c)
{
    // You can also POST data as necessary, see Dojo/Request docs to see how
    console.log("Grabbing Assignments for a course");
    sendGetRequestForJSON("/assignments/", {"id":c.id},
        function(courseAssignMentDict){
        // Recieve Course from service since this is asynchronusly run so the loop iterator may not be usable at the time this runs
        // Parse the response
        var innerContent = "<table>";
                
        // If given an empty list, still add the course as a title pane
        console.log("Appending child");
        if(courseAssignMentDict.assignments.length == 0)
        {
            window.centerContainer.addChild(new window.ContentPane({title:courseAssignMentDict.course.name, content:""}));
        }
        else
        {
            // For each assignment build its table row
            for(var a in assignments)
            {
                    innerContent+= "<tr><td>"+ a.name+"</td></tr>";
            }
            innerContent +="</table>";
            window.centerContainer.addChild(new window.ContentPane({title:window.courses[i].name,content:innerContent}));
        }
    });    
}

/*
* The setup() will be called by dojo right after it is finished loading all libraries.
*/
function setup()
{
    window.centerContainer = new window.TabContainer({style:"height:100%;"});
    
    // Set up create new course form first
    sendGetRequestForHTML('/courses/creationForm',{},
        function(response)
        {
            window.centerContainer.addChild(new window.ContentPane({title:"Create a New Course", content:response}));
        });

    console.log("Grabbing Courses");
    // Send a request to the courses resource with the IUID in session dict
    // Then pass in a call back for a succesful response and one for an error
    sendGetRequestForJSON("/courses/",{},
        function(courses){
            window.courses = courses;
            
            // Iterate through each course object in the response
            for (var i=0;i<courses.length; i++)
            {
                // For each course, use its CUID to find all of the assignments
                addCourseToCenterContainer(courses[i]);
            }
            // After sending out requests for each course, place and start up the accordion container
            window.centerContainer.placeAt("centerContainer");
            window.centerContainer.startup();
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
                addCourseToCenterContainer(response.course);
            }
            else
            {
                alert(response.reason);
            }
        });
}