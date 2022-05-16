/* ATTENTION : the terraform code for the implementation of the rds database has been commented because its application and destruction takes
too much time, and for unknown reasons its destruction doesn't work sometimes, so be wary if you uncomment it. */

/*module "db" {


  source = "terraform-aws-modules/rds/aws"

  storage_encrypted = true

  multi_az = true

  backup_retention_period = 7




  identifier = "demodb"

  engine            = "mysql"

  instance_class    = "db.t3.micro"
  allocated_storage = 5

  username="administrator"



  # DB parameter group
  family = "mysql8.0"

  # DB option group
  major_engine_version = "8.0"



}
*/
