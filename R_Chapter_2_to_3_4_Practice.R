library(tidyverse) # For accessing ggplot2
mpg

ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy))
ggplot(data = mpg)

# ggplot(data = <DATA>) + 
# <GEOM_FUNCTION>(mapping = aes(<MAPPINGS>))

# 3.2.4 Exercises
# 1. Nothing, just a blank screen
# 2. 234 rows, 11 columns
?mpg
# 3. The type of drive train, where f = front-wheel drive, r =
#   rear wheel drive, 4 = 4wd
ggplot(data = mpg) + geom_point(mapping = aes(x = cyl, y = hwy))
# 4. Done, hwy has a negative correlation with cyl
ggplot(data = mpg) + geom_point(mapping = aes(x = drv, y = class))
# 5. Not useful because it doesn't show number or frequency, it just shows
#   what's possible out there (e.g., an suv with 4 and r drive exist)

# 3.3
# Mapping color to class
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy, 
                                              color = class))

# Mapping size to class (will get a warning though since we're mapping an
# unordered (discrete) variable (class) to an ordered aesthetic (size))
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy, 
                                              size = class))

# Mapping transparency (alpha) to class
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy, 
                                              alpha = class))

# Mapping shape to class (default to only six shapes)
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy, 
                                              shape = class))

# Btw, x and y are also aesthetics; basically, they are both visual
# properties that can map to variables to display information about
# the data. The legend here is replaced by the axis line with tick
# marks and a label (the axis line acts as a legend, as it explains
# the mapping between locations and values)

# Setting aesthetic properties of geom manually (e.g., making all the points
# in plot be blue) by placing aesthetic outside of aes()
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy),
                                color = 'blue')

# 3.3.1 Exercises
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy,
                                              color = 'blue'))
# 1. You placed the color inside the aesthetic instead of outside it,
#   and it instead set the color to be able to the string "blue", and not
#   equal to something like scaling the color based on class
?mpg
mpg
# 2. Anything that has just numbers vs combinations of letters and #s.
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy,
                                              color = cyl))
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy,
                                              size = cyl))
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy,
                                              shape = cyl))
# 3. There's a gradient scale that pops up for color. There's multiple
#   sizes that pop up for size, and it doesn't work for shape.
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy,
                                              size = displ))
# 4. It still works, but doesn't really tell you any more information.
#   Basically, if you map size or color to x, the larger the x, the larger
#   the size (or darker/lighter the color). The same happens with y.
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy,
                                              stroke = 2))
?geom_point
# 5. Stroke modifies the width of the border
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy,
                                              color = displ < 5))
# 6. It gets you a boolean of colors instead for comparison

# 3.4 Common problems
# You can press ESCAPE to abort processing the current command
# You also need to put the "+" at the end of the line, not start
# ?<function_name> will also get you help
# Selecting the function name and then pressing F1 will also work





