This project presents a decent challenge for you to put together skills you've learned in this course.

Here's the lay of the land:

* Ensure your template files are set up correctly
* Code the login/logout and signup process
* Ensure that a user's categories and tasks load correctly
* Code the category editor
* Code the task editor
* Ensure that the task list filters when a category is selected


# Template Setup

First you must ensure the following is set up for each of your templates:

* Your login page should have:
  * have a link to the sign up page. The `href` can be `#signup` as we'll use an event handler to actually trigger the navigation. Follow this convention for other links referenced below.
  * a form allowing users to enter their email address and password. Event listeners will listen for the form to be submitted and respond with code to validate the user. If they're valid they'll be sent to the main page. If not, they'll still see the login page.
  * a bit of feedback text that can be turned on when needed to suggest that the credentials the user provided were invalid.
* Your signup page should have:
  * a link back to the login page.
  * a form allowing the user to provide their name, email address, password, and password confirmation to create an account. Event listeners will listen for the form to be submitted and respond with code to create the new account and log the user in or redirect them to the signup form to correct data entry if they provided invalid data.
* Your main page should have:
  * the application branding and containers into which the category list and task list will be loaded.
  * a link to log out.
* Your category list template should have:
  * a button to add a new category.
  * a link to show all tasks regardless of categories.
  * a loop that displays each category from the data set by pointing to the category template partial.
* Your category template partial should have:
  * an outermost container such as a `div` or `li` that includes the category's `id` in a `data-id` attribute.
  * the name of the category
  * a hyperlink around the category name that will have listeners attached to it to enable filtering the task list to only that category's tasks
* Your task list template should have:
  * a button to add a new task
  * a loop that displays each task from the data set by pointing to the task template partial.
* Your task template should have:
  * an outermost container such as a `div` or `li` that includes the task's `id` in a `data-id` attribute.
  * the description and deadline of the task in visible form.
  * classes or other configuration to change the task's appearance based on its task type.
  * a box the use can click to mark the task as "complete"
* Your edit category modal should have:
  * markup and classes that enable it to hide and reveal when needed. See your textbook or the bootstrap library as examples of how you could do this if needed. This should include either a close or cancel button that will dismiss the modal.
  * a form that allows the user to provide or edit the name of the category and a hidden field to hold the category's id. Listeners will respond when this form is submitted and process the new category or updates to a category and close the modal.
* Your edit task modal should have:
  * modal markup as mentioned in the previous main bullet. 
  * a form that allows the user to provide or edit the task's description, due date, task type (drop down or radio buttons), category (drop down), and a hidden field to hold the task id. Listeners will respond when the form is submitted to process the new task or updates to the task and close the modal.
