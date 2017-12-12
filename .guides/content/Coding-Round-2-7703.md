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

Now we need to enable the user to add and edit categories. Both of these actions will use the same form that should be prepared as a modal "window" that will appear over the current page. I like to simply use Bootstrap's modal for this, but you might have other methods in mind. The key is that you have a simple class to change or function to call such as bootstrap's `.modal('show')` or `.modal('hide')` in order to the desired modal on or off.

Let's tackle the editing side first. Here's the overview:

* We'll have a listener set up for clicks on the edit buttons of each category. In response to the event we'll load the category's data from the API and inject it into the modal template then add the template to the page and activate it.
* Users will make the desired changes to the category and save or cancel. If they cancel we won't make any changes. Otherwise, we'll be listening for the form to be submitted, and when it is we'll send the modified data off to the API using a PUT call and close the modal.
* When the data saves successfully we'll also find the corresponding category on the page and reload it with the updated data.

Now double-check that your edit category form includes the following:

* Text input fields for the name of the category.
* Hidden fields (`<input />` with `type` set to `hidden`) for the `owner` and `id` properties.
* A submit button (`type` set to `submit`) that is *inside* your form.
* A unique selector on the form so you can listen for submit events on it.

Here we go. First we need an event listener for click events on the edit category buttons. In response we'll call `editCategory()`.

Set up the definition for `editCategory()` amidst the other functions you have so far. Pass in `e` and prevent the default behavior.

Since we clicked on an edit category button we need to find out the id for the category that was clicked. Convert `e.target` to a jQuery object and traverse up to the closest `.category` (assuming you're following the suggested markup for category items). Then read the `data-id` attribute and store in a variable such as `categoryId`.

Now we'll use this category id to make a GET request to the category endpoint of our API. Open the API reference, find the provided sample to GET a specific category. Copy and paste that into your `editCategory()` function. This GET request is simpler than others we've made so far. The one thing you need to ensure is that your category id variable is used in this code snippet; `categoryID` is concatenated after `"category/"` by default but you should ensure this matches your actual variable.

Now in the response function in place of `// Response script` let's redefine the incoming `data` to be the `$.parseJSON()` form of that data and then log it. You should see the category details for the one you've clicked to edit. Debug as needed otherwise.

Let's take that data and inject it into the template you preloaded for the edit category modal. Remember that should be a global variable in which you later store a compiled Handlebars template. So call that compiled template variable and inject the `data` into it. Store the HTML result in a variable. Then select `body` and append that modal HTML to it. Finally, select the modal with jQuery and turn it on by adding the appropriate class or like this (if you're using Bootstrap and have a modal with an `id` of `edit-category`):

```js
$('#edit-category').modal('show');
```

So we should see the modal appear displaying the category we selected so that we can make any changes we want to the name. Inspect the browser code as well to ensure that the `owner` and `id` values are populating in the hidden fields as well.

Now we need to listen for submit events on edit category form. So in `initializeEventHandlers()` add a new listener for submit events on the edit category form itself. IN response call `saveCategory()`. Then define `saveCategory()` amidst your other functions. As before, pass in `e` and prevent the default behavior.

Since the user might just be calling up this modal for a second or third time we should also select any existing one and remove it from the DOM. So make sure your modal template as a whole can be easily selected and removed. Then add the code you need to accomplish this.

Convert `e.target` to a jQuery object and pass it into `serializeData()`. Store the resulting form data in a variable. Log that serialized data to the console to ensure it contains the full category data set including the `id`, the `owner` and the `name`. Debug as needed.

Next store specifically the `id` property in a new variable called `categoryID`.

Let's send this data off to our Category endpoint for the API using a PUT request.

Find the provided snippet for this from the API Reference page and paste it into `saveCategory()`. But where the snippet provided samples of the data to send:

```js
data: {
  name: "My Amazing List"
},
```

You can instead just assign your serialized form data variable to `data`:

```js
data: formData,
```

(Your variable might be named differently and don't forget to include the `,` comma).

Then in the success function convert `data` using `$.parseJSON()` and log the result to the console. If everything is successful you should see the changed category data. Now we just need to re-inject this changed data into the category template and replace the old one on the page with the new one.

So next inside the success function call your single category template global variable you compiled earlier and inject the `data` into it; store the resulting HTML snippet in a variable.

Next we need to replace the changed item in the category list. However, because our edits to this category could have changed where it should be placed in the list, we should simply reload the whole list. Good news! You already have a function that does that. Just call `getCategories()`. Then turn off your modal by revising the classes on the modal or by calling a utility function (such as `.modal('hide')` if you're using Bootstrap).

If you test your code now you should be able to successfully select, edit, and save changes to a category. The changes should appear after you save them but not when you just close your modal window. I've used Bootstrap which comes with built-in functionality for closing modals. But you might need to add one or more event listeners to handle closing your modal through the cancel button or otherwise.

Now for adding new categories. Our structure here will be similar to what we did for editing a category. First add an event listener for clicks on your add category button. In response call `addCategory()`. Then define that function, pass in `e` and prevent the default behavior.
Since we also might have an edit category modal from a previous time opening it lets select it and remove it just in case (as we did for editing a category).

Now we'll prepare a new category rather than loading one from the API. So define a variable to hold a new empty category and assign to it an object, something like this:

```js
var newCategory = {
  id: 0,
  name: '',
  owner: currentUser.id
};
```

We've given it an `id` of 0, and empty string for the `name` and assigned the current user's `id` as the `owner`. Log your newCategory to check that each of these turns out as expected.

Next we can create a new variable to hold the HTML snippet returned by a call to your global edit category template you compiled earlier and passing in the category you just created. Then select `body` and append this snippet to it. Finally, turn on the edit category modal just as you
did earlier. Test the results and you should see your edit category modal appear when you click to add a new category, but it should not have any category name in the box, and if you inspect the code you should see the category's `id` field set to `0` and the `owner` field set to the current user's `id`.

In order to save this new category we'll need to modify `saveCategory()`, since it is already set up as the event handler for when the edit category form is submitted. Our first few lines there are still fine: we prevent the default behavior and serialize the form data. And we store the category id in a variable.

But after that we need to determine whether we are editing an existing task and thus need to send a PUT request (that's what we're assuming in our code at this point) versus adding a new task that we need to send using a POST request (that's the new part we need to add). To keep things simple and modular let's allow these two different paths to be defined in two new functions. Grab the `$.ajax()` request you have as the remainder of `saveCategory()` and copy it. Cut it and paste it into a new function called `updateCategory()`. Allow a `data` variable to be passed into this new function. Then paste your code inside it. Update the code so that the data variable you're passing in the request's `data` property is `data` if it isn't already. Also replace `categoryID` with `data.id`.

Back in `saveCategory()` lets add a conditional statement. If the form data's `id` property is greater than 0 we can call `updateCategory()` and pass in our form data. Otherwise, call a new function `createCategory()` and pass the form data in.

Now define the `createCategory()` function. Allow `data` to be passed in. See the API reference for how to send a POST request to POST a new category and copy the provided code snippet. Where this snippet provides sample `name` and `owner` values you should instead assign these `data.name` and `data.owner` respectively to ensure your actual form data is sent to the request. We don't send an `id` since the database will automatically generate one for our new category.

Inside the success function we can do all the same steps we do in our `updateCategory()`'s success function. Simply reload the category list and close your edit category modal.

Test things out and you should successfully add a new category!

# Deleting Categories

Deleting categories should be pretty straightforward. Wherever you have planned to put a delete category button just add an event listener to it and call a `deleteCategory()` function in response. As you define that function pass in `e` and prevent the default behavior. You should consider how to find the intended category id for the category you intend to delete. If you placed such a button in the category item using a structure like what was proposed earlier here you can traverse up to the closest category and read the `data-id` attribute. Otherwise you'll need to do something else... it will vary depending on your structure.

Inside `deleteCategory()` see the API Reference, find the code snipper for deleting a category, and paste it into your function. make sure that your category id variable matches the one being passed in to the `DELETE` call. Then in the success function simply call `getCategories()` to reload your category list where you should now see the category you selected has been deleted.

**NOTE:** This leaves out an important step of verify the deletion to help the user avoid an accidental deletion. Feel free to refer to previous exercises if you'd like models for how to add this in.

# Adding and Editing Tasks

While a lot of what we do with adding and editing tasks will be very similar to what we did with categories, there are a few key differences:

* perhaps it goes without saying, but the structure of a task is a little more complicated than the structure of a category :)
* part of the ability to edit a task involves being able to select aspects of the task from other data in our application:
  * tasks can be organized into categories; so it might be helpful for us to have a global variable that is storing the current list of categories and is updated any time we reload the category list. We can then use such a variable when populating the dropdown of categories in the task editor.
  * tasks can be assigned one of several task types; these never change so we can simply load these at the start of the application and store them in a global variable for any time we need them.

Let's handle storing tasks first. Declare a global variable at the top of your document amidst the other global variables you have. Name it simple `categories` as long as this does not conflict with other variables you have in your application. Then, inside `getCategories()`, inside the success function, after you convert the incoming `data` with `$.parseJSON()` simply assign that data to your new global categories variable. Done.

Next let's ensure that task types load when the the application loads. Declare another global variable called `taskTypes`. Then create a new function amidst your other functions called `getTaskTypes()`. Inside this paste the GET request in the API Reference in order to GET a list of all task types. In the success function simply convert the incoming `data` with `$.parseJSON()` and then assign it to your `taskTypes` variable. Now just call `getTaskTypes()` inside the DRE before `initializeEventHandlers()`. Done. We're on a roll.

Next we'll enable our edit task modal and load in the data for the task the user clicked.

**More coming soon!**

# Marking Tasks as Complete

**Coming soon!**

# Deleting Tasks

**More coming soon!**
