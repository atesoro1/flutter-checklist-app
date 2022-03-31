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