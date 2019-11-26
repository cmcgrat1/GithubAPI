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

myProfileJSon = toJSON(myProfile, pretty = TRUE)
myProfileJSon




#OTHER USER
# Looking at deviantony who was trending on github

myData = GET("https://api.github.com/users/deviantony/followers?per_page=100;", gtoken)
stop_for_status(myData)
extract = content(myData)
#converts into dataframe
githubDB = jsonlite::fromJSON(jsonlite::toJSON(extract))
githubDB$login

# Retrieve a list of usernames
id = githubDB$login
user_ids = c(id)

# Create an empty vector and data.frame
users = c()
usersDB = data.frame(
  username = integer(),
  following = integer(),
  followers = integer(),
  repos = integer(),
  dateCreated = integer()
)

#loops through users and adds to list
for(i in 1:length(user_ids))
{
  
  followingURL = paste("https://api.github.com/users/", user_ids[i], "/following", sep = "")
  followingRequest = GET(followingURL, gtoken)
  followingContent = content(followingRequest)
  
  #Does not add users if they have no followers
  if(length(followingContent) == 0)
  {
    next
  }
  
  followingDF = jsonlite::fromJSON(jsonlite::toJSON(followingContent))
  followingLogin = followingDF$login
  
  #Loop through following users
  for (j in 1:length(followingLogin))
  {
    #Check for duplicate users
    if (is.element(followingLogin[j], users) == FALSE)
    {
      #Adds user to the current list
      users[length(users) + 1] = followingLogin[j]
      
      #Obtain information from each user
      followingUrl2 = paste("https://api.github.com/users/", followingLogin[j], sep = "")
      following2 = GET(followingUrl2, gtoken)
      followingContent2 = content(following2)
      followingDF2 = jsonlite::fromJSON(jsonlite::toJSON(followingContent2))
      
      #Retrieves who user is following
      followingNumber = followingDF2$following
      
      #Retrieves users followers
      followersNumber = followingDF2$followers
      
      #Retrieves number of repository the user has 
      reposNumber = followingDF2$public_repos
      
      #Retrieve year that each user joined Github
      yearCreated = substr(followingDF2$created_at, start = 1, stop = 4)
      
      #Add users data to a new row in dataframe
      usersDB[nrow(usersDB) + 1, ] = c(followingLogin[j], followingNumber, followersNumber, reposNumber, yearCreated)
      
    }
    next
  }
  #Stop when there are more than 10 users
  if(length(users) > 150)
  {
    break
  }
  next
}

#plot 1

#entering my plotly details
Sys.setenv("plotly_username"="cmcgrat1")
Sys.setenv("plotly_api_key"="AMSdPCyiiTrFagmA0DFz")

# comparing repositories and followers for ever year 
plot1 = plot_ly(data = usersDB, x = ~repos, y = ~followers, text = ~paste("Followers: ", followers, "<br>Repositories: ", repos, "<br>Date Created:", dateCreated), color = ~dateCreated)
plot1


#plot 2
#following vs followers year by year
plot2 = plot_ly(data = usersDB, x = ~following, y = ~followers, text = ~paste("Followers: ", followers, "<br>Following: ", following), color = ~dateCreated)
plot2

#upload to plotly
api_create(plot1, filename = "Repositories vs Followers")
#upload to plotly
api_create(plot2, filename = "Following vs Followers") 


