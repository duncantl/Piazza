con = mkPiazzaCon() 
info = getIAD.CSRF(con)
# update the connection with CSRF-Token header and others.
con = updatePiazzaCon(info['csrf'], con = con)

# Get the feed of "all" the posts 0 to 1000 by default
feed = getFeed(con, info['aid'])

# Get each post. Need to wait between requests or Piazza will give a error and ask us to wait.
posts = lapply(feed$result$feed, function(f) { Sys.sleep(1); getPost(f$id, info['aid'], con)})
