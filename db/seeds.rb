# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


categories = Category.create([ { name: "Drinks" },
                               { name: "Appetizers" },
                               { name: "Main Courses" },
                               { name: "Desserts" },
                               { name: "Salads and Soups" },
                               { name: "Side Dishes" }
                             ])