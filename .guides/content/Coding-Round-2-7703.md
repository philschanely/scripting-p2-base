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

One of the features we need to enable is the ability for the user to see all their tasks from any category (that's the default setup we just finished) as well as filter to only those in a specific category. So double-check to ensure you have the following in your category sidebar:

* Category items on which we can list for clicks, including having a `data-id` attribute on the category container (such as an li) and ideally a class of `category` there you can use for traversing upwards. Just be careful this class does not conflict with another class you have elsewhere. Note as well that this is ideally a hyperlink around the name of the category with a class we can use as a selector such as `category-link`. Note that we'll also want a *separate* "Edit category" button for each category that we'll use later to call up our category editor modal. So consider this structure if you can make it or something similar work:

  ```html
  <li data-id="{{id}}">
    <a href="#" class="category-link">{{name}}</a>
    <button class="edit-category">Edit</button>
  </li>
  ```

* A "All tasks" item that the user can click on to get back to seeing all tasks regardless of the category.

Now here's the roadmap:

* We'll listen for clicks on the "all tasks" item and respond by calling our task API using GET but without any category filters and reload the task list with the results. We have a lot of this set up thanks to `getTasks()` but will add a new event listener and a few other small changes.
* We'll listen for clicks on the category items themselves and respond by calling our task API using GET but providing category filter. This means we'll need to make some additional updates to `getTasks()` to make it a little smarter and allow for category filtering.

Let's have at it!

Lets get the category filter set up first. In `getTasks()` lets allow a parameter called `categoryId` to be passed in. Then immediately after you declare your task filter variable add a new conditional statement: If `categoryId` is greater than 0 then set a new `category` property on your task filter to be assigned the value in `categoryId`. That's it!

So now if a value is passed into the function it will be added as a category filter for your service call. And since when successful results are returned we replace the contents of `#tasks` with the results, this should take care of reloading the task list as well.

Now we need to set up the listener on category links. In your `initializeEventHandlers()` function add a new listener for click events on your category links. Respond by calling a new function called `filterTasksByCategory()`.

Now define `filterTasksByCategory()` alphabetically amidst your other functions. Ensure that you pass in `e` and directly inside the function call `e.preventDefault()`. Get the category id for the item that was clicked:

* convert `e.target` to a jQuery object
* traverse from here up to the closest category container (`.category` if you followed my suggested structure)
* read that item's `data-id` attribute and store this in a variable.

Log the result to the console and click on some category links. Ensure that you see the correct category id for each one you click.

Now just call `getTasks()` and pass the category id variable in. You should then see the task list filter to show the tasks in the category you click.

Back in `initializeEventHandlers()` add another listener that responds to click events on your "all tasks" item. Set a new function `getAllTasks()` as the handler.

Now define `getAllTasks()` alphabetically amidst your other function definitions. Be sure to pass in `e` and immediately inside call `e.preventDefault()`.

Then just call `getTasks()` but don't pass anything in.

Test the results and you should be able to toggle between seeing all tasks and only those in a given category.

# Adding and Editing Categories

**Coming soon!**

# Deleting Categories

**Coming soon!**

# Adding and Editing Tasks

**Coming soon!**

# Marking Tasks as Complete

**Coming soon!**

# Deleting Tasks
