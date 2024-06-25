getCoursePosts =
function(courseID = getCourseID(), con = mkPiazzaCon(...), ..., sleep = 1)
{
    info = getIAD.CSRF(con)
    # update the connection with CSRF-Token header and others.
    con = updatePiazzaCon(info['csrf'], con = con)

    # Get the feed of "all" the posts 0 to 1000 by default
    feed = getFeed(con, info['aid'], courseID)

    # Get each post. Need to wait between requests or Piazza will give a error and ask us to wait.
    lapply(feed$result$feed, function(f) { Sys.sleep(sleep); getPost(f$id, info['aid'], con)})
}


mkPiazzaCon =
    #
    # Create a curl connection witht the appropriate request header fields and values,
    # specifically including the CSRF-Token.
    #
    # Add csrf = TRUE as parameter and then get and update the con here.
    # Need to return the aid value with the con.
    #
function(cookie = getCookie(), con = getCurlHandle(), ...)
{
    curlSetOpt(curl = con, ...,
               cookie = cookie,
               followlocation = TRUE,
               cookiejar = "")

    con
}

updatePiazzaCon =
function(csrf, con)
{
    curlSetOpt(curl = con,
               httpheader = c('CSRF-Token' = unname(csrf),
                              'Content-Type' = 'application/json;charset=UTF-8'))
    con
}


getFeed =
function(con, aid = "khutpb2e64i2", courseID = "kfj1hd7qyia1tq", offset = 0, limit = 1000)
{
    params = list(method = "network.get_my_feed",
                  params = list(nid = courseID, offset = as.integer(offset), limit = as.integer(limit),
                                sort = "updated", student_view = "false"))

    doRequest(params, con, aid)
}


getPost =
function(qid, aid, con, courseID = getCourseID())
{
   body  = list(method = "content.get", params = list(cid = NA, nid = courseID, "student_view" = FALSE))
   body$params$cid = qid

   doRequest(body, con, aid)
}


getIAD.CSRF =
function(con = getCurlHandle(cookie = getCookie()), courseID = getCourseID(),
         homeURL = sprintf("https://piazza.com/class/%s", courseID))
{
    h1 = getURLContent(homeURL, curl = con)
    doc = htmlParse(h1)

    sc = getNodeSet(doc, "//meta[@name = 'csrf_token']")
    if(length(sc))
        return(c(csrf = unname(xmlGetAttr(sc[[1]], "content")), aid = ""))
    
    sc = getNodeSet(doc, "//script[@type = 'text/javascript' and contains(., 'aid\":')]")

    txt = xmlValue(sc[[1]])
    aid = gsub('.*"aid":"([^"]+)".*', "\\1", txt)

    crsf = getNodeSet(doc, "//meta[@name = 'csrf_token']/@content")[[1]]

    c(csrf = unname(crsf), aid = aid)
}

getCookie =
function(file = file.path(c(".", "~"), "piazza.cookie"))
{
    if(any( e <- file.exists(file)))
        return(readLines(file[e][1], warn = FALSE)[1])
    
    RBrowserCookies::getLoginCookie("piazza.com")
}

#################################
# Utility worker functions

mkURL =
    # Create the URL by substituting in the method and aid
function(method, aid)
{
    sprintf("https://piazza.com/logic/api?method=%s&aid=%s", method, aid)
}


doRequest =
    # Perform the POST request, converting the parameters to JSON
    # and generating the appropriate URL for the method.
    # Assumes the con contains the CSRF-Token.
function(params, con, aid)
{
    zz = httpPOST(url = mkURL(params$method, aid),
                  postfields = toJSON(params),
        curl = con)

    ans = fromJSON(zz)

    # check for error.
    if(length(ans$error))
        stop("Problem with piazza request: ", ans$error)

    ans
}


getStats =
function(courseID = getCourseID(), csrf = getIAD.CSRF(con)["csrf"], con = mkPiazzaCon(...), ...)
{
   params = list(method = "network.get_stats", params = list(nid = courseID))

   ans = httpPOST("https://piazza.com/main/api", postfields = toJSON(params), curl = con,
                  httpheader = c("Content-Type" = "application/json",
                                 "CSRF-Token" = as.character(csrf)),
                  followlocation = TRUE)

   fromJSON(ans)
}


getCourseID =
function()
{
   getOption("PiazzaCourseID", stop("Need to specify the piazza course id; no PiazzaCourseID option set"))
}
