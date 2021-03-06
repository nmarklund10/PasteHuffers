/* ********************************************************
*  Course Dashboard Code                                  *
***********************************************************/

// Sends a POST request to create a new course with the data from the new course form
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
                cleanNewCourseForm();
            }
            else
            {
                alert(response.reason);
            }
        });
}

// Cleans the new course form of any old data
function cleanNewCourseForm()
{
    window.dom.byId("courseSemesterForm").value ="";
    window.dom.byId("courseNameForm").value = "";
    window.dom.byId("courseSectionForm").value = "";
}

function switchToTabByCUID(cuid)
{
    window.centerContainer.selectChild(window.tabs[cuid].contentPane);
    window.selectedTab = window.tabs[cuid];
    window.selectedCourse = window.tabs[cuid].course;
}

function switchToNewCourseTab()
{
    window.centerContainer.selectChild(window.tabs["NewCourseTab"]);
    window.selectedCourse = null;
    window.selectedTab = null;
}
function showDeleteCourseDialog()
{
    // Create confirmation dialog
    if(typeof window.deleteCourseDialog !== 'undefined')
    {
        window.deleteCourseDialog.show();
        return;
    }
    window.deleteCourseDialog = new window.DojoDialog({title:"Delete Selected Course",
                                                               content: 'Are you sure you want to delete this course?<br/><button data-dojo-type="dijit/form/Button" id="deleteCourseYesButton" onclick="deleteSelectedCourse();window.deleteCourseDialog.hide();">Yes</button><button data-dojo-type="dijit/form/Button" id="deleteCourseNoButton" onclick="window.deleteCourseDialog.hide();">No</button>'});
    window.deleteCourseDialog.show();
}
function deleteSelectedCourse()
{
    sendPostRequest("/courses/delete",{id:window.selectedCourse.id},
        function(response)
        {
            if(response.success)
            {
                window.centerContainer.removeChild(window.selectedTab.contentPane);
                switchToNewCourseTab();
            }
            else
            {
                alert(response.reason);
            }
        });
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
            { "label":"Language", "field":"language", "width":"200px"},
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
    if(typeof window.createAssignmentFormDialog !== 'undefined')
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
                if (dijit.byId("uploadedFile").getFileList().length == 1)
                    dijit.byId("uploadedFile").upload();
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
