mkPostDF =
function(posts)
{

    acc = function(var)
             sapply(posts, function(x) orNA(x$result[[var]]))
    
    data.frame(
        type = acc("type")
        nr = acc("nr")
        id = acc("id")
        created = as.POSIXct(strptime(acc("created"), "%Y-%m-%dT%H:%M:%S")),
        numChildren = sapply(posts, function(x) length(x$result$children))
        )        
}

orNA =
function(x, defaultValue = NA)    
{
    if(length(x))
        x
    else
        defaultValue
}
