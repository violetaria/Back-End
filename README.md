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
	* [List All Recipes](#recipe-list)
	* [Update](#recipe-update)
	* [Delete](#recipe-delete)
	* [Search from API](#recipe-search-api)
	* [Import from API](#recipe-import-api)
	* [Retrieve from API](#recipe-retrieve-api)
* [OCR Methods](#ocr-methods)
	* [Process Image](#ocr-process) 
	
##<a name="user-methods"></a>User Methods

###<a name="user-registration"></a>Registration

This request will create a new user in the system and return back an auth\_token back.  The auth\_token must be used for all subsequent requests (except for User Login).

####POST `/users/new`

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
  "email": "YOUR@EMAIL.COM",
  "auth_token": "AUTH_TOKEN"
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

####POST `/users`

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
  "email": "YOUR@EMAIL.COM",
  "auth_token": "AUTH_TOKEN"
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

####GET `/categories`

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

####GET `/categories/:id/recipes`


**Request**
    
| Header Fields        | Type           | Description  |
| ------------- |:-------------:|:----- |
| auth-token | String | ​*(Required)*​ existing users auth-token  |


| URL Params | Type           | Description  |
| ------------- |:-------------:|:----- |
| id | Integer | ​*(Required)*​ ID of the category to retrieve |

**Response**

**Note:** *my_image will be set to "" if there is no picture uploaded by the user*

If successful, you will receive:

    Status Code: 200 - OK
    
```json
{
  "success": "true",
  "id": 26,
  "name": "Easy Chocolate Cake",
  "directions": [
    "Turn on oven to 350",
    "Mix Eggs, Chocolate, Flour, and Sugar",
    "Pour into a cast iron pan",
    "Bake in oven for 15-20 minutes"
  ],
  "ingredients": [
    {
      "name": "flour",
      "amount": 2,
      "unit": "Cups"
    },
    {
      "name": "sugar",
      "amount": 2.5,
      "unit": "cups"
    },
    {
      "name": "eggs",
      "amount": 2,
      "unit": ""
    },
    {
      "name": "chocolate bars",
      "amount": 3,
      "unit": "bars"
    }
  ],
  "source_name": null,
  "source_url": null,
  "source_image_url": null,
  "my_image": ""
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

####POST `/recipes`

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
  "id": 28,
  "name": "Quick Chocolate Cake",
  "directions": [
    "Turn on oven to 350",
    "Mix Eggs, Chocolate, Flour, and Sugar",
    "Pour into a cast iron pan",
    "Bake in oven for 15-20 minutes"
  ],
  "ingredients": [
    {
      "name": "flour",
      "amount": 2,
      "unit": "Cups"
    },
    {
      "name": "sugar",
      "amount": 2.5,
      "unit": "cups"
    },
    {
      "name": "eggs",
      "amount": 2,
      "unit": ""
    },
    {
      "name": "chocolate bars",
      "amount": 3,
      "unit": "bars"
    }
  ],
  "source_name": null,
  "source_url": null,
  "source_image_url": null,
  "my_image": ""
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

####GET `/recipes/:id`

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
    
```json
{
  "success": "true",
  "id": 28,
  "name": "Quick Chocolate Cake",
  "categories": [
    {
      "name": "Desserts",
      "id": 4
    }
  ],
  "directions": [
    "Turn on oven to 350",
    "Mix Eggs, Chocolate, Flour, and Sugar",
    "Pour into a cast iron pan",
    "Bake in oven for 15-20 minutes"
  ],
  "ingredients": [
    {
      "name": "flour",
      "amount": 2,
      "unit": "Cups"
    },
    {
      "name": "sugar",
      "amount": 2.5,
      "unit": "cups"
    },
    {
      "name": "eggs",
      "amount": 2,
      "unit": ""
    },
    {
      "name": "chocolate bars",
      "amount": 3,
      "unit": "bars"
    }
  ],
  "source_name": null,
  "source_url": null,
  "source_image_url": null,
  "my_image": ""
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

This request allows an authenticated user to get all of their recipes and all related entities.  There are two ways to call this API.  If you send a URL parameter with categorized=false, it will return all the recipes uncategorized and you will get an array of recipes.  Otherwise, the recipes will be ordered by Category and you will get back an array of hashes with the recipes for each category.

####GET `/recipes?categorized=:categorized_boolean`

**Request**
    
| Header Fields        | Type           | Description  |
| ------------- |:-------------:|:----- |
| auth-token | String | ​*(Required)*​ existing users auth-token  |

| URL Params        | Type           | Description  |
| ------------- |:-------------:|:----- |
| categorized | boolean | ​*(optional)*​ **default: true**, if you set to false, the recipes will not be organized by category  |

**Response**


If successful, you will receive:

    Status Code: 200 - OK
    
**Categorized = TRUE** 

```json
{
  "success": "true",
  "recipes": [
    {
      "category": "Drinks",
      "category_id": 1,
      "recipes": [
        {
          "name": "Chocolate Cake",
          "id": 25,
          "directions": [
            "Turn on oven to 350",
            "Mix Eggs, Chocolate, Flour, and Sugar",
            "Pour into a cast iron pan",
            "Bake in oven for 15-20 minutes"
          ],
          "ingredients": [
            {
              "name": "flour",
              "amount": 2,
              "unit": "Cups"
            },
            {
              "name": "sugar",
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
      "category_id": 2,
      "recipes": []
    },
    {
      "category": "Main Courses",
      "category_id": 3,
      "recipes": [
        {
          "name": "Bacon and Cheese Stuffed Burgers (Jucy Lucy Burgers)",
          "id": 27,
          "directions": [
            "Divide beef into 4 equal portions. Form each portion into a tightly packed ball. Working with one ball at a time divide into 2 equal portions. Flatten them into a circle on a cutting board. Fold a slice of cheese in half twice so you have 4 squares of cheese and place in middle of burger. Cover the cheese with bacon crumbles and place the other patty on top so. Crimp the edges together to seal them, the cheese will make a bump on top. Repeat until all 4 burgers are ready. Season the tops with salt and pepper.",
            "Heat a large cast iron or heavy-bottomed skillet over medium heat (alternately you can grill them) and cook burgers over heat 5 minutes on first side (the cheese bump should facing up). Flip the burgers and poke the tops of the burgers with a toothpick to let steam escape. Cook 3-4 minutes. Remove from heat and let burgers rest a few minutes (especially when serving to children) as cheese is molten hot and can cause burns. Serve on buns with the condiments of your choice."
          ],
          "ingredients": [
            {
              "name": "condiments and toppings",
              "amount": 4,
              "unit": "servings"
            },
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
            }
          ],
          "source_name": "Cinnamon Spice and Everything Nice",
          "source_url": "http://www.cinnamonspiceandeverythingnice.com/bacon-and-cheese-stuffed-burgers-jucy-lucy-burgers/",
          "source_image_url": "https://spoonacular.com/recipeImages/Bacon-and-Cheese-Stuffed-Burgers-(Jucy-Lucy-Burgers)-491957.jpg",
          "my_image": ""
        }
      ]
    },
    {
      "category": "Desserts",
      "category_id": 4,
      "recipes": [
        {
          "name": "Chocolate Cake",
          "id": 25,
          "directions": [
            "Turn on oven to 350",
            "Mix Eggs, Chocolate, Flour, and Sugar",
            "Pour into a cast iron pan",
            "Bake in oven for 15-20 minutes"
          ],
          "ingredients": [
            {
              "name": "flour",
              "amount": 2,
              "unit": "Cups"
            },
            {
              "name": "sugar",
              "amount": 2.5,
              "unit": "cups"
            }
          ],
          "source_name": null,
          "source_url": null,
          "source_image_url": null,
          "my_image": ""
        },
        {
          "name": "Easy Chocolate Cake",
          "id": 26,
          "directions": [
            "Turn on oven to 350",
            "Mix Eggs, Chocolate, Flour, and Sugar",
            "Pour into a cast iron pan",
            "Bake in oven for 15-20 minutes"
          ],
          "ingredients": [
            {
              "name": "chocolate bars",
              "amount": 3,
              "unit": "bars"
            },
            {
              "name": "eggs",
              "amount": 2,
              "unit": ""
            },
            {
              "name": "sugar",
              "amount": 2.5,
              "unit": "cups"
            },
            {
              "name": "flour",
              "amount": 2,
              "unit": "Cups"
            }
          ],
          "source_name": null,
          "source_url": null,
          "source_image_url": null,
          "my_image": ""
        },
        {
          "name": "Quick Chocolate Cake",
          "id": 28,
          "directions": [
            "Turn on oven to 350",
            "Mix Eggs, Chocolate, Flour, and Sugar",
            "Pour into a cast iron pan",
            "Bake in oven for 15-20 minutes"
          ],
          "ingredients": [
            {
              "name": "chocolate bars",
              "amount": 3,
              "unit": "bars"
            },
            {
              "name": "flour",
              "amount": 2,
              "unit": "Cups"
            },
            {
              "name": "sugar",
              "amount": 2.5,
              "unit": "cups"
            },
            {
              "name": "eggs",
              "amount": 2,
              "unit": ""
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
      "category": "Salads and Soups",
      "category_id": 5,
      "recipes": []
    },
    {
      "category": "Side Dishes",
      "category_id": 6,
      "recipes": []
    }
  ]
}
```

**Categorized=FALSE**

```json
{
  "success": "true",
  "recipes": [
    {
      "name": "Chocolate Cake",
      "id": 25,
      "categories": [
        {
          "name": "Drinks",
          "id": 1
        },
        {
          "name": "Desserts",
          "id": 4
        }
      ],
      "directions": [
        "Turn on oven to 350",
        "Mix Eggs, Chocolate, Flour, and Sugar",
        "Pour into a cast iron pan",
        "Bake in oven for 15-20 minutes"
      ],
      "ingredients": [
        {
          "name": "flour",
          "amount": 2,
          "unit": "Cups"
        },
        {
          "name": "sugar",
          "amount": 2.5,
          "unit": "cups"
        }
      ],
      "source_name": null,
      "source_url": null,
      "source_image_url": null,
      "my_image": ""
    },
    {
      "name": "Easy Chocolate Cake",
      "id": 26,
      "categories": [
        {
          "name": "Desserts",
          "id": 4
        }
      ],
      "directions": [
        "Turn on oven to 350",
        "Mix Eggs, Chocolate, Flour, and Sugar",
        "Pour into a cast iron pan",
        "Bake in oven for 15-20 minutes"
      ],
      "ingredients": [
        {
          "name": "chocolate bars",
          "amount": 3,
          "unit": "bars"
        },
        {
          "name": "eggs",
          "amount": 2,
          "unit": ""
        },
        {
          "name": "sugar",
          "amount": 2.5,
          "unit": "cups"
        },
        {
          "name": "flour",
          "amount": 2,
          "unit": "Cups"
        }
      ],
      "source_name": null,
      "source_url": null,
      "source_image_url": null,
      "my_image": ""
    },
    {
      "name": "Bacon and Cheese Stuffed Burgers (Jucy Lucy Burgers)",
      "id": 27,
      "categories": [
        {
          "name": "Main Courses",
          "id": 3
        }
      ],
      "directions": [
        "Divide beef into 4 equal portions. Form each portion into a tightly packed ball. Working with one ball at a time divide into 2 equal portions. Flatten them into a circle on a cutting board. Fold a slice of cheese in half twice so you have 4 squares of cheese and place in middle of burger. Cover the cheese with bacon crumbles and place the other patty on top so. Crimp the edges together to seal them, the cheese will make a bump on top. Repeat until all 4 burgers are ready. Season the tops with salt and pepper.",
        "Heat a large cast iron or heavy-bottomed skillet over medium heat (alternately you can grill them) and cook burgers over heat 5 minutes on first side (the cheese bump should facing up). Flip the burgers and poke the tops of the burgers with a toothpick to let steam escape. Cook 3-4 minutes. Remove from heat and let burgers rest a few minutes (especially when serving to children) as cheese is molten hot and can cause burns. Serve on buns with the condiments of your choice."
      ],
      "ingredients": [
        {
          "name": "condiments and toppings",
          "amount": 4,
          "unit": "servings"
        },
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
        }
      ],
      "source_name": "Cinnamon Spice and Everything Nice",
      "source_url": "http://www.cinnamonspiceandeverythingnice.com/bacon-and-cheese-stuffed-burgers-jucy-lucy-burgers/",
      "source_image_url": "https://spoonacular.com/recipeImages/Bacon-and-Cheese-Stuffed-Burgers-(Jucy-Lucy-Burgers)-491957.jpg",
      "my_image": ""
    },
    {
      "name": "Quick Chocolate Cake",
      "id": 28,
      "categories": [
        {
          "name": "Desserts",
          "id": 4
        }
      ],
      "directions": [
        "Turn on oven to 350",
        "Mix Eggs, Chocolate, Flour, and Sugar",
        "Pour into a cast iron pan",
        "Bake in oven for 15-20 minutes"
      ],
      "ingredients": [
        {
          "name": "chocolate bars",
          "amount": 3,
          "unit": "bars"
        },
        {
          "name": "flour",
          "amount": 2,
          "unit": "Cups"
        },
        {
          "name": "sugar",
          "amount": 2.5,
          "unit": "cups"
        },
        {
          "name": "eggs",
          "amount": 2,
          "unit": ""
        }
      ],
      "source_name": null,
      "source_url": null,
      "source_image_url": null,
      "my_image": ""
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

####PATCH `/recipes/:id`

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

####DELETE `/recipes/:id`

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

####GET `/api/recipes/search?query=:search_terms`

**Request**
    
| Header Fields        | Type           | Description  |
| ------------- |:-------------:|:----- |
| auth-token | String | ​*(Required)*​ existing users auth-token  |


| URL Params | Type           | Description  |
| ------------- |:-------------:|:----- |
| query | String | ​*(Required)*​ recipe keywords to search the Spoonacular API, **must be URL Encoded**|

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

####POST `/api/recipes/import`

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
  "id": 27,
  "name": "Bacon and Cheese Stuffed Burgers (Jucy Lucy Burgers)",
  "directions": [
    "Divide beef into 4 equal portions. Form each portion into a tightly packed ball. Working with one ball at a time divide into 2 equal portions. Flatten them into a circle on a cutting board. Fold a slice of cheese in half twice so you have 4 squares of cheese and place in middle of burger. Cover the cheese with bacon crumbles and place the other patty on top so. Crimp the edges together to seal them, the cheese will make a bump on top. Repeat until all 4 burgers are ready. Season the tops with salt and pepper.",
    "Heat a large cast iron or heavy-bottomed skillet over medium heat (alternately you can grill them) and cook burgers over heat 5 minutes on first side (the cheese bump should facing up). Flip the burgers and poke the tops of the burgers with a toothpick to let steam escape. Cook 3-4 minutes. Remove from heat and let burgers rest a few minutes (especially when serving to children) as cheese is molten hot and can cause burns. Serve on buns with the condiments of your choice.",
    ""
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
  "source_image_url": "https://spoonacular.com/recipeImages/Bacon-and-Cheese-Stuffed-Burgers-(Jucy-Lucy-Burgers)-491957.jpg",
  "my_image": ""
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

####GET `/api/recipes/:id`

**Request**
    
| Header Fields        | Type           | Description  |
| ------------- |:-------------:|:----- |
| auth-token | String | ​*(Required)*​ existing users auth-token  |


| URL Params | Type           | Description  |
| ------------- |:-------------:|:----- |
| id | Integer | ​*(Required)*​ ID of the recipe to retrieve data for, Recipe ID must be present in the Spoonacular DB |

**Response**

If successful, you will receive:

    Status Code: 200 - OK

```json
{
  "success": "true",
  "id": 492957,
  "name": "Butternut Squash & Cheddar Potatoes au Gratin",
  "directions": [
    "Steam the butternut squash until it is soft and can be mashed easily with a fork.",
    "Preheat your oven to 400°F, and spray a 13x9 inch baking pan with cooking spray or oil.",
    "Place the butternut squash, milk, broth, dream cheese, mustard, cheddar cheese, and ¼ c parmesan cheese in a blender and puree until smooth. Add salt and pepper to taste.",
    "Layer half of the potatoes in the prepared pan and pour over half of the cheese sauce. Repeat with the remaining potatoes and sauce.",
    "Cover and bake for 30 minutes.",
    "Sprinkle the remaining parmesan cheese over the top, then bake uncovered for another 20-30 minutes, or until the potatoes in the center are soft and the top is browned."
  ],
  "ingredients": [
    {
      "name": "butternut squash",
      "amount": 3,
      "unit": "lbs"
    },
    {
      "name": "chicken broth",
      "amount": 1,
      "unit": "c"
    },
    {
      "name": "dry mustard",
      "amount": 1,
      "unit": "t"
    },
    {
      "name": "extra sharp cheddar cheese",
      "amount": 1,
      "unit": "c"
    },
    {
      "name": "light cream cheese",
      "amount": 2,
      "unit": "oz"
    },
    {
      "name": "milk",
      "amount": 1,
      "unit": "c"
    },
    {
      "name": "parmesan cheese",
      "amount": 0.5,
      "unit": "c"
    },
    {
      "name": "salt and pepper",
      "amount": 8,
      "unit": "servings"
    },
    {
      "name": "white potatoes",
      "amount": 2,
      "unit": "lbs"
    }
  ],
  "source_name": "Cupcakes and Kale Chips",
  "source_url": "http://cupcakesandkalechips.com/easyrecipe-print/6088-0/",
  "source_image_url": "https://spoonacular.com/recipeImages/Butternut-Squash---Cheddar-Potatoes-au-Gratin-492957.jpg"
}
```


If unsuccessful, you will receive:

    Status Code: 404 - Not Found
    
```json
{
  "errors": "Object not found: Couldn't find Recipe with 'id'=55"
}
```

##<a name="ocr-methods"></a>OCR Methods

###<a name="ocr-progress"></a>Process Image

This request allows an authenticated user to send an image and have it processed by the RTesseract gem.  The API will return back an array with the text read from the picture.

####POST `/ocr/process_image`

**Request**
    
| Header Fields        | Type           | Description  |
| ------------- |:-------------:|:----- |
| auth-token | String | ​*(Required)*​ existing users auth-token  |


| Form Params | Type           | Description  |
| ------------- |:-------------:|:----- |
| my_image | Image File | ​*(Required)*​ Image of text to process|


**Response**

If successful, you will receive:

    Status Code: 200 - OK
    
```json
{
  "success": "true",
  "results": [
    "O O",
    "MANGO BREAD",
    "Pre heat oven to 350 degrees",
    "Do not grease pans",
    "Mix 2 cups mashed mango with 1 cup of Crisco oil and 1 1/2 cups sugar.",
    "Beat in 3 eggs. Sift in 2 cups all purpose ﬂour plus 2 tsp baking soda plus l",
    "tsp salt plus 2 tsp cinnamon plus pour in 1 tsp vanilla. Mix well !! Stir in 3%",
    "cup walnuts. Pour into loaf tins and bake 1— 1 1/2 hours till done.",
    "Makes 2 large or 4 mini loaves",
    "Bake: mango loaves 35 minutes",
    "Muffins 20 — 25 minutes",
    "Mini mufﬁns 15 minutes"
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
