# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

User.create([
  {
    name: "Tagger",
    email: "tagger@dashboard.com",
    password: "password",
    password_confirmation: "password",
    role: :tagger,
  },{
    name: "Viewer",
    email: "viewer@dashboard.com",
    password: "password",
    password_confirmation: "password",
    role: :viewer,
  },
])
