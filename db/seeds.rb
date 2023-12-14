User.create([
  {
    name: "Tagger",
    email: "tagger@dashboard.com",
    password: "password",
    password_confirmation: "password",
    role: :tagger,
  },
  {
    name: "Viewer",
    email: "viewer@dashboard.com",
    password: "password",
    password_confirmation: "password",
    role: :viewer,
  },
])
