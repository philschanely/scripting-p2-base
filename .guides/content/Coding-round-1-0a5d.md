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

Because we have a little extra code we'll include in the long run when users sign up, log in, and out we need these declared as separate functions from the page loading functions we've already defined. So define them alphabetically amidst the other functions. In `processLogin()` just call `showMainPage()` for now; in `processSignup()` also just call `showMainPage()`; and in `processLogout()` just call `shodLoginPage()`.

You should have a full roundtrip navigation now, even though it doesn't actually authenticate a user or create a new user.

# Processing Login

Coming soon.

# Processing Signup

Coming soon.

# Loading Tasks and Categories

Coming soon.
