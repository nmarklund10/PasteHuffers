function assignmentDashBoardSetup()
{
    // Get data for the grid
    sendGetRequestForJSON('/submissions/',{'id':window.assignmentId},
        function (response) 
        {
            if(response.success)
            {
                window.submissions = response.submissions;
                generateSubmissionsGrid();
            }
            else
            {
                console.log(response.reason);
                alert(response.reason);
            }
        });
}

function generateSubmissionsGrid()
{
    console.log(window.submissionGridRef);
    if(typeof window.submissionGridRef === 'undefined')
    {
        var columns =[
            {field: "id", label: "id"},
            {field: "student_id", label: "Student"},
            {field: "created_at", label: "Submitted"},
            {field: "paste_detected", label: "Paste Detected"}
        ];
        window.submissionGridRef = new (window.declare([window.Grid, window.GridSelection]))({
            columns:columns,
            selectionMode: 'single',
        },"submissionGrid");
        window.submissionGridRef.on(".dgrid-row:click",openSubmissionDialog);
        //Color rows based on paste detection
        aspect.after(window.submissionGridRef, 'renderRow', function(row, args) {
            // Add classes to `row` based on `args[0]` here
            if(args[0].paste_detected)
            {
                console.log("Adding class to row");
                domClass.add(row, "rowWithPasteDetected");
            }
            return row;
          });
    }
    window.submissionGridRef.refresh();
    window.submissionGridRef.renderArray(window.submissions);
}
function openSubmissionDialog(event)
{
    alert("Opened dialog for "+window.submissionGridRef.row(event));
}

function showDeleteAssignmentDialog()
{
    // Create confirmation dialog
    if(typeof window.deleteAssignmentDialog !== 'undefined')
    {
        window.deleteAssignmentDialog.show();
        return;
    }
    window.deleteAssignmentDialog = new window.DojoDialog({title:"Delete Assignment",
                                                               content: 'Are you sure you want to delete this assignment?<br/><button data-dojo-type="dijit/form/Button" id="deleteCourseYesButton" onclick="deleteAssignment();">Yes</button><button data-dojo-type="dijit/form/Button" id="deleteCourseNoButton" onclick="window.deleteAssignmentDialog.hide();">No</button>'});
    window.deleteAssignmentDialog.show();
}

function deleteAssignment()
{
    sendPostRequest("/assignments/delete",{id:window.assignmentId},
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
