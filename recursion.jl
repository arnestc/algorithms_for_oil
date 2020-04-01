################################################################################
# - Problem 3: design a recursive algorithm to produce in a plot the
#               Sierpinski's triangle.
#using Plots;
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
    #Base case:
    if dim > i
        pivot = A[rand(i:dim)]  #One can notices that if the starting vector is
                                #ordered (or partial ordered), the algorithm is
                                #strongly inefficient. A way to bypass the
                                #problem is to not choose as pivot the first
                                #element of the vector, but the middle or a
                                #random one.
        left_index, right_index = i, dim
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
