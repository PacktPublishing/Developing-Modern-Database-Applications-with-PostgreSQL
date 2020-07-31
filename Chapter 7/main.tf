provider "postgresql" {
     host = "192.168.0.191"
     port = 5432
     username = "postgres"
     sslmode = "require"
     connect_timeout = 15
}
resource "postgresql_role" "terraform_role" {
     name = "terraform_role"
     login = true
     password = "tfdemo"
}
resource "postgresql_role" "terraform_dba" {
     name = "terraform_dba"
     login = true
     password = "tfdba"
}
resource "postgresql_database" "terraform_db" {
     name = "terraform_db"
     owner = "terraform_dba"
     lc_collate = "C"
     connection_limit = -1
     allow_connections = true
}
resource "postgresql_schema" "terraform_schema" {
     name = "terraform_schema"
     owner = "postgres"
     database = postgresql_database.terraform_db.name
     # terraform_role can create new objects in the schema. This is the role that
     # migrations are executed as.
     policy {
         create = true
         usage = true
         role =  postgresql_role.terraform_role.name
     }
     policy {
         create_with_grant = true
         usage_with_grant = true
         role =  postgresql_role.terraform_dba.name
     }
}