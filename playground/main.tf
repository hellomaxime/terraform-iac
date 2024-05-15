resource "local_file" "test" {
  content  = "test content"
  filename = "/tmp/test.txt"
  file_permission = "0744"
}