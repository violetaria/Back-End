# Flour Power API
<hr>

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
	* [List](#recipe-list)
	* [Update](#recipe-update)
	* [Delete](#recipe-delete)
	* [Import](#recipe-import)
	
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
      ]
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
  		]
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

    Status Code: 201 - Created
    
```json
{
  "success": "true",
  "id": 13,
  "name": "Cast Iron Breakfast",
  "categories": [
    "Drinks",
    "Desserts"
  ],
  "directions": [
    "Turn on oven to 350",
    "Mix eggs, bacon, and cheese together in a large bowl",
    "Pour into a cast iron pan",
    "Bake in oven for 15-20 minutes"
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

###<a name="recipe-list"></a>List Recipes

This request allows an authenticated user to get all of their recipes and all related entities.  The recipes will be ordered by Category.  You will get back an array of hashes with the recipes for each category.

**URL** /recipes

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

    Status Code: 201 - Created
    
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
          ]
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
          ]
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

This request allows an authenticated user to delete an existing recipe.  Users can only delete recipes they have created.

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

###<a name="recipe-import"></a>Imoprt Recipe

This request allows an authenticated user to import a recipe from the Spoonacular API.  User will need to provide which Categories they want the recipe added to in our database

**URL** /recipes/import

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