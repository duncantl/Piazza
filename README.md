# Get Dourse Data from Piazza

This retrieves information about 

+ questions
+ answers 
+ basic user information (name, email, userId)
+ statistics

from a Piazza course to which you have access.

It also provides a reusable framework for adding other queries, e.g., get_online_users.


## Primary Functions

+ getCoursePosts()
+ getStats()
+ getUserInfo()


+ mkPiazzaCon()



## Usage

+ Use the Developer Tools to monitor Network requests in your Web browser (Cmd-Option I on OSX for
  Firefox.)
+ Visit the course page on Piazza.
+ Copy the cookie in the HTTP **request** (not response) for the first request.
+ Copy that to a file named piazza.cookie either in the current working directory or your home
  directory.
    + Alternatively, assign it directly to a variable in R and use that.


+ Set the option PiazzaCourseID to the course identifier for the Piazza course
   + E.g. In the URL for a  post https://piazza.com/class/lufnnjs0ub36ht/post/219, the 
     course ID is `lufnnjs0ub36ht`.



