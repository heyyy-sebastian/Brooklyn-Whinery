# Brooklyn Whinery

Brooklyn Whinery is an online forum that lets users create and share wine tasting menus. Each menu's recommendations are generated based on the user's mood and the kind of wine they'd like to imbibe (red, white or both).

Features Spec
- The ability to create a username and login
- Generate new wine tasting menus
- View all menus
- View individual menus
- Like or comment on a menu
- Sort menus by top likes
- Sort menus by top comments

Modules used
- Sinatra: a Ruby API that allows you to easily build out applications
- BCrypt: Used for encrypting passwords so they're never stored as plaintext in the database
- RedCarpet: renders comments written in markdown format
- PG: a gemfile that enables the program interface with PostGreSQL

To Run This Code on your Local Host*
1. Download all files to your machine
2. Create a database in your terminal using the command createdb appname
3. Seed database file in your terminal using the command ruby lib/seeds.rb
4. Rackup in your terminal
5. Open browser and use localhost:9292/ to access the homepage and begin

*commands are bash-specific; other shell program commands may differ
