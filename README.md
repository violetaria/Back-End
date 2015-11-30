# Flour Power API
<hr>

Welcome to the Flour Power API documentation.  This application will allow you to store and read your favorite recipes from varied media types (web, print, etc).

**Methods**

* [User Methods](#user-methods)
	* [Registration](#user-registration)
	* [Login] (#user-login)
* [Category Methods](#category-methods)
	* [List](#category-list)
	
##<a name="user-methods"></a>User Methods

###<a name="user-registration"></a>Registration

This request will create a new user in the system and return back an auth\_token back.  The auth\_token must be used for all subsequent requests (except for User Login).

**URL** /users/new

**Method** POST

**Request**
    

| Parameter        | Type           | Description  |
| ------------- |:-------------:|:----- |
| email | String | ​*(Required)*​ Users email address, must follow the format TEXT@TEXT.TEXT |
| password    | String      |  ​*(Required)*​  password for the user |


**Response**

If successful, you will receive:

    Status Code: 201 - Created
    
```json
{
  "success": "User created successfully",
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
    

| Parameter        | Type           | Description  |
| ------------- |:-------------:|:----- |
| email | String | ​*(Required)*​ existing users email address|
| password    | String      |  ​*(Required)*​  password for the user |


**Response**

If successful, you will receive:

    Status Code: 202 - Accepted
    
```json
{
  "success": "User logged in successfully",
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
      "name": "Entrees"
    },
    {
      "id": 4,
      "name": "Desserts"
    },
    {
      "id": 5,
      "name": "Salads"
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

