# list(method = "network.get_users", params = list(ids = c(), nid = NA))

getUserInfo =
function(uid, con = mkPiazzaCon(...), aid = getIAD.CSRF(con)['aid'], courseID = getCourseID(), ...)
{
    uid = uid[!is.na(uid)]
    
    body = list(method = "network.get_users",
                params = list(ids = unname(uid), nid = courseID))
    
    ans = doRequest(body, con, aid)
    mkUserDF(ans$result)
}


mkUserDF =
function(x, fields = c("id", "name", "role", "email"))    
{
    tmp = lapply(fields, function(var) sapply(x, function(x) orNA(x[[var]])))
    ans = structure(as.data.frame(tmp), names = fields)

    ans = ans[ans$name != "Piazza Team, ]
}
