# Flour Power API
<hr>
[![Build Status](https://travis-ci.org/violetaria/Back-End.svg)](https://travis-ci.org/violetaria/Back-End)

Welcome to the Flour Power API documentation.  This application will allow you to store and read your favorite recipes from varied media types (web, print, etc).

**Methods**

* [User Methods](#user-methods)
	* [Registration](#user-registration)
	* [Login] (#user-login)
* [Category Methods](#category-methods)
	* [List All Categories](#category-list)
	* [List All Recipes](#category-list-recipes)
* [Recipe Methods](#recipe-methods)
	* [Create](#recipe-create)
	* [Retrieve](#recipe-retrieve)
	* [List Recipes](#recipe-list)
	* [Update](#recipe-update)
	* [Delete](#recipe-delete)
	* [Search from API](#recipe-search-api)
	* [Import from API](#recipe-import-api)
	* [Retrieve from API](#recipe-retrieve-api)
	
##<a name="user-methods"></a>User Methods

###<a name="user-registration"></a>Registration

This request will create a new user in the system and return back an auth\_token back.  The auth\_token must be used for all subsequent requests (except for User Login).

**URL** /users/new

**Method** POST

**Request**
    

| Form Params | Type           | Description  |
| ------------- |:-------------:|:----- |
| email | String | ​*(Required)*​ Users email address, must follow the format TEXT@TEXT.TEXT |
| password    | String      |  ​*(Required)*​  password for the user |


**Response**

If successful, you will receive:

    Status Code: 201 - Created
    
```json
{
  "success": "true",
  "email": "kelly@email.com",
  "auth-token": "254cc2078c4e2388d35e187f5cd5cfcb"
}           
```

If unsuccessful, you will receive:

    Status Code: 422 - Unprocessable Entity
    
```json
{
  "errors": [
    "Email has already been taken"
  ]
}
```

###<a name="user-login"></a>Login

This request will allow an existing user in the system to send their email and password and return back an auth\_token back.  The auth\_token must be used for all subsequent requests (except for User Registration).

**URL** /users

**Method** POST

**Request**
    
| Form Params       | Type           | Description  |
| ------------- |:-------------:|:----- |
| email | String | ​*(Required)*​ existing users email address|
| password    | String      |  ​*(Required)*​  password for the user |


**Response**

If successful, you will receive:

    Status Code: 202 - Accepted
    
```json
{
  "success": "true",
  "email": "terri@email.com",
  "auth-token": "993e9fa29ee570454072443649f0c2fa"
}         
```

If unsuccessful, you will receive:

    Status Code: 401 - Not Authorized
    
```json
{
  "errors": "email or password incorrect"
}
```

##<a name="category-methods"></a>Category Methods

###<a name="category-list"></a>List Categories

This request will allow an authenticated user to list all categories in the system.

**URL** /categories

**Method** GET

**Request**
    
| Header Fields        | Type           | Description  |
| ------------- |:-------------:|:----- |
| auth-token | String | ​*(Required)*​ existing users auth-token  |

**Response**

If successful, you will receive:

    Status Code: 200 - OK
    
```json
{
  "categories": [
    {
      "id": 1,
      "name": "Drinks"
    },
    {
      "id": 2,
      "name": "Appetizers"
    },
    {
      "id": 3,
      "name": "Main Courses"
    },
    {
      "id": 4,
      "name": "Desserts"
    },
    {
      "id": 5,
      "name": "Salads and Soups"
    },
    {
      "id": 6,
      "name": "Side Dishes"
    }
  ]
}    
```

If unsuccessful, you will receive:

    Status Code: 401 - Not Authorized
    
```json
{
  "error": "Could not authenticate with auth_token:''"
}
```

###<a name="category-list"></a>List All Recipes in Category

This request will allow an authenticated user to list all recipes within the category in the system.

**URL** /categories/:id/recipes

**Method** GET

**Request**
    
| Header Fields        | Type           | Description  |
| ------------- |:-------------:|:----- |
| auth-token | String | ​*(Required)*​ existing users auth-token  |


| URL Params | Type           | Description  |
| ------------- |:-------------:|:----- |
| id | Integer | ​*(Required)*​ ID of the category to retrieve |

**Response**

Note: my_image will be set to "" if there is no picture uploaded by the user

If successful, you will receive:

    Status Code: 200 - OK
    
```json
{
  "success": "true",
  "recipes": [
    {
      "id": 17,
      "name": "chocolate",
      "categories": [
        "Desserts"
      ],
      "directions": [
        "Turn on oven to 350",
        "Mix eggs, bacon, and cheese together in a large bowl",
        "Pour into a cast iron pan",
        "Bake in oven for 15-20 minutes"
      ],
      "ingredients": [
        {
          "name": "carrots",
          "amount": 2,
          "unit": "TBS"
        },
        {
          "name": "flour",
          "amount": 2.5,
          "unit": "cups"
        }
      ],
  	"source_name": "Foodnetwork",
  	"source_url": "http://www.foodnetwork.com/recipes/guy-fieri/four-bean-relish-recipe.html",
  	"source_image_url": "https://spoonacular.com/recipeImages/Four-Bean-Relish-311491.jpeg",
  	"my_image": "https://flourpower-dev.s3.amazonaws.com/recipes/my_images/000/000/005/original/28980-200.png?1449505114"      
    }
  ]
} 
```

If unsuccessful, you will receive:

    Status Code: 401 - Not Authorized
    
```json
{
  "error": "Could not authenticate with auth_token:''"
}
```


##<a name="recipe-methods"></a>Recipe Methods

###<a name="recipe-create"></a>Create Recipe 

This request allows an authenticated user to create a new recipe.

**URL** /recipes

**Method** POST

**Request**
    
| Header Fields        | Type           | Description  |
| ------------- |:-------------:|:----- |
| auth-token | String | ​*(Required)*​ existing users auth-token  |


| Form Params | Type           | Description  |
| ------------- |:-------------:|:----- |
| name | String | ​*(Required)*​ Name for your recipe |
| category_names| Array of Strings | *(Required)* An array of categories that the recipe will fit into, can contain more than one category. <br>Example: ["Drinks", "Desserts"]|
| steps | Array of Strings | *(Required)* An array of directions for your recipe.  They should be sent over in order! |
| ingredients | Array of Strings | *(Required)* An array of ingredients for your recipe |
| my_image | Image | *(Optional)* a user uploaded picture of your recipe! |

***Example Request***

```json
{
  	"name": "Cheesy Eggs",
  	"category_names": [
  							"Desserts",
  							"Entrees" ],
	"steps":
  		[ 	"Turn on oven to 350",
      		"Mix eggs, bacon, and cheese together in a large bowl",
      		"Pour into a cast iron pan",
      		"Bake in oven for 15-20 minutes" ],
 	"ingredients":
  		[	
  			{  
  				"name"=>"carrots", 
  				"amount"=>"2", 
  				"unit"=>"TBS"
  			}, 
  			{	
  				"name"=>"flour", 
  				"amount"=>"2.5", 
  				"unit"=>"cups"
  			}
  		],
  		"my_image": "path to your local image of the recipe"      

  }
```

**Response**

If successful, you will receive:

    Status Code: 201 - Created
    
```json
{
  "success": "true",
  "id": "1,
  "name": "Cheesy Eggs"
}           
```

If unsuccessful, you will receive:

    Status Code: 422 - Unprocessable Entity
    
```json
{
  "errors": [
    "Name has already been taken"
  ]
}
```


###<a name="recipe-retrieve"></a>Retrieve Recipe 

This request allows an authenticated user to get a single recipe and all related entities.  

**URL** /recipes/:id

**Method** GET

**Request**
    
| Header Fields        | Type           | Description  |
| ------------- |:-------------:|:----- |
| auth-token | String | ​*(Required)*​ existing users auth-token  |


| URL Params | Type           | Description  |
| ------------- |:-------------:|:----- |
| id | Integer | ​*(Required)*​ ID of the recipe to retrieve |


**Response**

If successful, you will receive:

    Status Code: 200 - OK
    
Categorized = TRUE

```json
{
  "success": "true",
  "id": 31,
  "name": "Four-Bean Relish",
  "categories": [
    "Desserts"
  ],
  "directions": [
    "Directions",
    "Whisk the red wine vinegar, balsamic vinegar, olive oil, 1/2 teaspoon sea salt, and pepper to taste in a large bowl.Add the scallions, red onion, Peppadew peppers, honey, white beans, chickpeas, pinto beans and black beans and toss to coat. Let sit in the refrigerator at least 2 hours to allow the flavors to blend. Mix thoroughly before serving.Photograph by Kat Teutsch"
  ],
  "ingredients": [
    {
      "name": "balsamic vinegar",
      "amount": 0.25,
      "unit": "cup"
    },
    {
      "name": "bell peppers",
      "amount": 0.25,
      "unit": "cup"
    },
    {
      "name": "canned black beans",
      "amount": 12,
      "unit": "ounce"
    },
    {
      "name": "canned chickpeas",
      "amount": 12,
      "unit": "ounce"
    },
    {
      "name": "canned pinto beans",
      "amount": 12,
      "unit": "ounce"
    },
    {
      "name": "canned white beans",
      "amount": 12,
      "unit": "ounce"
    },
    {
      "name": "honey",
      "amount": 3,
      "unit": "tablespoons"
    },
    {
      "name": "olive oil",
      "amount": 0.333333333333333,
      "unit": "cup"
    },
    {
      "name": "onion",
      "amount": 0.75,
      "unit": "cup"
    },
    {
      "name": "red wine vinegar",
      "amount": 0.333333333333333,
      "unit": "cup"
    },
    {
      "name": "scallions",
      "amount": 0.25,
      "unit": "cup"
    },
    {
      "name": "sea salt",
      "amount": 8,
      "unit": "servings"
    }
  ],
  "source_name": "Foodnetwork",
  "source_url": "http://www.foodnetwork.com/recipes/guy-fieri/four-bean-relish-recipe.html",
  "source_image_url": "https://spoonacular.com/recipeImages/Four-Bean-Relish-311491.jpeg",
  "my_image": ""
}    
```

Categorized = FALSE

```json
{
  "success": "true",
  "recipes": [
    {
      "name": "Test",
      "id": 25,
      "categories": [
        "Drinks"
      ],
      "directions": [
        "Make the coconut rice by adding the water, coconut milk, sugar, and salt to a large saucepan. Bring to a boil, then stir in rice. Return to a boil. Reduce heat to low, cover and cook for 20 minutes. Remove from heat and let stand 10 minutes, before fluffing with a fork.",
        "Meanwhile, make the teriyaki sauce by adding all of the sauce ingredients to a small saucepan over medium heat. Bring to a boil, stirring constantly, and boil for about 1 minute. The sauce should be thick enough to coat the back of the spoon.",
        "Pour 1/4 cup of the teriyaki sauce over the raw chicken and set aside to marinate for at least 15 minutes.",
        "Prepare your grill and heat it to medium.",
        "If you have a vegetable grill basket to grill the vegetables in, then chop them and grill them in the basket. If not, cut the zucchini and onion into large chunks and leave the mini bell peppers whole. Drizzle some olive oil over the vegetables and over the pineapple spears. Grill the vegetables for just a few minutes on each side and then remove to a plate. Grill the pineapple next by placing the pineapple spears directly on the grill. Grill for about 2 minutes on each side, and remove to a plate. Lastly, place the chicken on the grill. Cook for about 2 minutes on each side, or until cooked through. Remove to a plate to rest before slicing.",
        "To serve, add coconut rice to each serving bowl. Top with grilled veggies, pineapple and chicken. Drizzle a little of the remaining teriyaki sauce on top. Sprinkle with toasted coconut, if desired."
      ],
      "ingredients": [
        {
          "name": "rice vinegar",
          "amount": 2,
          "unit": "Tbsp"
        },
        {
          "name": "soy sauce",
          "amount": 0.5,
          "unit": "cup"
        },
        {
          "name": "jasmine rice",
          "amount": 2,
          "unit": "cups"
        },
        {
          "name": "water",
          "amount": 2,
          "unit": "cups"
        },
        {
          "name": "unsweetened coconut milk",
          "amount": 1.5,
          "unit": "cups"
        },
        {
          "name": "salt",
          "amount": 1,
          "unit": "tsp"
        },
        {
          "name": "light brown sugar",
          "amount": 2,
          "unit": "tsp"
        },
        {
          "name": "sweetened coconut flakes",
          "amount": 0.5,
          "unit": "cup"
        },
        {
          "name": "red onion",
          "amount": 1,
          "unit": ""
        },
        {
          "name": "bell peppers",
          "amount": 4,
          "unit": ""
        },
        {
          "name": "pineapple",
          "amount": 0.5,
          "unit": ""
        },
        {
          "name": "zucchini",
          "amount": 1,
          "unit": ""
        },
        {
          "name": "chicken tenders",
          "amount": 4,
          "unit": ""
        },
        {
          "name": "sesame oil",
          "amount": 1,
          "unit": "Tbsp"
        },
        {
          "name": "brown sugar",
          "amount": 0.25,
          "unit": "cup"
        },
        {
          "name": "honey",
          "amount": 1,
          "unit": "Tbsp"
        },
        {
          "name": "ground ginger",
          "amount": 0.75,
          "unit": "tsp"
        },
        {
          "name": "garlic",
          "amount": 1,
          "unit": "clove"
        },
        {
          "name": "cornstarch",
          "amount": 2,
          "unit": "tsp"
        },
        {
          "name": "crushed red pepper",
          "amount": 0.25,
          "unit": "tsp"
        }
      ],
      "source_name": null,
      "source_url": null,
      "source_image_url": null,
      "my_image": "https://flourpower-dev.s3.amazonaws.com/recipes/my_images/000/000/025/original/10-512.png?1449520081"
    },
    {
      "name": "Sour Cherry Pudding Cake",
      "id": 30,
      "categories": [
        "Drinks"
      ],
      "directions": [
        "Preheat oven to 375 degrees F (190 degrees C). Grease a 9x13-inch baking dish.",
        "In a bowl, stir together the flour, 1 cup of sugar, baking powder, milk, and vegetable oil to make a smooth batter; scrape batter into the prepared baking dish.",
        "In a separate bowl, stir the cherries with 1 cup of sugar and the almond extract; spoon the cherry mixture over the batter.",
        "Bake in the preheated oven until the cake is lightly browned and a toothpick inserted into the center of the cake comes out clean, about 30 minutes.",
        "Kitchen-Friendly View"
      ],
      "ingredients": [
        {
          "name": "almond extract",
          "amount": 0.25,
          "unit": "teaspoon"
        },
        {
          "name": "baking powder",
          "amount": 1,
          "unit": "tablespoon"
        },
        {
          "name": "flour",
          "amount": 2,
          "unit": "cups"
        },
        {
          "name": "milk",
          "amount": 1,
          "unit": "cup"
        },
        {
          "name": "tart cherries",
          "amount": 3,
          "unit": "cups"
        },
        {
          "name": "vegetable oil",
          "amount": 2,
          "unit": "tablespoons"
        },
        {
          "name": "white sugar",
          "amount": 1,
          "unit": "cup"
        }
      ],
      "source_name": "Allrecipes",
      "source_url": "http://allrecipes.com/recipe/sour-cherry-pudding-cake/Detail.aspx",
      "source_image_url": "https://spoonacular.com/recipeImages/Sour-Cherry-Pudding-Cake-342491.jpg",
      "my_image": "https://flourpower-dev.s3.amazonaws.com/recipes/my_images/000/000/030/original/12279085_10207822490338393_5100797063626879098_n.jpg?1449521401"
    },
    ]
```

If unsuccessful, you will receive:

    Status Code: 404 - Not Found
    
```json
{
  "errors": "Object not found: Couldn't find Recipe with 'id'=55"
}
```

###<a name="recipe-list"></a>List Recipes

This request allows an authenticated user to get all of their recipes and all related entities.  There are two ways to call this API.  If you send a URL parameter with categorized=false, it will return all the recipes uncategorized and you will get an array of recipes.  Otherwise, the recipes will be ordered by Category and you will get back an array of hashes with the recipes for each category.

**URL** /recipes

**Method** GET

**Request**
    
| Header Fields        | Type           | Description  |
| ------------- |:-------------:|:----- |
| auth-token | String | ​*(Required)*​ existing users auth-token  |

| URL Parameters        | Type           | Description  |
| ------------- |:-------------:|:----- |
| categorized | boolean | ​*(optional)*​ default: true, if you set to false, the recipes will not be organized by category  |

**Response**

If successful, you will receive:

    Status Code: 200 - OK
    
```json
 {
  "success": "true",
  "recipes": [
    {
      "category": "Drinks",
      "recipes": [
        {
          "name": "Chocolate Cookies 2",
          "id": 19,
          "directions": [
            "Turn on oven to 350",
            "Mix eggs, bacon, and cheese together in a large bowl",
            "Pour into a cast iron pan",
            "Bake in oven for 15-20 minutes"
          ],
          "ingredients": [
            {
              "name": "carrots",
              "amount": 2,
              "unit": "TBS"
            },
            {
              "name": "flour",
              "amount": 2.5,
              "unit": "cups"
            }
          ],
          "source_name": null,
          "source_url": null,
          "source_image_url": null,
          "my_image": ""
        }
      ]
    },
    {
      "category": "Appetizers",
      "recipes": []
    },
    {
      "category": "Main Courses",
      "recipes": []
    },
    {
      "category": "Desserts",
      "recipes": [
        {
          "name": "Zucchini and Shrimp Fritters",
          "id": 27,
          "directions": [
            "Make the coconut rice by adding the water, coconut milk, sugar, and salt to a large saucepan. Bring to a boil, then stir in rice. Return to a boil. Reduce heat to low, cover and cook for 20 minutes. Remove from heat and let stand 10 minutes, before fluffing with a fork.",
            "Meanwhile, make the teriyaki sauce by adding all of the sauce ingredients to a small saucepan over medium heat. Bring to a boil, stirring constantly, and boil for about 1 minute. The sauce should be thick enough to coat the back of the spoon.",
            "Pour 1/4 cup of the teriyaki sauce over the raw chicken and set aside to marinate for at least 15 minutes.",
            "Prepare your grill and heat it to medium.",
            "If you have a vegetable grill basket to grill the vegetables in, then chop them and grill them in the basket. If not, cut the zucchini and onion into large chunks and leave the mini bell peppers whole. Drizzle some olive oil over the vegetables and over the pineapple spears. Grill the vegetables for just a few minutes on each side and then remove to a plate. Grill the pineapple next by placing the pineapple spears directly on the grill. Grill for about 2 minutes on each side, and remove to a plate. Lastly, place the chicken on the grill. Cook for about 2 minutes on each side, or until cooked through. Remove to a plate to rest before slicing.",
            "To serve, add coconut rice to each serving bowl. Top with grilled veggies, pineapple and chicken. Drizzle a little of the remaining teriyaki sauce on top. Sprinkle with toasted coconut, if desired."
          ],
          "ingredients": [
            {
              "name": "rice vinegar",
              "amount": 2,
              "unit": "Tbsp"
            },
            {
              "name": "soy sauce",
              "amount": 0.5,
              "unit": "cup"
            },
            {
              "name": "jasmine rice",
              "amount": 2,
              "unit": "cups"
            },
            {
              "name": "water",
              "amount": 2,
              "unit": "cups"
            },
            {
              "name": "unsweetened coconut milk",
              "amount": 1.5,
              "unit": "cups"
            },
            {
              "name": "salt",
              "amount": 1,
              "unit": "tsp"
            },
            {
              "name": "light brown sugar",
              "amount": 2,
              "unit": "tsp"
            },
            {
              "name": "sweetened coconut flakes",
              "amount": 0.5,
              "unit": "cup"
            },
            {
              "name": "red onion",
              "amount": 1,
              "unit": ""
            },
            {
              "name": "bell peppers",
              "amount": 4,
              "unit": ""
            },
            {
              "name": "pineapple",
              "amount": 0.5,
              "unit": ""
            },
            {
              "name": "zucchini",
              "amount": 1,
              "unit": ""
            },
            {
              "name": "chicken tenders",
              "amount": 4,
              "unit": ""
            },
            {
              "name": "sesame oil",
              "amount": 1,
              "unit": "Tbsp"
            },
            {
              "name": "brown sugar",
              "amount": 0.25,
              "unit": "cup"
            },
            {
              "name": "honey",
              "amount": 1,
              "unit": "Tbsp"
            },
            {
              "name": "ground ginger",
              "amount": 0.75,
              "unit": "tsp"
            },
            {
              "name": "garlic",
              "amount": 1,
              "unit": "clove"
            },
            {
              "name": "cornstarch",
              "amount": 2,
              "unit": "tsp"
            },
            {
              "name": "crushed red pepper",
              "amount": 0.25,
              "unit": "tsp"
            }
          ],
         	"source_name": "Allrecipes",
  			"source_url": "http://allrecipes.com/recipe/sour-cherry-pudding-cake/Detail.aspx",
			"source_image_url": "https://spoonacular.com/recipeImages/Sour-Cherry-Pudding-Cake-342491.jpg",
			"my_image": "https://flourpower-dev.s3.amazonaws.com/recipes/my_images/000/000/030/original/12279085_10207822490338393_5100797063626879098_n.jpg?1449521401"
        }
      ]
    },
    {
      "category": "Salads and Soups",
      "recipes": []
    },
    {
      "category": "Side Dishes",
      "recipes": []
    }
  ]
}
```

If unsuccessful, you will receive:

    Status Code: 404 - Not Found
    
```json
{
  "errors": "Object not found: Couldn't find Recipe with 'id'=55"
}
```

###<a name="recipe-update"></a>Update Recipe 

This request allows an authenticated user to update an existing recipe.  Users can only update recipes that they have created.

**URL** /recipes/:id

**Method** PATCH

**Request**
    
| Header Fields        | Type           | Description  |
| ------------- |:-------------:|:----- |
| auth-token | String | ​*(Required)*​ existing users auth-token  |


| URL Params | Type           | Description  |
| ------------- |:-------------:|:----- |
| id | Integer | ​*(Required)*​ ID of the recipe to retrieve |

| Form Params | Type | Description  |
| ------------- |:-------------:|:----- |
| name | String | *(Optional)* New name for the recipe |
| category_names| Array | *(Optional)* An array of categories that the recipe will fit into, can contain more than one category. <br>Example: ["Drinks", "Desserts"]|
| my_image | Image | *(Optional)* a user uploaded picture of your recipe! |


**Response**

If successful, you will receive:

    Status Code: 200 - OK
    
```json
{
  "success": "true"
}           
```

If unsuccessful, you will receive:

    Status Code: 404 - Not Found
    
```json
{
  "errors": "Object not found: Couldn't find Recipe with 'id'=55"
}
```
-OR-
	
	Status Code: 401 - Unprocessible Entity

```json
{
  "errors": [
    "Name can't be blank"
  ]
}
```

###<a name="recipe-delete"></a>Delete Recipe 

This request allows an authenticated user to delete an existing recipe.  Users can only delete recipes they have created.  All directions and ingredient amounts for that recipe will be deleted as well.

**URL** /recipes/:id

**Method** DELETE

**Request**
    
| Header Fields        | Type           | Description  |
| ------------- |:-------------:|:----- |
| auth-token | String | ​*(Required)*​ existing users auth-token  |


| URL Params | Type           | Description  |
| ------------- |:-------------:|:----- |
| id | Integer | ​*(Required)*​ ID of the recipe to delete |

**Response**

If successful, you will receive:

    Status Code: 200 - OK
    
```json
{
  "success": "true"
}           
```

If unsuccessful, you will receive:

    Status Code: 404 - Not Found
    
```json
{
  "errors": "Object not found: Couldn't find Recipe with 'id'=55"
}
```

###<a name="recipe-search-api"></a>Search Recipes from API

This request allows an authenticated user to search for a recipe from the Spoonacular API.  User will need to provide search terms in the URL

**URL** /api/recipes/search?query=:search_terms

**Method** GET

**Request**
    
| Header Fields        | Type           | Description  |
| ------------- |:-------------:|:----- |
| auth-token | String | ​*(Required)*​ existing users auth-token  |


| URL Params | Type           | Description  |
| ------------- |:-------------:|:----- |
| query | String | ​*(Required)*​ recipe keywords to search the Spoonacular API|

**Response**

If successful, you will receive:

    Status Code: 200 - OK
    
```json
{
  "success": "true",
  "recipes": [
    {
      "id": 491957,
      "name": "Bacon and Cheese Stuffed Burgers (Jucy Lucy Burgers)",
      "source_image_url": "https://spoonacular.com/recipeImages/Bacon-and-Cheese-Stuffed-Burgers-(Jucy-Lucy-Burgers)-491957.jpg"
    },
    {
      "id": 102267,
      "name": "Tex-Mex Burgers Texotic-Mexotic Burgers",
      "source_image_url": "https://spoonacular.com/recipeImages/tex-mex-burgers-texotic-mexotic-burgers-2-102267.jpg"
    },
    {
      "id": 600168,
      "name": "Tartar Burgers – these are tasty little burgers that everyone will love",
      "source_image_url": "https://spoonacular.com/recipeImages/Tartar-Burgers--these-are-tasty-little-burgers-that-everyone-will-love-600168.jpg"
    },
    {
      "id": 145892,
      "name": "Burgers.....my Way",
      "source_image_url": "https://spoonacular.com/recipeImages/burgers-my-way-2-145892.jpg"
    },
    {
      "id": 470451,
      "name": "Best Burgers Ever",
      "source_image_url": "https://spoonacular.com/recipeImages/Best-Burgers-Ever-470451.jpg"
    },
    {
      "id": 471658,
      "name": "The Very Best Burgers!",
      "source_image_url": "https://spoonacular.com/recipeImages/The-Very-Best-Burgers-471658.jpg"
    },
    {
      "id": 479011,
      "name": "The Best Burgers",
      "source_image_url": "https://spoonacular.com/recipeImages/The-Best-Burgers-479011.jpg"
    },
    {
      "id": 545379,
      "name": "All A.1. Burgers",
      "source_image_url": "https://spoonacular.com/recipeImages/All-A-1--Burgers-545379.jpg"
    },
    {
      "id": 7688,
      "name": "Tuna Burgers",
      "source_image_url": "https://spoonacular.com/recipeImages/tuna-burgers-2-7688.jpg"
    },
    {
      "id": 8843,
      "name": "Lentil Burgers",
      "source_image_url": "https://spoonacular.com/recipeImages/lentil_burgers-8843.jpg"
    }
  ]
}         
```

If unsuccessful, you will receive:

    Status Code: 404 - Not Found
    
```json
{
  "errors": "No results found which match query 'BLAH'"
}
```


###<a name="recipe-import-api"></a>Import Recipe from API

This request allows an authenticated user to import a recipe from the Spoonacular API.  User will need to provide which Categories they want the recipe added to in our database

**URL** /api/recipes/import

**Method** POST

**Request**
    
| Header Fields        | Type           | Description  |
| ------------- |:-------------:|:----- |
| auth-token | String | ​*(Required)*​ existing users auth-token  |


| Form Params | Type           | Description  |
| ------------- |:-------------:|:----- |
| id | Integer | ​*(Required)*​ ID of the recipe to import, Recipe ID must be present in the Spoonacular DB |
| category_names | Array of Strings | *(Required)* An array of strings which denote which category the user wants the recipe stored in.  <br>Example: ["Drinks", "Desserts"]|

**Response**

If successful, you will receive:

    Status Code: 200 - OK
    
```json
{
  "success": "true",
  "id": 30,
  "name": "Sour Cherry Pudding Cake"
}          
```

If unsuccessful, you will receive:

    Status Code: 404 - Not Found
    
```json
{
  "errors": "Object not found: Couldn't find Recipe with 'id'=55"
}
```

###<a name="recipe-retrieve-api"></a>Retrieve Recipe from API

This request allows an authenticated user to retrieve a recipe from the Spoonacular API.  User will need to provide the Recipe ID from Spoonacular

**URL** /api/recipes/:id

**Method** GET

**Request**
    
| Header Fields        | Type           | Description  |
| ------------- |:-------------:|:----- |
| auth-token | String | ​*(Required)*​ existing users auth-token  |


| URL Params | Type           | Description  |
| ------------- |:-------------:|:----- |
| id | Integer | ​*(Required)*​ ID of the recipe to import, Recipe ID must be present in the Spoonacular DB |

**Response**

If successful, you will receive:

    Status Code: 200 - OK

```json
{
  "success": "true",
  "id": 491957,
  "name": "Bacon and Cheese Stuffed Burgers (Jucy Lucy Burgers)",
  "directions": [
    "Divide beef into 4 equal portions. Form each portion into a tightly packed ball. Working with one ball at a time divide into 2 equal portions. Flatten them into a circle on a cutting board. Fold a slice of cheese in half twice so you have 4 squares of cheese and place in middle of burger. Cover the cheese with bacon crumbles and place the other patty on top so. Crimp the edges together to seal them, the cheese will make a bump on top. Repeat until all 4 burgers are ready. Season the tops with salt and pepper.",
    "",
    "Heat a large cast iron or heavy-bottomed skillet over medium heat (alternately you can grill them) and cook burgers over heat 5 minutes on first side (the cheese bump should facing up). Flip the burgers and poke the tops of the burgers with a toothpick to let steam escape. Cook 3-4 minutes. Remove from heat and let burgers rest a few minutes (especially when serving to children) as cheese is molten hot and can cause burns. Serve on buns with the condiments of your choice."
  ],
  "ingredients": [
    {
      "name": "buns",
      "amount": 4,
      "unit": ""
    },
    {
      "name": "ground beef",
      "amount": 1.25,
      "unit": "pounds"
    },
    {
      "name": "bacon",
      "amount": 4,
      "unit": "slices"
    },
    {
      "name": "american cheese",
      "amount": 4,
      "unit": "slices"
    },
    {
      "name": "coarse salt",
      "amount": 4,
      "unit": "servings"
    },
    {
      "name": "condiments and toppings",
      "amount": 4,
      "unit": "servings"
    }
  ],
  "source_name": "Cinnamon Spice and Everything Nice",
  "source_url": "http://www.cinnamonspiceandeverythingnice.com/bacon-and-cheese-stuffed-burgers-jucy-lucy-burgers/",
  "source_image_url": "https://spoonacular.com/recipeImages/Bacon-and-Cheese-Stuffed-Burgers-(Jucy-Lucy-Burgers)-491957.jpg"
}
```


If unsuccessful, you will receive:

    Status Code: 404 - Not Found
    
```json
{
  "errors": "Object not found: Couldn't find Recipe with 'id'=55"
}
```