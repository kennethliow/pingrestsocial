<%@page import="models.Group"%>
<%@page import="controllers.UserController"%>
<%@page import="models.User"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashMap"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="org.json.simple.JSONValue"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="java.io.*" %>
<%@page import="java.net.*" %>

<html>

<% session.setAttribute("location", "groups");%>

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>My Groups</title>
    <link href="assets/css/bootstrap.min.css" rel="stylesheet">
    <!-- Custom styles for this template -->
    <link href="assets/css/hashed.css" rel="stylesheet">
    <link href="assets/css/tag-basic-style.css" rel="stylesheet">


    <!-- check this -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
    <script src="assets/js/bootstrap.min.js"></script>
    <script id="twitter-wjs" src="//platform.twitter.com/widgets.js"></script>
    <script src="//www.parsecdn.com/js/parse-1.3.0.min.js"></script>
    <script src="assets/js/jquery1.8.2.js"></script>

    <script src="assets/js/tagging.min.js"></script>

</head>

<body>

    <!--HTML PAGE FOR Design of the group page-->
    <div class="container-fluid">
        <div class="row">

            <%@include file="sidebar.jsp"%> 
            <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
                <h1 class="page-header">#My Groups</h1>

                <% if (session.getAttribute("success") != null) {%>
                <div class="alert alert-success">  
                    <a class="close" data-dismiss="alert">×</a>  
                    <strong><%=session.getAttribute("success")%></strong>  
                </div> 
                <% session.removeAttribute("success");}%>

                <% if (session.getAttribute("error") != null) {%>
                <div class="alert alert-danger">  
                    <a class="close" data-dismiss="alert">×</a>  
                    <strong><%=session.getAttribute("error")%></strong>  
                </div> 
                <% session.removeAttribute("error");}%>
                
                <% if (session.getAttribute("warning") != null) {%>
                <div class="alert alert-warning">  
                    <a class="close" data-dismiss="alert">×</a>  
                    <strong><%=session.getAttribute("warning")%></strong>  
                </div> 
                <% session.removeAttribute("warning");}%>

        <div class="col-sm-8 col-sm-offset-2 center-text">
            <div id="welcomeslide">
                <h1>Group em' up!</h1>
                <p>You can <a href="#" class="addGroup">create groups</a> for tagging and sharing your albums!</p>
            </div>
        </div>

        <div class="row col-md-10 col-md-offset-1">
            <table class="table table-striped group-table" id="groupTable">
                <thead>
                    <tr>
                        <th>Groups</th>
                        <th>Participants</th>
                        <th><button class="btn btn-pink addGroup pull-right">Add new group</button></th>
                    </tr>
                </thead>

                <!--Updating the list of users here-->
                <% HashMap<String, Group> pList = (HashMap< String, Group>) UserController.getGroupMap();
                String display = ""; %>

                <% if(pList.isEmpty()){ %>
                <tr>
                    <td colspan="3" class="center-text">You have no groups.</td>
                </tr>
                <% } %>

                <%
                for (Map.Entry<String, Group> entry : pList.entrySet()) {
                String key = entry.getKey();

                ArrayList<User> value = entry.getValue().getMembers();
                ArrayList<String> emails = entry.getValue().getEmails();

                for (int a = 0; a < value.size(); a++) {
                User member = value.get(a);
                
                if(!display.equals(""))
                display += ", ";
                display += member.getUsername();
              
            }

            for(String email : emails){
            if(!display.equals("") && email!=null)
            display += ", ";
            display+=email;
        }

        %>

        <tr>
            <td><%=key%></td>
            <td><%=display%></td>
            <td class="text-right" style="width:20%;">

                <button class='btn btn-info editGroup' data-id="<%= key%>" data-friends="<%= display%>">
                    <span class="glyphicon glyphicon-edit"></span> Edit
                </button> 

                <button class="btn btn-danger deleteGroup" data-id="<%= key%>">
                    <span class="glyphicon glyphicon-remove"></span> Del
                </button>

            </td>

        </tr>
        <% display = ""; %>
        <% } %>
    </table>

</div>
</div>
</div>
</div>



<!-- Modals -->
<div class="modal fade" id="addNewGroupModal" tabindex="-1" role="dialog" aria-labelledby="addNewGroupModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
                <h2 class="modal-title" id="myModalLabel">Create a new group</h4>
                </div>
                <form id="addGroupForm" class="form-horizontal" action="AddGroupServlet">
                    <div class="modal-body">

                        <div class="form-group">
                            <label for="groupName" class="col-sm-3 control-label">Group Name</label>
                            <div class="col-sm-9">
                                <input type="text" class="form-control" id="groupName" name="groupName" autocomplete="off"  required placeholder="Enter a name for your new album"/>
                                <input type="hidden" name="processedGroupMembers" id="processedGroupMembers" />
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="groupMembers" class="col-sm-3 control-label">Group Members</label>
                            <div class="col-sm-9">
                                <div data-tags-input-name="tag" class="form-control" id="groupMembers"
                                data-toggle="tooltip" data-placement="bottom" title="You can enter multiple friends' username or email by seperating them with commas"></div>
                            </div>

                        </div>

                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                        <button type="button" class="btn btn-pink" onclick="addGroup();">Create Group</button>
                    </div>
                </form>
            </div>
        </div>
    </div>


    <div class="modal fade" id="editGroupModal" tabindex="-1" role="dialog" aria-labelledby="editGroupModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
                    <h2 class="modal-title" id="editGroupModalLabel">Modify Group</h4>
                    </div>
                    <form id="editGroupForm" class="form-horizontal" action="UpdateGroupServlet">
                        <div class="modal-body">

                            <div class="form-group">
                                <label for="groupName" class="col-sm-3 control-label">Group Name</label>
                                <div class="col-sm-9">
                                    <input type="hidden" id="oldGroupName" name="oldGroupName" />
                                    <input type="text" class="form-control" id="newGroupName" name="newGroupName" autocomplete="off"  required placeholder="Enter a new name for your album"/>
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="editGroupMembers" class="col-sm-3 control-label">Group Members</label>
                                <div class="col-sm-9">
                                    <div data-tags-input-name="tag" class="form-control" id="editGroupMembers"></div>

                                    <input type="hidden" name="groupMembers" id="newGroupMembers" />
                                </div>

                            </div>

                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                            <button type="button" class="btn btn-pink" onclick="editGroup();">Edit Group</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>



        <div class="modal fade" id="deleteGroupModal" tabindex="-1" role="dialog" aria-labelledby="deleteGroupModallLabel" aria-hidden="true">
            <div class="modal-dialog modal-alert">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
                        <h2 class="modal-title" id="deleteGroupModallLabel">Delete Group</h4>
                        </div>
                        <form id="deleteGroupForm" class="form-horizontal" action="DeleteGroupServlet">
                            <div class="modal-body">
                                <h4>Are you sure you want to delete this group?</h4>
                                <input type="hidden" id="deleteGroupName" name="groupName" />
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                                <input type="submit" class="btn btn-pink" value="Delete Group"/>
                            </div>
                        </form>
                    </div>
                </div>
            </div>


            <script type="text/javascript">
            var foo = {};
            foo.jQuery = jQuery.noConflict(true);

            foo.jQuery(document).ready(function() {

                var my_custom_options = {
                    "no-duplicate": true,
                    "no-duplicate-callback": window.alert,
                    "no-duplicate-text": "Duplicate tags",
                    "forbidden-chars": [",", "?","!","$","%","^","&","*"],
                    "edit-on-delete": false
                };

                foo.jQuery('#groupMembers').tagging(my_custom_options);
                foo.jQuery('#editGroupMembers').tagging(my_custom_options);


            });
            
            function addGroup() {
                $("#processedGroupMembers").val((foo.jQuery('#groupMembers').tagging("getTags")));
                $("#addGroupForm").submit();
            }

            function editGroup() {
                $("#newGroupMembers").val((foo.jQuery('#editGroupMembers').tagging("getTags")));
                $("#editGroupForm").submit();
            }

            $('.addGroup').click(function() {

                foo.jQuery('#groupMembers').tagging("reset");

                $('#addNewGroupModal').modal('show');
                
                $('#groupMembers').tooltip('show');

            });


            $('.editGroup').click(function() {

                var groupname = $(this).data('id');
                $("#newGroupName").val('' + groupname);
                $("#oldGroupName").val('' + groupname);

                var friends = $(this).data('friends');
                var arrayFriends = friends.split(",");

                var prepareJson = [];

                for (var i = 0; i < arrayFriends.length; i++) {
                    prepareJson.push(arrayFriends[i].trim())
                }

                foo.jQuery('#editGroupMembers').tagging("reset");
                foo.jQuery('#editGroupMembers').tagging("add", prepareJson);

                $('#editGroupModal').modal('show');

            });

            $('.deleteGroup').click(function() {
               var groupname = $(this).data('id');
               $("#deleteGroupName").val('' + groupname);

               $('#deleteGroupModal').modal('show');

           });

       </script>


   </body>
   </html>
