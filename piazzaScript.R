# Needs cookie in ./piazza.cookie ~/piazza.cookie or .
con = mkPiazzaCon()
# From the URL for any post before the post/number
options("PiazzaCourseID" = "lufnnjs0ub36h")

posts = getCoursePosts()


#info = piazza:::getIAD.CSRF(con)
# update the connection with CSRF-Token header and others.
#con = piazza:::updatePiazzaCon(info['csrf'], con = con)

# Get the feed of "all" the posts 0 to 1000 by default
#feed = getFeed(con, info['aid'])

# Get each post. Need to wait between requests or Piazza will give a error and ask us to wait.
#posts = lapply(feed$result$feed, function(f) { Sys.sleep(1); getPost(f$id, info['aid'], con)})
