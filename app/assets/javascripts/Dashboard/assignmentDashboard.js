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
    if(typeof window.downloadSubmissionDialog !== 'undefined')
    {
        window.downloadSubmissionDialog.set("title",window.submissionGridRef.row(event).data.student_id);
        window.downloadSubmissionDialog.show();
        window.downloadSubmissionDialog.rowClickedOn = window.submissionGridRef.row(event);
        return;
    }
    window.downloadSubmissionDialog = new window.DojoDialog({title:window.submissionGridRef.row(event).data.student_id});
    window.downloadSubmissionDialog.rowClickedOn = window.submissionGridRef.row(event);
    window.downloadSubmissionDialog.show();
    window.downloadSubmissionDialog.set("content", '<button data-dojo-type="dijit/form/Button" id="downloadLogButton" onclick="downloadLog(window.downloadSubmissionDialog.rowClickedOn);">Download Log</button><button data-dojo-type="dijit/form/Button" id="downloadSubmissionButton" onclick="downloadSubmission(window.downloadSubmissionDialog.rowClickedOn);">Download Submission</button>')
}

function downloadLog(row)
{
    console.log("Attempting to download log for "+row.data.student_id);
    var dfd = window.IFrame.send({
        url:"/submissions/downloadLog",
        method:"GET",
        content:{
        "submissionId": row.data.id
        }
        });
    dfd.cancel();
}
function downloadSubmission(row)
{
    console.log("Attempting to download submission for "+row.data.student_id);
    var dfd = window.IFrame.send({
        url:"/submissions/downloadSubmission",
        method:"GET",
        content:{
        "submissionId": row.data.id
        }
        });
    dfd.cancel();
}
function downloadAllSubmissions()
{
    var dfd = window.IFrame.send({
        url:"/submissions/downloadAll",
        method:"GET",
        content:{
        "AUID": window.assignmentId
        }
        });
    dfd.cancel();
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
