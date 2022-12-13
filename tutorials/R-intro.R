#' ---
#' title: "Basic Introduction to R"
#' author: "Michael Friendly"
#' ---

#' ## Simple calculations
#' Results of expressions are printed; assignments (`<-`) are not

#' Circumference and area of a circle of radius=3
2 * pi * 3
pi * 3^2

#' Assigning variables
radius <- 3
circumference <- 2 * pi * radius
circumference

#' Assign, and print
(area <- pi * radius^2)

area/circumference

#' ## Vectors

degreesC <- c(0, 5, 10, 20, 25, 30)
degreesF <- (9/5) * degreesC + 32
degreesF

#' a simple plot(x,y)
plot(degreesC, degreesF, type="b")

#' ### shorthand functions: :, seq(), rep()
1:10
10:1
seq(1, 10)
seq(1, 5, by=0.5)

rep(1:4, times=2)
rep(1:4, each=2)

#' ## Matrices
#' matrix(values, nrow, ncol) reshapes the values with nrow rows and ncol columns
(matA <- matrix(1:8, nrow=2, ncol=4))
(matB <- matrix(1:8, nrow=2, ncol=4, byrow=TRUE))

#' ### row and column labels: dimnames()
dimnames(matA) <- list(sex=c("M", "F"), group=LETTERS[1:4])
matA

#' ### see the structure of an R object
str(matA)

#' ## Arrays
#' array(values, dim) reshapes values into an array with dimensions dim

arrayA <- array(1:16, dim=c(2,4,2))  # 2 rows, 4 columns, 2 layers
arrayA

str(arrayA)

#' assign dimension names
dimnames(arrayA) <- list(sex = c("M", "F"),
                         group = letters[1:4],
                         time = c("Pre", "Post"))
arrayA
str(arrayA)


