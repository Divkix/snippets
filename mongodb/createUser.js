db.createUser(
    {
        user: "user",
        pwd: "user",
        roles: [
            {
                role: "readWrite",
                db:"user_db"
            },
            {
                role: "dbAdmin",
                db: "user_db"
            }
        ]
    }
)
