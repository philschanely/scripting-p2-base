# Simplifying Login While Testing

Now that we have login working correctly we're going to do a lot of work that assumes the user has logged in. It will be a pain while we do this if you have to keep logging in over and over again. So we're going to "spoof" the login temporarily while we work. Here's what we need to do to get this set up:

* Declare a variable at the global level such as `userIsLoggedIn` and set it to `false` for now.
* In `loadInitialPage()` remove your call to `showMainLoginPage`. Instead, add a conditional statement. If `userIsLoggedIn` is **equal to** `true` then call `showMainPage()`. Otherwise, call `showLoginPage`. Make sure you use the equality operator `==` and not the assignment operator `=` here.
* In `processLogin()` in the success function where you update the value of `currentUser` also update the value of `userIsLoggedIn` to `true`.
* In `processSignup()` in the success function where you update the value of `currentUser` also update the value of `userIsLoggedIn` to `true`.
* In `processLogout()` before your call to `showLoginPage()` update `currentUser` to be `false` and update `userIsLoggedIn` to be `false`.

OK. Test the flow now and you should still be able to log in with valid credentials. Debug otherwise.

From now on though you can spoof the authentication process by doing the following:

* In your global definition of `userIsLoggedIn` set it to `true` by default.
* In your global definition of `currentUser` set it to the demo user like this:

  ```js
  var currentUser = {
    id: 1,
    name: "Phil",
    email: "phil@example.com"
  };
  ```

And later when you're finished developing the app and you want to return to the normal operation just set `userIsLoggedIn` and `currentUser` to `false`.

# Loading Tasks and Categories

Now finally we get to load the tasks and categories for the user who is currently logged in. Generally this will involve:

* Sending a call to the API endpoint for category and task and passing the current user's id as the `owner` filter.
* Responding to the results by injecting the returned data into the appropriate template.
* Displaying that template on the page.

So let's add some code inside `showMainPage()` that helps us accomplish this. We'll simply call two new functions: `getTasks()` and `getCategories()`.

Now outside of `showMainPage()` lets define those two functions alphabetically amidst the other functions we have so far.

For `getTasks()` do the following:

* Define a variable to hold the task filters. Assign to it an object with one property called `owner` and assign to it the `id` property from within your `currentUser`.
* Open the API reference and find the provided code in order to "GET a list of all tasks for a user". Copy and paste that snippet into `getTasks()` after the variable you just declared.
* The snippet you just pasted in has a sample value of `"category=2"` assigned to the `filter` property. Erase that value and replace it with your task filter variable you defined in the first bullet above.
* Now inside the `success` function redefine data to contain the result of  `$.parseJSON(data)`. Then log the new value of `data` to the console and check the result.

At this point if you're logged in as user 1 (whether for real or spoofed) you should see an array of 3 tasks in the console. Debug otherwise.

Now we just need to inject this `data` into your task list template that you preloaded (you defined a global variable for this). Assign the HTML result to a variable. Then select the container within your main page that you want to populate the task list and either append or write it there as HTML content (depending on whether you want it to completely erase anything in that container versus be added after some other content... for mine I wrote as HTML content).

Now you should see the task list appear on the page. Debug as necessary.

We'll now repeat this same process for the category list inside of `getCategories()`. So repeat the bullets above, but change the variables and context to be that of categories instead of tasks.

Now you should see the category list appear on the page. Debug as necessary.

## Filtering to a Specific Category

**Coming soon!**


// TODO: Check that all API reference documentation has correct commas.
