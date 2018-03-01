if (interactive()) {
  # Open this application in multiple browsers, then close the browsers.
  shinyApp(
    ui = basicPage("onStop demo"),
    
    server = function(input, output, session) {
      onStop(function() cat("Session stopped\n"))
    },
    
    onStart = function() {
      cat("Doing application setup\n")
      
      onStop(function() {
        cat("Doing application cleanup\n")
      })
    }
  )
}
