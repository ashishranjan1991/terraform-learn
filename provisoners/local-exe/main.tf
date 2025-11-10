resource "aws_db_instance" "mydb" {
    identifier = "mydb-instance"
    engine = "mysql"
    instance_class = "db.t3.micro"
    username = "admin"
    password = "password123"
    db_name= "mydatabase"
    allocated_storage = 20
    skip_final_snapshot = true
    publicly_accessible = true
    
}

resource "null_resource" "test" {
    depends_on = [ aws_db_instance.mydb ]
    provisioner "local-exec" {
        command = "mysql -h ${aws_db_instance.mydb.address} -u admin -ppassword123 < ./test.sql"

    }  
    triggers = {
        always_run = "${timestamp()}"
    }
  
}