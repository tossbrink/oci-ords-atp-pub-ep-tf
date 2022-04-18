/*
  @author: tossbrink
*/
#Secure Access
resource "oci_database_autonomous_database" "create_sec_adb" {
    #Required
    compartment_id = var.compartment_ocid
    db_name = var.ATP_pubdb_name
    admin_password = var.ATP_password
    cpu_core_count = var.ATP_database_cpu_core_count
    data_storage_size_in_tbs = var.ATP_database_data_storage_size_in_tbs
    
    #Optional
    db_workload = var.ATP_adb_workload
    display_name = var.ATP_pubdb_name
    freeform_tags = var.ATP_database_freeform_tags.TfAtpPub01
    license_model = var.ATP_database_license_model
}

