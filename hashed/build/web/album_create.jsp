<!-- Modal -->
<div class="modal fade" id="add_new_album" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
                <h2 class="modal-title" id="myModalLabel">Create a new Album</h2>
            </div>
            <form name="add_new_album" action="AddAlbumServlet" method="get" class="form-horizontal">
                <div class="modal-body">

                    <div class="form-group">
                        <label for="albumName" class="col-sm-3 control-label">Album Name</label>
                        <div class="col-sm-9">
                            <input type="text" class="form-control" id="albumName" name="album_name" autocomplete="off"  required placeholder="Enter a name for your new album"/>
                            <input type="hidden" id="selected_photos_new_album" name="photoIDs" value=""/>
                            <input type="hidden" id="selected_photos_links_new_album" name="photoLinks" value=""/>
                        </div>
                    </div>

                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                    <button type="submit" class="btn btn-pink">Create Album</button>
                </div>
            </form>
        </div>
    </div>
</div>