public class PermissionHelper {
    public static Boolean hasCaseAdminPermission() {
        Boolean hasPermission = false;
        
        for (PermissionSetAssignment permissionSetAssignment : [SELECT Id, PermissionSet.Name 
                                                                 FROM PermissionSetAssignment 
                                                                 WHERE AssigneeId = :UserInfo.getUserId()]) {
            if (permissionSetAssignment.PermissionSet.Name == 'Case_Admin') {
                hasPermission = true;
                break;
            }
        }
        
        return hasPermission;
    }
}