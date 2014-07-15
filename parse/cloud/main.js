


Parse.Cloud.define('editUser', function(request, response) {
    var userId = request.params.userId;
        //newColText = request.params.newColText;

    var User = Parse.Object.extend('_User'),
        user = new User({ objectId: userId });
        
    var currentUser = request.user;
        
    var relation = user.relation("friendsRelation");
    relation.add(currentUser);

    //user.add('friendsRelation', newColText);

    Parse.Cloud.useMasterKey();
    user.save().then(function(user) {
        response.success(user);
    }, function(error) {
        response.error(error)
    });
});

Parse.Cloud.beforeSave("Messages", function(request, response) {
    var message = request.object;

    // output just the ID so we can check it in the Data Browser
    console.log("Saving message with ID:", message.id);
    // output the whole object so we can see all the details including "didRespond"
    //console.log(message);

    response.success();
});

// log the after-save too, to confirm it was saved
Parse.Cloud.afterSave("Messages", function(request, response) {
    var message = request.object;

    // output just the ID so we can check it in the Data Browser
    console.log("Saved message with ID:", message.id);
    // output the whole object so we can see all the details including "didRespond"
    console.log(message);

    response.success();
});