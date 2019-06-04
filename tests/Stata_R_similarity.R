# Retrieve ONE country with default parameters
povcalnet(country = "ALB")

# Retrieve MULTIPLE countries with default parameters
povcalnet(country = "all")
povcalnet(country = c("ALB", "CHN"))

##### Retrieve countries from a specific region or income group

# Get countries from ECA region
eca <- get_countries("ECA")
povcalnet(country = eca)

# Get countries from Lower Income group
lic <- get_countries("LIC")
povcalnet(country = lic)

##### Change poverty line
povcalnet(country = c("ALB", "CHN"),
          poverty_line = 10)

# Select specific years
povcalnet(country = c("ALB"),
          year = c(2002, 2012))

povcalnet(country = c("ALB"),
          year = 2002)

# Change coverage
povcalnet(country = "all",
          coverage = "urban")

povcalnet(country = "all",
          coverage = "rural")

# Aggregation
povcalnet(country = c("ALB", "CHN"),
          aggregate = TRUE)

# Fill gaps when surveys are missing for specific year
povcalnet(country = c("ALB", "CHN"),
          fill_gaps = TRUE)

# PPP
povcalnet(country = c("ALB", "CHN"),
          ppp = c(50, 100))

povcalnet(country = c("ALB", "CHN"),
          ppp = c(10, 20),
          poverty_line = 4,
          aggregate = TRUE)
