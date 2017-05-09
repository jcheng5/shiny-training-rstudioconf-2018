Follow-up points:

- Q: Why is [apps/adv-reactivity/cranlogs-antisolution.R](/apps/adv-reactivity/cranlogs-antisolution.R) not a good solution?
	- This works for the first package name entered, but not for subsequent ones. For subsequent ones the app will attempt to render the plot before typing of package name is finished, which is what we wanted to avoid in the exercise.
	- This is because assigning to output$xyz ISN'T saying "hey update this output", but rather, "this is the recipe for this output, you (Shiny) decide when to update it, if ever"
	- For more on this, in addition to the slides from the workshop on [Advanced Reactivity](/slides/05-adv-react/pdf), see Joe Cheng's [Effective Reactive Programming](https://www.rstudio.com/resources/webinars/shiny-developer-conference/) talk.

- Q: What happens when there is both index and fluidpage()

- Example: observeEvent() in a plot where the plot doesn't update when certain inputs change but it updates when others change
