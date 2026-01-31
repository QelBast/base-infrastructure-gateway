resource "random_pet" "example" {}
output "pet" { value = random_pet.example.id }