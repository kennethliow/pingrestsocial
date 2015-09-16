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

                    <div id="newgroupalert" class="alert alert-warning hidden">  
                        <a class="close" data-dismiss="alert">×</a>  
                        <strong id="newgroupalertmsg"></strong>  
                    </div> 

                    <div class="form-group">
                        <label for="groupName" class="col-sm-3 control-label">Group Name</label>
                        <div class="col-sm-9">
                            <input type="text" class="form-control" id="groupName" name="groupName" autocomplete="off"  required placeholder="Enter a name for your new group"/>
                            <input type="hidden" name="processedGroupMembers" id="processedGroupMembers" />
                            <input type="hidden" name="albumID" id="add_new_group_albumID" />
                            <span class="help-block" id="groupNameMessage"></span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="groupMembers" class="col-sm-3 control-label">Group Members</label>
                        <div class="col-sm-9">
                            <div data-tags-input-name="tag" class="form-control" id="groupMembers" data-toggle="tooltip" data-placement="bottom" title="You can enter multiple friends' username or email by seperating them with commas"></div>
                        </div>

                    </div>

                </div>
                <div class="modal-footer">
                    <button class="btn btn-default" data-dismiss="modal">Close</button>
                    <button class="btn btn-pink" onclick="addGroup();">Create Group</button>
                </div>
            </form>
        </div>
    </div>
</div>
<script>
    var foo = {};
    foo.jQuery = jQuery.noConflict(true);

    foo.jQuery(document).ready(function() {

        var my_custom_options = {
            "no-duplicate": true,
            "no-duplicate-callback": window.alert,
            "no-duplicate-text": "Duplicate tags",
            "forbidden-chars": [",", "?", "!", "$", "%", "^", "&", "*"],
            "edit-on-delete": false
        };
        foo.jQuery('#groupMembers').tagging(my_custom_options);
        foo.jQuery('#editGroupMembers').tagging(my_custom_options);
    });

    function addGroup() {
        var last_name = $('#groupMembers').children(".type-zone").val();
        foo.jQuery('#groupMembers').tagging("add", last_name);
        $('#groupMembers').children(".type-zone").val("");
        if ($('#groupName').val() == '') {
            $('#newgroupalert').removeClass("hidden");
            $('#newgroupalertmsg').text('Group name cannot be empty!');
            event.preventDefault();
        } else {
            var groupName = $('#groupName').val();
            $.ajax({
                dataType: "json",
                url: "CheckExistingGroupServlet",
                data: {"groupname": groupName},
                success: function(data) {
                    if (data["status"] == "failure"){
                        $('#newgroupalert').removeClass("hidden");
                        $('#newgroupalertmsg').text('This group name has already been used, please try entering another group name!');
                    } else {
                        $('#newgroupalert').addClass("hidden");
                        $("#processedGroupMembers").val((foo.jQuery('#groupMembers').tagging("getTags")));
                        $("#addGroupForm").submit();
                    }
                },
                error: function(jqXHR, textStatus, errorThrown) {
                    alert(textStatus + errorThrown);
                }
            });
            event.preventDefault();
        }
        
    };
    
    $('.addGroup').click(function() {
        foo.jQuery('#groupMembers').tagging("reset");
        $('#addNewGroupModal').modal('show');
        $('#groupMembers').tooltip('show');
        if ($('#tag_group_album_id').val() != null){
            $('#add_new_group_albumID').val($('#tag_group_album_id').val());
        }
    });
</script>