mongoshell="use admin"
mongoshell="$mongoshell \n db.createUser( { user: \"datastore\", pwd: \"datastore\", roles: [ { role: \"readWrite\", db: \"datastore\" } ] } )"
echo -e $mongoshell | mongo -u root -p root --authenticationDatabase admin

