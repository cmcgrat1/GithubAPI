install.packages("jsonlite")
library(jsonlite)
install.packages("httpuv")
library(httpuv)
install.packages("httr")
library(httr)

# Can be github, linkedin etc depending on application
oauth_endpoints("github")

# Change based on what you 
myapp <- oauth_app(appname = "Access_Github",
                   key = "669e0ee8a432c30178f2",
                   secret = "5d6914b0d869b32a36830cd05e30e946d9a038f9")

# Get OAuth credentials
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)

# Use API
gtoken <- config(token = github_token)
req <- GET("https://api.github.com/users/jtleek/repos", gtoken)

# Take action on http error
stop_for_status(req)

# Extract content from a request
json1 = content(req)

# Convert to a data.frame
gitDF = jsonlite::fromJSON(jsonlite::toJSON(json1))

# Subset data.frame
gitDF[gitDF$full_name == "jtleek/datasharing", "created_at"] 

-------
  # Subset data.frame
  gitDF[gitDF$full_name == "jtleek/datasharing", "created_at"] 

#first analysis of my own profile
myProfile = fromJSON("https://api.github.com/users/cmcgrat1")
myProfile$followers
myProfile$public_repos

myFollowers = fromJSON("https://api.github.com/users/cmcgrat1/followers")
myFollowers$login
length = length(myFollowers$login)
length #Number of followers

myProfile$following
following = fromJSON("https://api.github.com/users/cmcgrat1/following")
following$login

repository = fromJSON("https://api.github.com/users/cmcgrat1/repos")
repository$name
repository$created_at

myProfile$bio

