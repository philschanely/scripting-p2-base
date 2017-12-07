# Starter functions

There are a handful of utility functions I will provide you for making short work of some common operations. Enter each of these into `app.js` in alphabetical order between global variable declarations and the DRE.

```js
function serializeData($form) {
  if ($form) {
    var formData = $form.serializeArray();
    var data = {};
    for (var i = 0; i < formData.length; i++) {
      var item = formData[i];
      data[item.name] = item.value;
    }
    return data;
  } else {
    return false;
  }
}
```

# Preloading templates and the DRE

You have a number of templates that you should load before the application can launch. First declare a global variable that can later hold each compiled template for each of the nine template files you should have built. Use a consistent naming convention as demonstrated in course lessons and be sure to declare them outside the DRE and any other functions, ideally near the very top of your `app.js` file.

Create a preload function as demonstrated in the course lessons that loads each of your nine templates. However, we need a little modification, so use this model:

```js
function preloadTemplates() {

  var tplCount = 0;

  $.get('templates/page-login.tpl.html', function(tpl){
    tplPageLogin = Handlebars.compile(tpl);
    tplCount++;
    loadInitialPage(tplCount);
  });

  // Load other templates here...

}
```

You should duplicate the `$.get()` portion and change out the various pieces to ensure you load each template. Also register the task and category templates as partials.

The new bit here makes use of a counter `tplCount` that increments each time a template loads. Also as each template loads we call `loadInitialPage` and pass that counter into it. You'll see more in a minute but we're using this counter to ensure that all the templates are finished loading before we proceed with the application. We'll define that function in the next section.

Let's add our DRE now at the bottom of our script. Inside it call `preloadTemplates()`.

# Setting up the Page Navigation

For a moment we're going to suspend reality and just set up the ability to move between the main pages of the application without any user authentication. Here's the overview:

* On load, the application should show the login page. From here:
  * The user can submit the login form and be taken to the main application page, or
  * The user can click to view the signup page
* From the signup page the user can:
  * Submit the signup form and be taken to the main application page, or
  * Click to return to the login page
* From the main application page the user can click to log out and be taken to the login page.

## Defining `loadInitialPage()`

But we don't want any of this to happen until all our templates have finished loading. So earlier when we preloaded our templates we used a counter and a call to `loadInitialPage` as preparatory for now.

* Define `loadInitialPage()` and allow for a single parameter called `count` to be passed in. Within this function define a variable `totalTpl` and assign the number of templates to it (`9` if you're following these instructions).
* Add a conditional statement: if `count` is less than `totalTpl` then `return false`.

This much allows this function to be called each time a template is finished loading. Since most of the time the `count` being passed in will be less than the `totalTpl` this conditional statement passes and the function exits, returning `false`. But for the one situation where we've finally loaded the last template this condition will not pass and JavaScript will continue processing the function. So after the conditional statement now call `showLoginPage()`.

## Defining `showLoginPage()`, `showSignupPage()`, and `showMainPage()`

Define `showLoginPage()` as a new function alphabetically amidst the other functions you have so far. Iniside it, enter the following:

* We need to be sure to remove any existing pages that might have already loaded. So select `.page` elements and remove them.
* Next we need to parse the compiled login page template that you should have stored in a global variable. Define a variable to hold the HTML this compiled template will return. As this variable's value call the compiled login page template as a function but don't pass any data in.
* Finally, select `body` and prepend to it the HTML you just created.

You should be able to load the application now and see your login page appear.

Let's follow this pattern to create two more functions:

* `showSignupPage()` should do the same basic thing but display the signup page.
* `showMainPage()` should do the same basic thing but display the main page template instead. We will circle back later and add code here that loads the category and task data.

Now we have three functions ready that should handle displaying the three root pages of our application. But only the login page is loading right now. We need event handlers to help us navigate between them. That's up next.

## Defining `initializeEventHandlers()` and basic navigation listeners

Inside and at the end of the DRE call a function `initializeEventHandlers()`. This will be a neat place we'll consolidate all our event listeners for the application.

Now define `initializeEventHandlers()` outside of the DRE alphabetically amidst the other functions you have so far. Inside it we'll use this structure to listen for events within body on specific elements:

```js
$('body').on('eventType', 'selector', handlerFunction);
```

We'll replace `eventType`, `selector`, and `handlerFunction` with specific values depending on the situation.

For our first one we'll want to listen for click events on the link you have in your login page that points to the sign up page. So use `click` as the `eventType`, a selector for your hyperlink as the `selector`, and call `showSignupPage` as the `handler`.

You can test this and should find that when you click on the link the signup page appears.

Another listener should do the reverse: it should listen for click events on the link in your sign up page that points back to the login page and call `showLoginPage` as a result.

Next add an event listener listening for a submit event on your login form and call a new function `processLogin` as a result. We'll define that in a moment.

Next add an event listener listening for a submit even on your signup form and call a new function `processSignup` as a result.

Finally, add one more event listener that listens for clicks on the logout link in your main page and calls `processLogout` as a result.

Because we have a little extra code we'll include in the long run when users sign up, log in, and out we need these declared as separate functions from the page loading functions we've already defined. So define them alphabetically amidst the other functions.

* In `processLogin()` and `processSignup()` allow `e` to be passed in as a parameter and inside them call `e.preventDefault()`. Then just call `showMainPage()` for now as both should eventually take the user to the main page.
* In `processLogout()` just call `showLoginPage()`.

You should have a full roundtrip navigation now, even though it doesn't actually authenticate a user or create a new user.

# Processing Login

Now we get to dive into some deeper code in order to make our login script function properly. We'll modify the `processLogin()` function to collect the email and password provided by the user, send them to the API, and check see if what was provided is valid. If so, we'll allow the user into the application and store their user information for user later. If not we'll keep them on the login page but reveal feedback that the credentials they provided were invalid.

So recall that `processLogin()` is called as the event handler when a user submits the login form. Right now it just sends us right on to `showMainPage()` so we'll need to pull that out and write our actual script.

First, ensure an event object `e` is passed in as a parameter in `processLogin()`. Ensure that you prevent the default behavior of the event with `e.preventDefault()`. Then convert `e.target` to a jQuery object and store it in a variable. Pass that variable into `serializeData()` and assign the result to a new variable. In summary, this takes the submitted form (`e.target`) and passes it into a function (`serializeData()`) that retrieves the data submitted in that form as an object where the properties and values match the form `name` attribute and values provided. Log the result to the console to confirm that whatever email address and/or password you enter is output in a `email` and `password` property on this object. Remove this log when confirmed.

Now in theory we're ready to send this data to our authentication service. However, it is a *MAJOR* security risk to send or store a password in plain text as it was entered by the user. So before we send it off we need to first convert it to an encrypted form.

**You need to add the following `md5` library file using a `script` tag in your `index.html` file in order to proceed:**

`https://cdnjs.cloudflare.com/ajax/libs/blueimp-md5/2.10.0/js/md5.min.js`

So redefine the data's `password` property and as the new value assign the result of calling `md5()` and passing in the current value of the password. Something like this (depending on the `data` variable you've defined):

```js
formData.password = md5(formData.password);
```

If you log this to the console now you should see an encrypted password that is much safer to send.

Its time to send our first call to our application's API. In order to help make these calls a little more efficient, define a **global** variable called `api` (up where you declared your global template variables outside of any functions or the DRE) and assign to it `"/api/index.php/"` which is the path to the API root. This variable is used in all the API endpoint calls as you can see on the API Reference link provided in the Codio Toolbar.

So now lets call our API's `auth_user` endpoint. See the documentation for this from the preview dropdown and copy the GET request code provided. Paste it inside `processLogin()`. Where the provided code has the `filter` property and assigns an object to it, replace that whole object with your data variable that you assigned earlier when you called `serializeData()`. This way you pass the provided email and password to the API as a GET request. Inside anonymous function assigned to the `success` property redefine the `data` parameter to be the result of `$.parseJSON(data)`.

Now log new `data` value to the console to see the result from the server. A default user with email `phil@example.com` and password, `password` is provided, so if you enter these credentials you should see a valid user returned. Any other credentials at this point should return an invalid user object.

So now we can check to see if the provided user is a valid one. Add a conditional statement that checks to see if `data.authenticated` is `true`. If it is then call `showMainPage()`. Otherwise, select and display an element in your login form that shows feedback to the user to try again with valid credentials.

Test the application now and you should find you can log in with the demo account provided but not with any other credentials.

Before we move on lets also store our user info for future reference in the application. Declare a **global** variable called `currentUser`. Then inside `processLogin()` in the conditional statement you created just a moment ago, before you called `showMainPage()` `assign data.user` to `currentUser`.

# Processing Signup

Now lets get things set up so users can create new accounts beyond our default provided accounts. First ensure that you have precisely the following in your signup page's form:

* text input fields with `name` attributes that match the corresponding field names for users: `name`, `email`.
* two password type input fields. One should have a `name` of `password` and the other must be different but logical such as `passwordConfirm`.

You should have a simple start to the event handler listening for this form to be submitted, the `processSignup()` function. We just need to do two things: validate the data and send it to the API. But first we need to serialize the data in the form. Follow what you did earlier with the login form: Inside `processSignup()` after you've called `e.preventDefault()` convert `e.target` into a jQuery object and pass it into `serializeData()`. Store the resulting data object in a variable you can use later. Log this variable to check that it is indeed working correctly; you should see an object with the values you put into the form associated with the `name` attributes you gave the form fields. Remove the log when done testing.

Also remove the call to `showMainPage()` that you should have in `processSignup()`. We'll put it back later in a better spot.

## Validating Signup Data

Validating our signup data is pretty straight froward. First, let's ensure that they actually provided a name. Simply add a contitional statement like this:

```js
if (formData.name.length < 1) {
  // Show feedback...
  return false;
}
```

This looks at the length of the value stored in your form's `name` item. If it is less than one character then the user didn't provide any name. You should replace the comment here with some code that selects your feedback element in the signup form and provides some relevant feedback such as "Please provide a name for yourself." The `return false` line tells JavaScript to exit the function without proceeding further.

Next we need to ensure that the email address the user provided is valid. There are all kinds of ways they can goof up an email address in terms of normal typos. But it is also possible that they provide content that is not actually an email address. A topic we have not covered is that of regular expressions, which is a code system for searching for patterns within strings. Such a code can be used to validate that a provided string is or is not a valid email address. So enter this function alphabetically amidst your other functions:

```js
function validateEmail(email) {
    var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    return re.test(email);
}
```

And just trust that if you pass an `email` string into this function you get back `true` if its a valid email address and `false` if not.

So now inside `processSignup()` after the first validation condition you added moments ago add a call to a `validateEmail()`. Pass in your form data's `email` property and assign the result of the function call to a variable such as `isEmailValid`:

```js
var isEmailValid = validateEmail(formData.email);
```

Next add a conditional statement: If the email address is not valid (`isEmailValid` is equal to `false`) then select your feedback element in the signup page and provide feedback that the email address is not valid. Then `return false` to exit the `processSignup()` function without proceeding further. So if the provided email address is invalid the user will see feedback to make an adjustment. Otherwise we'll continue with the next validation.

Now we need to compare the two passwords the user provided to ensure they entered the same one twice as a check for their sake--I'm sure that you're familiar with this convention. So here we need a conditional statement where we check to see if the two password values are not equal to each other. If they are not equal to each other then we show relevant feedback for them to correct the error and again `return false` to exit `processSignup()`.

Now if all three of these validations pass we know the user's data is all ready to send to our API! See the API Reference for the User endpoint and copy the provided code for POST ing new users. Paste it in `processSignup` after your last validation condition. THis provided code makes the POST call to the user endpoint and sends data for the new user including the name, email, and password. We need to update these values to include the actual data from our form. So modify the values assigned to each property something like this:

```js
data: {
  "name": formData.name,
  "email": formData.email,
  "password": md5(formData.password)
},
```

Make sure you use the correct variable for the form data based on what you got back from your call to `serializeData`. Also make sure you encrypt the password the user provided by passing it into `md5()`.

Now for the success function convert `data` to JSON using `$.parseJSON` as you have before. Log the result to ensure you have a valid user object. Further validating the new user again would be wise, but we'll keep things simple and rely on our API to have done this. So now redefine your global `currentUser` variable to be the `data` you got back from the service. Then call `showMainPage()`.

Testing the result now should ensure that you can create a new user and log right in. If you log out you should be able to log back in with that new user's credentials in the main login form.

Note that along the way you might have added a number of users into the database. If you send me (your professor) the id number for the one user you want to keep in the system I will clean up the additional undesired user entries.

# Loading Tasks and Categories

Now finally we get to load the tasks and categories for the user who is currently logged in. Generally this will involve:

* Sending a call to the API endpoint for category and task and passing the current user's id as the `owner` filter.
* Responding to the results by injecting the returned data into the appropriate template.
* Displaying that template on the page.

***More coming soon!***
