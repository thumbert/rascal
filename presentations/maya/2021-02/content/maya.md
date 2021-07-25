class: center, middle
name: title
count: false

.purple[.maya[Maya]]

A modern commodity pricing interface

.footnotesize[9 February 2021]

.small[.grey[Adrian A. Dr&abreve;gulescu]]

---
# Why

* When SecDb was retired, we lost the ability to price simple 
  deals via calculators
* Endur has *similar* functionality, but the experience is less fluid
  
A gap that we should fill  

There is interest on the floor for getting this functionality back

I started toying with this idea during last year (nights and weekends) 

---
# What do we want?

Replicate the good parts of SecDb calculators using modern technology

* An easy-to-use, single purpose interface dedicated to pricing
* *Always* on, fast to launch 
* Fast to recalculate, near instant feedback
* Ability to change pricing date
* Show forward and realized values
* Ability to save and load calculators
* Ability to customize quantities and prices; custom buckets
* Integrated reporting from the *same* screen

---
# .maya[Maya]

Current status
* In proof of concept stage
* Implemented as a web application, runs in the browser  
* *Always* on.  No additional software needed by user  
* Fast has dictated not to depend on existing infrastructure   

--


What works?
* Two instruments supported: swaps and daily options in ISONE
* Two reports: PnL and position report
* Saving and loading calculators 


---
class: center, middle

# .purple[Show me the demo!]

---
# Implementation details

* Open source software, can be integrated into our stack easily
* Implemented as a .purple[Flutter] frontend with a .purple[MongoDb] backend
* A .purple[Dart] server and packages implement the business logic   
* Both the server and MongoDb run from my PC (*not sustainable*)
.center[![image](content/dart_and_flutter2.png)]
.center[.p60[![image](content/mongodb.png)]]
  

---
# Design decisions

* Using a new curve hierarchy (really?!)
* Prices are stored in a different format for fast access (~20 ms for 3 buckets)
* Same for volatility surfaces and hourly shape curves    
* Monthly marks expand into daily marks automatically
* No need to mark curves that don't change daily (e.g. basis curves)



---


# Next steps?

* This development has been done without commercial IT involvement so far, 
  and uses a different technology stack    
* For a successful floor wide rollout it will need IT resources
* I will engage IT to make .tangerine[Maya] a supported application
* It will require cooperation and autonomy  
* I would like to remain involved with the project   
