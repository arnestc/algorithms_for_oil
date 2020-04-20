################################################################################
# - Problem 3: design a recursive algorithm to produce in a plot the
#               Sierpinski's triangle.
function s_triangle(dim::Int64)
    #dim is the dimension of the initial square
    x_0, y_0 = 0, 0         #starting points
    x_n, y_n = dim, dim     #ending points
    vec_x, vec_y = [], []   #vectors of x,y-points respectively

    function s_points(x_f, x_l, y_f, y_l)
        #recursive function to find the vertices of the triangles thath build
        #Sierpinski's Triangle
        p_x = div(x_f + x_l, 2)     #x-pivot
        p_y = div(y_f + y_l, 2)     #y-pivot
        step_x = p_x - x_f
        step_y = p_y - y_f
        #step_x and step_y are controller variables to finde the base case,
        #more explicitly, the algorithm sould build a triangle only when the
        #distance between two vertices (in x and y directions) is 1
        if step_x == 0 || step_y == 0
            return
        elseif step_x == 1 || step_y == 1
            #Then it builds the base-triangles
            #Base case:
            #(1,1)
            append!(vec_x, [p_x-1, p_x, p_x-1, NaN])
            append!(vec_y, [p_y, p_y, p_y+1, NaN])
            #(2,1)
            append!(vec_x, [p_x-1, p_x, p_x-1, NaN])
            append!(vec_y, [p_y-1, p_y-1, p_y, NaN])
            #(2,2)
            append!(vec_x, [p_x, p_x+1, p_x, NaN])
            append!(vec_y, [p_y-1, p_y-1, p_y, NaN])
            return vec_x, vec_y
        end
        s_points(x_f,p_x,y_f,p_y)
        s_points(p_x,x_l,y_f,p_y)
        s_points(x_f,p_x,p_y,y_l)
        return vec_x, vec_y
    end
    s_points(x_0, x_n, y_0, y_n)
    return vec_x, vec_y
end
#gr();
#plot(e,f,seriestype=:shape,linewidth=-1,grid=true,axis=true,label=false);
#savefig("test5.pdf");
################################################################################

################################################################################
# - Problem 7: design a recursive algorithm version (in-place) for the Quick
#              Sort, in which arguments are the indices i,dim into the original
#              vector.
function qsort(A, i=1, dim=length(A))
                                #V is the vector, k is the index searched, i is
                                #the current index, d is the dimension of the 
                                #vector.
    #Base case:
    if dim > i
        pivot = A[rand(i:dim)]#p is the pivot
        left_index, right_index = i, dim#left_i and rigth_i are the delimitors of the
                                #vector
        while left_index <= right_index
            while A[left_index] < pivot #These two while cycles individuate the
                                        #first two vector elements (through
                                        #their indices) which are not ordered
                                        #each other.
                left_index += 1
            end
            while A[right_index] > pivot
                right_index -= 1
            end
            if left_index <= right_index    #Then the two vector elements are
                                            #individuated and so swapped.
                A[left_index], A[right_index] = A[right_index], A[left_index]
                left_index += 1
                right_index -= 1
            end
        end
        qsort(A,i,right_index)
        qsort(A,left_index,dim)
    end
    return A
end
################################################################################

################################################################################
# - Problem 8: How can we extend the recursion in Example 4 to compute the
#              actual values (i^*, j^*), the argument of the max?
function max_sum(V)     #This is the recursive algorithm of the Exercise 4. The
                        #ptoblem now is to "extend" this algorithm to the case
                        #in which we want to return the indices that generate
                        #the maximum.
    j = length(V)
    function sum_mj(V,j=length(V))
        if j == 1
            return V[j]
        else
            return V[j] + sum_mj(V,j-1)
        end
    end
    return maximum(sum_mj(V[i:i+1]) for i=1:length(V)-1)
end

function max_sum_ind(V, index = 1, first = 0, second = 0, max = 0)
    dim = length(V)
    if index + 1 < dim + 1
        sum = V[index] + V[index+1]
        if sum > max
            first = index
            second = index + 1
            return max_sum_ind(V, index+1, first, second, sum)
        else
            return max_sum_ind(V, index+1, first, second, max)
        end
    end
    return max, first, second
end
################################################################################

################################################################################
# - Problem 9: Formulate and solve a two-dimensional variant of Example 4.
function max_sum_2d(V)
    j = length(V)
    function sum_mj(V,j=length(V))
        if j == 1
            return V[j]
        else
            return V[j] + max(0,sum_mj(V,j-1))
        end
    end
    return max(maximum(sum_mj(V[i:i+1,1]) for i=1:length(V[:,1])-1),
        maximum(sum_mj(V[i:i+1,2]) for i=1:length(V[:,2])-1),
        maximum(sum_mj(V[i,:]) for i=1:length(V[:,1])-1))
end
################################################################################

################################################################################
# - Problem 10: When possible, a binary division of the problem as in MergeSort
#               may be preferable to tail recursion, as the computation can be
#               parallelized on a computer. Instead of tail recursion, devise a
#               binary divide-and-conquer approach to solve Example 4.
function max_sum_bin(V)
    d = length(V)
    pivot = div(d, 2)
    #println("dim: ", d, ", pivot: ", V[pivot])
    #println(V[1:pivot], ",", V[pivot:end])
    #println("\n")
    #if pivot == 1 && println(V[pivot] + V[pivot+1]) end
    #println("\n")
    #println("\n")
    pivot == 1 && return V[pivot] + V[pivot+1]
    max_1 = max_sum_bin(V[1:pivot])
    max_2 = max_sum_bin(V[pivot:d])
    return max(max_1,max_2)
end
################################################################################

################################################################################
# - Problem 11: Design a recursive function to print the b-subsets of {1,...,n}
#               of size k, where b is the binomial (n,k)=n!/[(n-k)!k!]
#
#
function rec_subs(n::Int64, k::Int64)
    switch = n - k
    subs = zeros(Int64, k)
    function fsubs(index = 1, val = 0)
        for i = 0:switch
            subs[index] = index + i
            if index < k
                fsubs(index + 1, i)
            else
                println(subs)
            end
        end
    end
    if k <= n
        println(floor(Int, factorial(n)/(factorial(n-k)*factorial(k)))
        , " subsets:\n")
        return fsubs()
    else
        println("Error: k must be smaller than n.")
    end
end
################################################################################

################################################################################
# - Problem 12: Given an array of numbers {v(0),...,v(n-1)}, find the maximum k
#               such that there exists π:0 ≤ ... ≤ π(k) ≤ n-1 with
#               v(π(1)) ≤ ... ≤ v(π(k).
function max_ind(V, index = 1, v_p = V[1], k = 1)
    n = length(V)
    if index + 1 <= n
        if v_p <= V[index+1]
            v_p = V[index+1]
            k = index + 1
            return  max_ind(V, index + 1, v_p, k)
        else
            return  max_ind(V, index + 1, v_p, k)
        end
    end
    println("Element: ", v_p, " -> position: ", k)
end
################################################################################
