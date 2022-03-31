class UserPermission {

  static List jobPermissions = [];
  static List userPermissions = [];

  static List getJobPermissions(){
    return jobPermissions;
  }

  static List getUserPermissions(){
    return userPermissions;
  }

  static void addJobPermission(String permission){
    jobPermissions.add(permission);
  }

  static addUserPermission(String permission){
    userPermissions.add(permission);
  }

  static List getAllPermissions(){
    List permissions = [];
    for(var x = 0; x < UserPermission.jobPermissions.length; x++){
      if(!permissions.contains(UserPermission.jobPermissions[x])){
        permissions.add(UserPermission.jobPermissions[x]);
      }
    }
    for(var x = 0; x < UserPermission.userPermissions.length; x++){
      if(!permissions.contains(UserPermission.userPermissions[x])){
        permissions.add(UserPermission.userPermissions[x]);
      }
    }

    return permissions;
  }

  bool containsJobPermission(permission){
    if(jobPermissions.contains(permission)){
      return true;
    } else {
      return false;
    }
  }

  bool containsUserPermission(permission){
    if(userPermissions.contains(permission)){
      return true;
    } else {
      return false;
    }
  }


}