# A superclass for all the user algos to inherit from. 
# Should contain useful check functions. 
#
# Does not have a new() method.  

# the abstract class Algo, initialize the must-have components
Algo <- proto(
  algoName          = character(),            
  validSignalNames  = character(),
  signalFunctions   = character(),
  signalPriority    = numeric(),
  quantityFunctions = character()          
)

#####################################################################
#
Algo$getPrices <- function(., barIndex){}

#####################################################################
#
Algo$validate <- function(.)
{
  if (length(.$algoName)==0){
    msg <- paste("It is recommended your algorithm has a name!\n",
      "Please specify slot 'algoName'.", sep="")
    warning(msg)
  } else {
    cat("Checked existence of slot 'algoName'.\n")
  }
  
  if (length(.$validSignalNames)==0){  # do you have validSignalNames?
    msg <- paste(
      "Your algorithm needs a vector of signal names, as returned\n",
      "by the signal functions.  Please specify slot 'validSignalNames'.")
    stop(msg)
  } else {
    cat("Checked valid signal names:", .$validSignalNames, "\n")
  }

  if (!("NONE" %in% .$validSignalNames)){
    msg <- "Are you sure your signal functions don't return signal 'NONE'?"
    warning(msg)
  }
  
  if (!with(., exists("getPrices", mode="function"))){
    stop("Your algorithm doesn't have a getPrices method.  See documentation.")
  } else {
    cat("Detected a 'getPrices' method.\n")
  }
  
  if (length(.$quantityFunctions)==0){
    stop("Your algorithm doesn't define the slot quantityFunctions.  See documentation.")
  } else {
    cat("Checking existence of quantityFunctions ... ")    
    for (fun in .$quantityFunctions){ 
      if (eval(parse(text=paste("with(., !exists('", fun, "'))", sep=""))))
        stop("Cannot find method", fun, "in your algo!")
    }  
    ind <- !(names(.$quantityFunctions) %in% .$validSignalNames)
    if (any(ind)){
      stop(paste("Names", names(.$quantityFunctions)[ind],
                 "not in validSignalNames vector!"))
    }
    cat("Done.\n")
  }

  if (length(.$signalFunctions)==0){
    msg <- paste("Your algorithm doesn't register any signal functions! ",
      "Add a 'signalFunctions' slot.")
  } else {
    cat("Checking existence of signalFunctions ... ")
    for (fun in .$signalFunctions){ 
      if (eval(parse(text=paste("with(., !exists('", fun, "'))", sep=""))))
        stop("Cannot find method", fun, "in your algo!")
    }  
    cat("Done.\n")
    if (length(.$signalPriority)!=
        length(.$signalFunctions)){
      stop("signalPriority and signalFunctions don't have the same lengths!")
    } else {
      if (any(.$signalPriority <= 0)){
        msg <- paste("Check signalPriority!\n",
          "Signal priority needs to be greater than 0.\n",
          "(Signal 'NONE' has priority 0.)\n")
        stop(msg)
      }
      cat("Checked 'signalPriority' slot.\n")
    }
  }
  
  if (!(with(., exists("new", mode="function")))){
    stop(paste("Your algorithm doesn't have a constructor!\n",
         "Please create a 'new' method.\n", sep=""))
  } else {
    cat("Detected a 'new' method.\n")
  }

  cat("\nAll tests passed succesfully.\n")
  
}











