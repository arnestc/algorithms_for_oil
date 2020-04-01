################################################################################
# - Exercise 3: design a recursive algorithm to produce in a plot the
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
