# shiny-training-2017-05-genentech

Slides and demo materials for the 2-day Intermediate Shiny Workshop at Genentech, May 2017

## Required packages

- cranlogs
- DT
- flexdashboard
- gapminder
- ggplot2
- jsonlite
- lubridate
- miniUI
- shiny
- shinyBS
- shinydashboard
- shinyjs
- shinythemes
- shinytoastr
- stringr
- tidyverse

## Schedule

### Day 1

9 - 9:15am        - Overview of the workshop and setup
9:15 - 10:30am    - A fast introduction to Shiny (01-fast-intro)
10:30 - 11am      -	Break
11:00am - 12:00pm - Reactive programming, part 1 (02-reactive-prog-1)
12 - 1pm - 		    - Lunch
1 - 2:30pm 	      - Understanding UI (03-understanding-ui)
2:30 - 3pm        - Break
3 - 4pm           - Reactive programming, part 2 (04-reactive-prog-2)

### Day 2

9 - 10am          - Advanced reactivity (05-adv-reactivity)
10:30 - 11am      -	Break
11am - 11:30pm    - Modules (06-modules)
11:30am - 12pm    - Bookmarking (07-bookmarking)
12 - 1pm - 		    - Lunch
1 - 1:30pm		    - Interactive visualizations with ggplot2 (08-interactive-ggplot2)
1:30 - 2pm        - Dashboards (09-dashboards)
2 - 2:30pm 	      - Troubleshooting (09-troubleshooting)
2:30 - 3pm        - Break
3 - 4pm           - Guided sandbox exercises + Walkthrough of cool app (crandash, collegescorecard, superzip)


## Notes from before -- delete when schedule is final

## Outline

### Day 1, Morning: Shiny essentials

- Intro
	- Encourage people to move around at lunch and next day
	- Encourage TAs to walk around and snoop :)
- 9 - 9:50 am - Part 1: A fast introduction to Shiny (01_fast_intro)
	- High level view
	- Anatomy of a Shiny app
	- File structure
	- Sharing your app
- 10 - 10:50 am - Part 2: Reactive programming (02_reactive_prog)
	- Reactivity 101
	- Reactive objects
	- Reactive functions
- 11am - 12 pm - Part 3: Understanding UI (in progress)
  - UI function calls are just HTML generators
		- Tag functions (htmltools)
		- browsable, print(browse=TRUE)
		- Raw HTML with HTML()
	- HTML dependencies (high level)
	- Decompose/demystify some common Shiny UI calls
	- HTML templates

### Day 1, Afternoon: Graphics and visualization

- 1:30 - 2:20 pm - Part 1: Customization (in progress)
	- Using ggplot2 in a Shiny app
	- Customizing graphics, dynamic sizing, etc.
- 2:30 - 3:20 pm - Part 2: Interactive base graphics and ggplot (in progress)
  - Click, hover
	- Brushing
	- Lots of exercises
	- Maybe cover stopApp?
- 3:30 - 4:30 pm - Part 3: Extending Shiny with htmlwidgets (in progress)
	- Leaflet
	- Time permitting: DT and Dygraphs
- 4:30 - 6 pm - Networking / coding / office hours

### Day 2, Morning: Increasing performance

- 9 - 9:50 am - Part 1: Advanced reactivity (03-adv-reactivity)
	- Stop - delay - trigger
	- Performance considerations
	- Reactivity best practices
	- rxtools--if it exists (debounce, long running tasks, reduce over time)
- 10 - 10:50 am - Part 2: Performance and troubleshooting (in progress)
	- Other performance considerations (30 mins)
		- profvis
			- Find a good example... ugh
		- calculate things as few times as possible
			- aggregate data in advance outside of app and load that
	- Tips for troubleshooting / debugging (30 mins)
		- print line debugging from inside of a shiny app
			- if inside of a render print messages get hidden, show those
		- how to use the rstudio debugger
			- not always good idea to go to it first
			- backtraces
		- reactlog
			- if you have a simpler app / just getting started with reactivity
			- if you get reactivity, it's less useful
		- common errors
			- extra or missing commas in the UI
			- accessing a reactive outside of a reactive context
			- forgetting the paranthesis for accessing reactives
- 11am - 12 pm - Part 3: Modules (04_modules)

### Day 2, Afternoon: [NEED A NAME]

- 1:30 - 2:20 pm - Part 1: Bookmarkable state (05_bookmark)
	- updated examples
- 2:30 - 3:20 pm - Part 2: Using databases with Shiny
- 3:30 - 4 pm - Part 3: Distribution / Deployment (30 min) (in progress)
	- Distribution
	- Hosting
- 4 - 5pm - Q&A with Joe
- 5 - 6 pm - Networking / coding / office hours


Other possible topics
- Dynamic UI
  - conditionalPanel
	- renderUI
	- insertUI/removeUI
- API
